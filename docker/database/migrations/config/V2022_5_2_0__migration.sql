--
-- EDW | Replace invalid tab indentations in star_loan ETL queries, add unit test to identify tab indents in yaml files
-- https://app.asana.com/0/0/1202220564764413
--

/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
	VALUES ('ETL-200040', 1, 'WITH borrower_aux_current_residence_dim_incl_new_records AS (
    SELECT ''borrower_pid~data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(borrower.b_pid AS TEXT), ''<NULL>'') || ''~1'' AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , borrower.data_source_updated_datetime AS data_source_modified_datetime
        , borrower_dim.dwid AS borrower_dwid
        , borrower.b_pid AS borrower_pid
        , current_borrower_residence_place.pl_street1 AS street1
        , current_borrower_residence_place.pl_street2 AS street2
        , current_borrower_residence_place.pl_city AS city
        , current_borrower_residence_place.pl_postal_code AS postal_code
        , county.c_name AS county_name
        , current_borrower_residence_place.pl_county_fips AS county_fips
        , current_borrower_residence_place.pl_state AS state
        , current_borrower_residence_place.pl_state_fips AS state_fips
        , current_borrower_residence_place.pl_country AS country_code
        , country_type.value AS country
        , GREATEST(borrower.etl_end_date_time, current_borrower_residence.etl_end_date_time,
                   current_borrower_residence_place.etl_end_date_time, county.etl_end_date_time, country_type
                       .etl_end_date_time, borrower_dim.etl_end_date_time) AS max_source_etl_end_date_time
    FROM (
        SELECT <<borrower_partial_load_condition>> AS include_record
            , borrower.*
            , etl_log.etl_end_date_time
        FROM history_octane.borrower
            LEFT JOIN history_octane.borrower AS history_records
                ON borrower.b_pid = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON borrower.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.b_pid IS NULL
    ) AS borrower
        JOIN (
            SELECT <<borrower_residence_partial_load_condition>> AS include_record
                , borrower_residence.*
                , etl_log.etl_end_date_time
            FROM history_octane.borrower_residence
                LEFT JOIN history_octane.borrower_residence AS history_records
                    ON borrower_residence.bres_pid = history_records.bres_pid
                        AND borrower_residence.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON borrower_residence.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.bres_pid IS NULL
        ) AS current_borrower_residence
            ON borrower.b_pid = current_borrower_residence.bres_borrower_pid
                AND current_borrower_residence.bres_current IS TRUE
        JOIN (
            SELECT <<place_partial_load_condition>> AS include_record
                , place.*
                , etl_log.etl_end_date_time
            FROM history_octane.place
                LEFT JOIN history_octane.place AS history_records
                    ON place.pl_pid = history_records.pl_pid
                        AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON place.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.pl_pid IS NULL
        ) AS current_borrower_residence_place
            ON current_borrower_residence.bres_place_pid = current_borrower_residence_place.pl_pid
        LEFT JOIN (
            SELECT <<county_partial_load_condition>> AS include_record
                , county.*
                , etl_log.etl_end_date_time
            FROM history_octane.county
                LEFT JOIN history_octane.county AS history_records
                    ON county.c_pid = history_records.c_pid
                        AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON county.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.c_pid IS NULL
        ) AS county
            ON current_borrower_residence_place.pl_county_pid = county.c_pid
        JOIN (
            SELECT <<country_type_partial_load_condition>> AS include_record
                , country_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records
                    ON country_type.code = history_records.code
                        AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON country_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS country_type
            ON current_borrower_residence_place.pl_country = country_type.code
        JOIN (
            SELECT <<borrower_dim_partial_load_condition>> AS include_record
                , borrower_dim.*
                , etl_log.etl_end_date_time
            FROM star_loan.borrower_dim
                JOIN star_common.etl_log ON borrower_dim.etl_batch_id = etl_log.etl_batch_id
        ) AS borrower_dim
            ON borrower.b_pid = borrower_dim.borrower_pid
    WHERE GREATEST(borrower.include_record, current_borrower_residence.include_record,
                   current_borrower_residence_place.include_record, county.include_record, country_type
.include_record, borrower_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT borrower_aux_current_residence_dim_incl_new_records.*
FROM borrower_aux_current_residence_dim_incl_new_records
    LEFT JOIN star_loan.borrower_aux_current_residence_dim
        ON borrower_aux_current_residence_dim_incl_new_records.data_source_integration_id =
           borrower_aux_current_residence_dim.data_source_integration_id
WHERE borrower_aux_current_residence_dim.borrower_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT borrower_aux_current_residence_dim_incl_new_records.*
FROM borrower_aux_current_residence_dim_incl_new_records
    JOIN (
        SELECT borrower_aux_current_residence_dim.data_source_integration_id
            , etl_log.etl_start_date_time
        FROM star_loan.borrower_aux_current_residence_dim
            JOIN star_common.etl_log
                ON borrower_aux_current_residence_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS borrower_aux_current_residence_dim_etl_start_times
        ON borrower_aux_current_residence_dim_incl_new_records.data_source_integration_id =
           borrower_aux_current_residence_dim_etl_start_times.data_source_integration_id
            AND borrower_aux_current_residence_dim_incl_new_records.max_source_etl_end_date_time >=
                borrower_aux_current_residence_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200023', 1, 'WITH cash_out_reason_dim_new_records AS (
    SELECT ''cash_out_reason_business_debt_or_debt_consolidation_flag~'' ||
           ''cash_out_reason_debt_or_debt_consolidation_flag~'' ||
           ''cash_out_reason_future_investment_not_under_contract_flag~'' ||
           ''cash_out_reason_future_investment_under_contract_flag~'' ||
           ''cash_out_reason_home_improvement_flag~'' ||
           ''cash_out_reason_investment_or_business_property_flag~'' ||
           ''cash_out_reason_other_flag~'' ||
           ''cash_out_reason_personal_use_flag~'' ||
           ''cash_out_reason_student_loans_flag~'' ||
           ''non_business_cash_out_reason_acknowledged_code~data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(proposal.prp_cash_out_reason_business_debt_or_debt_consolidation AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_debt_or_debt_consolidation AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_future_investment_not_under_contract AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_future_investment_under_contracT AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_home_improvement AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_investment_or_business_property AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_other AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_personal_use AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_student_loans AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_non_business_cash_out_reason_acknowledged AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , MAX(proposal.data_source_updated_datetime) AS data_source_modified_datetime
        , proposal.prp_cash_out_reason_business_debt_or_debt_consolidation AS cash_out_reason_business_debt_or_debt_consolidation_flag
        , proposal.prp_cash_out_reason_debt_or_debt_consolidation AS cash_out_reason_debt_or_debt_consolidation_flag
        , proposal.prp_cash_out_reason_future_investment_not_under_contract AS cash_out_reason_future_investment_not_under_contract_flag
        , proposal.prp_cash_out_reason_future_investment_under_contract AS cash_out_reason_future_investment_under_contract_flag
        , proposal.prp_cash_out_reason_home_improvement AS cash_out_reason_home_improvement_flag
        , proposal.prp_cash_out_reason_investment_or_business_property AS cash_out_reason_investment_or_business_property_flag
        , proposal.prp_cash_out_reason_other AS cash_out_reason_other_flag
        , proposal.prp_cash_out_reason_personal_use AS cash_out_reason_personal_use_flag
        , proposal.prp_cash_out_reason_student_loans AS cash_out_reason_student_loans_flag
        , yes_no_na_type.value AS non_business_cash_out_reason_acknowledged
        , proposal.prp_non_business_cash_out_reason_acknowledged AS non_business_cash_out_reason_acknowledged_code
        , MAX(GREATEST(yes_no_na_type.etl_end_date_time)) AS max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
            , deal.*
        FROM history_octane.deal
        LEFT JOIN history_octane.deal AS history_records
            ON deal.d_pid = history_records.d_pid
                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.d_pid IS NULL
        ) AS deal
    JOIN (
      SELECT *
      FROM (
        SELECT <<proposal_partial_load_condition>> AS include_record
            , proposal.*
        FROM history_octane.proposal
        LEFT JOIN history_octane.proposal AS history_records
            ON proposal.prp_pid = history_records.prp_pid
                AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.prp_pid IS NULL
        ) AS primary_table
        ) AS proposal
            ON deal.d_pid = proposal.prp_deal_pid
    JOIN (
        SELECT *
        FROM (
        SELECT <<yes_no_na_type_partial_load_condition>> AS include_record
            , yes_no_na_type.*
            , etl_log.etl_end_date_time
        FROM history_octane.yes_no_na_type
        LEFT JOIN history_octane.yes_no_na_type AS history_records
            ON yes_no_na_type.code = history_records.code
                AND yes_no_na_type.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
            ON yes_no_na_type.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.code IS NULL
        ) AS primary_table
      ) AS yes_no_na_type
            ON proposal.prp_non_business_cash_out_reason_acknowledged = yes_no_na_type.code
    WHERE GREATEST(deal.include_record, proposal.include_record, yes_no_na_type.include_record) IS TRUE
    GROUP BY proposal.prp_cash_out_reason_business_debt_or_debt_consolidation
        , proposal.prp_cash_out_reason_debt_or_debt_consolidation
        , proposal.prp_cash_out_reason_future_investment_not_under_contract
        , proposal.prp_cash_out_reason_future_investment_under_contract
        , proposal.prp_cash_out_reason_home_improvement
        , proposal.prp_cash_out_reason_investment_or_business_property
        , proposal.prp_cash_out_reason_other
        , proposal.prp_cash_out_reason_personal_use
        , proposal.prp_cash_out_reason_student_loans
        , yes_no_na_type.value
        , proposal.prp_non_business_cash_out_reason_acknowledged
)
-- new records that should be inserted
SELECT cash_out_reason_dim_new_records.*
FROM cash_out_reason_dim_new_records
LEFT JOIN star_loan.cash_out_reason_dim
  ON cash_out_reason_dim_new_records.data_source_integration_id = cash_out_reason_dim.data_source_integration_id
WHERE cash_out_reason_dim.dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT cash_out_reason_dim_new_records.*
FROM cash_out_reason_dim_new_records
JOIN (
  SELECT cash_out_reason_dim.data_source_integration_id
    , etl_log.etl_start_date_time
  FROM star_loan.cash_out_reason_dim
    JOIN star_common.etl_log
      ON cash_out_reason_dim.etl_batch_id = etl_log.etl_batch_id
) AS cash_out_reason_dim_etl_start_times
  ON cash_out_reason_dim_new_records.data_source_integration_id = cash_out_reason_dim_etl_start_times.data_source_integration_id
    AND cash_out_reason_dim_new_records.max_source_etl_end_date_time >= cash_out_reason_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200024', 1, 'WITH hmda_action_dim_new_records AS (
    SELECT ''hmda_action_code~hmda_denial_reason_code_1~'' ||
           ''hmda_denial_reason_code_2~'' ||
           ''hmda_denial_reason_code_3~'' ||
           ''hmda_denial_reason_code_4~'' ||
           ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(deal.d_hmda_action_type AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(deal.d_hmda_denial_reason_type_1 AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(deal.d_hmda_denial_reason_type_2 AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(deal.d_hmda_denial_reason_type_3 AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(deal.d_hmda_denial_reason_type_4 AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , MAX(deal.data_source_updated_datetime) AS data_source_modified_datetime
        , hmda_action_type.value AS hmda_action
        , deal.d_hmda_action_type AS hmda_action_code
        , hmda_denial_reason_type_1.value AS hmda_denial_reason_1
        , hmda_denial_reason_type_2.value AS hmda_deniaL_reason_2
        , hmda_denial_reason_type_3.value AS hmda_deniaL_reason_3
        , hmda_denial_reason_type_4.value AS hmda_deniaL_reason_4
        , deal.d_hmda_denial_reason_type_1 AS hmda_denial_reason_code_1
        , deal.d_hmda_denial_reason_type_2 AS hmda_denial_reason_code_2
        , deal.d_hmda_denial_reason_type_3 AS hmda_denial_reason_code_3
        , deal.d_hmda_denial_reason_type_4 AS hmda_denial_reason_code_4
        , MAX(GREATEST(hmda_action_type.etl_end_date_time, hmda_denial_reason_type_1.etl_end_date_time,
            hmda_denial_reason_type_2.etl_end_date_time, hmda_denial_reason_type_3.etl_end_date_time,
            hmda_denial_reason_type_4.etl_end_date_time)) AS max_source_etl_end_date_time
    FROM (
         SELECT <<deal_partial_load_condition>> AS include_record
             , deal.*
         FROM history_octane.deal
         LEFT JOIN history_octane.deal AS history_records
             ON deal.d_pid = history_records.d_pid
                 AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.d_pid IS NULL
        ) AS deal
    JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_action_type_partial_load_condition>> AS include_record
                , hmda_action_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.hmda_action_type
            LEFT JOIN history_octane.hmda_action_type AS history_records
                ON hmda_action_type.code = history_records.code
                    AND hmda_action_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON hmda_action_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hmda_action_type
            ON deal.d_hmda_action_type = hmda_action_type.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
                , hmda_denial_reason_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
                ON hmda_denial_reason_type.code = history_records.code
                    AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hmda_denial_reason_type_1
            ON deal.d_hmda_denial_reason_type_1 = hmda_denial_reason_type_1.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
                , hmda_denial_reason_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
                ON hmda_denial_reason_type.code = history_records.code
                    AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hmda_denial_reason_type_2
            ON deal.d_hmda_denial_reason_type_2 = hmda_denial_reason_type_2.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
                , hmda_denial_reason_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
                ON hmda_denial_reason_type.code = history_records.code
                    AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hmda_denial_reason_type_3
            ON deal.d_hmda_denial_reason_type_3 = hmda_denial_reason_type_3.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
                , hmda_denial_reason_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
                ON hmda_denial_reason_type.code = history_records.code
                    AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hmda_denial_reason_type_4
            ON deal.d_hmda_denial_reason_type_4 = hmda_denial_reason_type_4.code
    WHERE GREATEST(deal.include_record, hmda_action_type.include_record, hmda_denial_reason_type_1.include_record,
        hmda_denial_reason_type_2.include_record, hmda_denial_reason_type_3.include_record, hmda_denial_reason_type_4
            .include_record) IS TRUE
    GROUP BY hmda_action_type.value
        , deal.d_hmda_action_type
        , hmda_denial_reason_type_1.value
        , hmda_denial_reason_type_2.value
        , hmda_denial_reason_type_3.value
        , hmda_denial_reason_type_4.value
        , deal.d_hmda_denial_reason_type_1
        , deal.d_hmda_denial_reason_type_2
        , deal.d_hmda_denial_reason_type_3
        , deal.d_hmda_denial_reason_type_4
)
-- new records that should be inserted
SELECT hmda_action_dim_new_records.*
FROM hmda_action_dim_new_records
LEFT JOIN star_loan.hmda_action_dim
    ON hmda_action_dim_new_records.data_source_integration_id = hmda_action_dim.data_source_integration_id
WHERE hmda_action_dim.dwid IS NULL
UNION ALL
-- existing records that should be updated
SELECT hmda_action_dim_new_records.*
FROM hmda_action_dim_new_records
JOIN (
    SELECT hmda_action_dim.data_source_integration_id
        , etl_log.etl_start_date_time
    FROM star_loan.hmda_action_dim
        JOIN star_common.etl_log
            ON hmda_action_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS hmda_action_dim_etl_start_times
    ON hmda_action_dim_new_records.data_source_integration_id = hmda_action_dim_etl_start_times.data_source_integration_id
        AND hmda_action_dim_new_records.max_source_etl_end_date_time >= hmda_action_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200026', 1, 'WITH transaction_aux_construction_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , proposal.data_source_updated_datetime AS data_source_modified_datetime
        , transaction_dim.dwid AS transaction_dwid
      , deal.d_pid AS deal_pid
        , proposal.prp_pid AS active_proposal_pid
        , proposal.prp_financed_property_improvements AS financed_property_improvements_flag
        , proposal.prp_loan_modification_agreement_executed_received_datetime AS loan_modification_agreement_executed_received_datetime
        , proposal.prp_adjusted_as_is_value_amount AS adjusted_as_is_value_amount
        , proposal.prp_after_improved_value_amount AS after_improved_value_amount
        , proposal.prp_construction_borrower_contribution_amount AS construction_borrower_contribution_amount
        , proposal.prp_estimated_hard_construction_cost_amount AS estimated_hard_construction_cost_amount
        , proposal.prp_cr_tracker_url AS cr_tracker_url
        , construction_lot_ownership_status_type.value AS construction_lot_ownership_status
        , proposal.prp_construction_lot_ownership_status_type AS construction_lot_ownership_status_code
        , financed_property_improvements_category_type.value AS financed_property_improvements_category
        , proposal.prp_financed_property_improvements_category_type AS financed_property_improvements_category_code
        , GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, construction_lot_ownership_status_type
            .etl_end_date_time, financed_property_improvements_category_type.etl_end_date_time,
            transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
            , deal.*
            , etl_log.etl_end_date_time
        FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                ON deal.d_pid = history_records.d_pid
                    AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON deal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.d_pid IS NULL
        ) AS deal
    JOIN (
        SELECT *
        FROM (
            SELECT <<proposal_partial_load_condition>> AS include_record
                , proposal.*
                , etl_log.etl_end_date_time
            FROM history_octane.proposal
                LEFT JOIN history_octane.proposal AS history_records
                    ON proposal.prp_pid = history_records.prp_pid
                        AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON proposal.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.prp_pid IS NULL
        ) AS primary_table
    ) AS proposal
        ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN (
        SELECT *
        FROM (
            SELECT <<construction_lot_ownership_status_type_partial_load_condition>> AS include_record
                , construction_lot_ownership_status_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.construction_lot_ownership_status_type
                LEFT JOIN history_octane.construction_lot_ownership_status_type AS history_records
                    ON construction_lot_ownership_status_type.code = history_records.code
                        AND construction_lot_ownership_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON construction_lot_ownership_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS construction_lot_ownership_status_type
        ON proposal.prp_construction_lot_ownership_status_type = construction_lot_ownership_status_type.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<financed_property_improvements_category_type_partial_load_condition>> AS include_record
                , financed_property_improvements_category_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.financed_property_improvements_category_type
                LEFT JOIN history_octane.financed_property_improvements_category_type AS history_records
                    ON financed_property_improvements_category_type.code = history_records.code
                        AND financed_property_improvements_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON financed_property_improvements_category_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
            ) AS primary_table
    ) AS financed_property_improvements_category_type
        ON proposal.prp_financed_property_improvements_category_type = financed_property_improvements_category_type.code
    JOIN (
        SELECT <<transaction_dim_partial_load_condition>> AS include_record
            , transaction_dim.*
            , etl_log.etl_end_date_time
        FROM star_loan.transaction_dim
        JOIN star_common.etl_log
            ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS transaction_dim
        ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, construction_lot_ownership_status_type
        .include_record, financed_property_improvements_category_type.include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_construction_dim_incl_new_records.*
FROM transaction_aux_construction_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_construction_dim
    ON transaction_aux_construction_dim_incl_new_records.data_source_integration_id =
       transaction_aux_construction_dim.data_source_integration_id
WHERE transaction_aux_construction_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_construction_dim_incl_new_records.*
FROM transaction_aux_construction_dim_incl_new_records
JOIN (
    SELECT transaction_aux_construction_dim.data_source_integration_id
        , etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_construction_dim
    JOIN star_common.etl_log
        ON transaction_aux_construction_dim.etl_batch_id = etl_log.etl_batch_id
) AS transaction_aux_construction_dim_etl_start_times
    ON transaction_aux_construction_dim_incl_new_records.data_source_integration_id =
       transaction_aux_construction_dim_etl_start_times.data_source_integration_id
        AND transaction_aux_construction_dim_incl_new_records.max_source_etl_end_date_time >=
            transaction_aux_construction_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200027', 1, 'WITH transaction_aux_disaster_declaration_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , proposal.data_source_updated_datetime AS data_source_modified_datetime
        , transaction_dim.dwid AS transaction_dwid
        , deal.d_pid AS deal_pid
        , proposal.prp_pid AS active_proposal_pid
        , proposal.prp_any_disaster_declaration_after_appraisal AS any_disaster_declaration_after_appraisal_flag
        , proposal.prp_any_disaster_declaration_before_appraisal AS any_disaster_declaration_before_appraisal_flag
        , proposal.prp_any_disaster_declaration AS any_disaster_declaration_flag
        , proposal.prp_disaster_declaration_check_date AS disaster_declaration_check_date
        , disaster_declaration_check_date_type.value AS disaster_declaration_check_date_type
        , proposal.prp_disaster_declaration_check_date_type AS disaster_declaration_check_date_type_code
        , GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, disaster_declaration_check_date_type
            .etl_end_date_time, transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
            , deal.*
            , etl_log.etl_end_date_time
        FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                ON deal.d_pid = history_records.d_pid
                    AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON deal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.d_pid IS NULL
    ) AS deal
    JOIN (
        SELECT *
        FROM (
            SELECT <<proposal_partial_load_condition>> AS include_record
                , proposal.*
                , etl_log.etl_end_date_time
            FROM history_octane.proposal
                LEFT JOIN history_octane.proposal AS history_records
                    ON proposal.prp_pid = history_records.prp_pid
                        AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON proposal.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.prp_pid IS NULL
        ) AS primary_table
    ) AS proposal
        ON deal.d_active_proposal_pid = proposal.prp_pid
    JOIN (
        SELECT *
        FROM (
            SELECT <<disaster_declaration_check_date_type_partial_load_condition>> AS include_record
                , disaster_declaration_check_date_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.disaster_declaration_check_date_type
                LEFT JOIN history_octane.disaster_declaration_check_date_type AS history_records
                    ON disaster_declaration_check_date_type.code = history_records.code
                        AND disaster_declaration_check_date_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON disaster_declaration_check_date_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS disaster_declaration_check_date_type
        ON proposal.prp_disaster_declaration_check_date_type = disaster_declaration_check_date_type.code
    JOIN (
        SELECT <<transaction_dim_partial_load_condition>> AS include_record
            , transaction_dim.*
            , etl_log.etl_end_date_time
        FROM star_loan.transaction_dim
            JOIN star_common.etl_log
                ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS transaction_dim
        ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, disaster_declaration_check_date_type.include_record,
        transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_disaster_declaration_dim_incl_new_records.*
FROM transaction_aux_disaster_declaration_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_disaster_declaration_dim
    ON transaction_aux_disaster_declaration_dim_incl_new_records.data_source_integration_id =
       transaction_aux_disaster_declaration_dim.data_source_integration_id
WHERE transaction_aux_disaster_declaration_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_disaster_declaration_dim_incl_new_records.*
FROM transaction_aux_disaster_declaration_dim_incl_new_records
JOIN (
    SELECT transaction_aux_disaster_declaration_dim.data_source_integration_id
        , etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_disaster_declaration_dim
        JOIN star_common.etl_log
            ON transaction_aux_disaster_declaration_dim.etl_batch_id = etl_log.etl_batch_id
        ) AS transaction_aux_disaster_declaration_dim_etl_start_times
        ON transaction_aux_disaster_declaration_dim_incl_new_records.data_source_integration_id =
           transaction_aux_disaster_declaration_dim_etl_start_times.data_source_integration_id
            AND transaction_aux_disaster_declaration_dim_incl_new_records.max_source_etl_end_date_time >=
                transaction_aux_disaster_declaration_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200028', 1, 'WITH transaction_aux_govt_programs_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , proposal.data_source_updated_datetime AS data_source_modified_datetime
        , transaction_dim.dwid AS transaction_dwid
        , deal.d_pid AS deal_pid
        , proposal.prp_pid AS active_proposal_pid
        , proposal.prp_fha_mip_refund_request_input_error AS fha_mip_refund_request_input_error_flag
        , proposal.prp_fha_non_arms_length_ltv_exception_verified AS fha_non_arms_length_ltv_exception_verified_flag
      , proposal.prp_request_fha_mip_refund_required AS request_fha_mip_refund_required_flag
      , proposal.prp_texas_equity_conversion_determination_datetime_override AS texas_equity_conversion_determination_datetime_override_flag
      , proposal.prp_texas_equity_determination_datetime_override AS texas_equity_determination_datetime_override_flag
      , proposal.prp_va_maintenance_utilities_auto_compute AS va_maintenance_utilities_auto_compute_flag
      , proposal.prp_fha_prior_agency_case_endorsement_date AS fha_prior_agency_case_endorsement_date
      , proposal.prp_fha_refinance_authorization_expiration_date AS fha_refinance_authorization_expiration_date
      , proposal.prp_texas_equity_determination_datetime AS texas_equity_determination_datetime
      , proposal.prp_usda_gsa_sam_checked_date AS usda_gsa_sam_checked_date
      , proposal.prp_va_notice_of_value_date AS va_notice_of_value_date
      , proposal.prp_cema_borrower_savings AS cema_borrower_savings
      , proposal.prp_fha_va_reasonable_value_amount AS fha_va_reasonable_value_amount
      , proposal.prp_va_actual_guaranty_amount AS va_actual_guaranty_amount
      , proposal.prp_va_amount_used_to_calculate_maximum_guaranty AS va_amount_used_to_calculate_maximum_guaranty
      , proposal.prp_va_energy_efficient_improvements_amount AS va_energy_efficient_improvements_amount
      , proposal.prp_va_guaranty_percent AS va_guaranty_percent
      , proposal.prp_va_maintenance_utilities_per_square_feet_amount AS va_maintenance_utilities_per_square_feet_amount
      , proposal.prp_va_maximum_base_loan_amount AS va_maximum_base_loan_amount
      , proposal.prp_va_maximum_funding_fee_amount AS va_maximum_funding_fee_amount
      , proposal.prp_va_maximum_total_loan_amount AS va_maximum_total_loan_amount
      , proposal.prp_va_monthly_maintenance_utilities_amount AS va_monthly_maintenance_utilities_amount
      , proposal.prp_va_notice_of_value_estimated_reasonable_value_amount AS va_notice_of_value_estimated_reasonable_value_amount
      , proposal.prp_va_required_cash_amount AS va_required_cash_amount
      , proposal.prp_va_required_guaranty_amount AS va_required_guaranty_amount
      , proposal.prp_fha_prior_agency_case_id AS fha_prior_agency_case_id
      , proposal.prp_fha_refinance_authorization_number AS fha_refinance_authorization_number
      , proposal.prp_fhac_refinance_authorization_messages AS fhac_refinance_authorization_messages
      , proposal.prp_texas_equity_conversion_determ_datetime_override_reason AS texas_equity_conversion_determ_datetime_override_reason
      , proposal.prp_texas_equity_determination_datetime_override_reason AS texas_equity_determination_datetime_override_reason
      , proposal.prp_va_prior_paid_in_full_loan_number AS va_prior_paid_in_full_loan_number
        , fha_non_arms_length_ltv_limit_exception_type.value AS fha_non_arms_length_ltv_exception
        , proposal.prp_fha_non_arms_length_ltv_exception_type AS fha_non_arms_length_ltv_exception_code
        , hud_fha_de_approval_type.value AS hud_fha_de_approval
        , proposal.prp_hud_fha_de_approval_type AS hud_fha_de_approval_code
        , usda_rd_single_family_housing_type.value AS usda_rd_single_family_housing
        , proposal.prp_usda_rd_single_family_housing_type AS usda_rd_single_family_housing_code
        , va_notice_of_value_source_type.value AS va_notice_of_value_source
        , proposal.prp_va_notice_of_value_source_type AS va_notice_of_value_source_code
        , va_past_credit_record_type.value AS va_past_credit_record
        , proposal.prp_va_past_credit_record_type AS va_past_credit_record_code
        , cema_ynnau_type.value AS cema
        , proposal.prp_cema AS cema_code
        , fha_eligible_maximum_financing_ynu_type.value AS fha_eligible_maximum_financing
        , proposal.prp_fha_eligible_maximum_financing AS fha_eligible_maximum_financing_code
        , usda_gsa_sam_exclusion_ynu_type.value AS usda_gsa_sam_exclusion
        , proposal.prp_usda_gsa_sam_exclusion AS usda_gsa_sam_exclusion_code
        , va_meets_credit_standards_ynu_type.value AS va_meets_credit_standards
        , proposal.prp_va_meets_credit_standards AS va_meets_credit_standards_code
        , va_monthly_utilities_included_ynu_type.value AS va_monthly_utilities_included
        , proposal.prp_va_monthly_utilities_included AS va_monthly_utilities_included_code
        , GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, fha_non_arms_length_ltv_limit_exception_type
            .etl_end_date_time, hud_fha_de_approval_type.etl_end_date_time, usda_rd_single_family_housing_type
                .etl_end_date_time, va_notice_of_value_source_type.etl_end_date_time, va_past_credit_record_type
                    .etl_end_date_time, cema_ynnau_type.etl_end_date_time, fha_eligible_maximum_financing_ynu_type
                        .etl_end_date_time, usda_gsa_sam_exclusion_ynu_type.etl_end_date_time,
            va_meets_credit_standards_ynu_type.etl_end_date_time, va_monthly_utilities_included_ynu_type
                .etl_end_date_time, transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
            , deal.*
            , etl_log.etl_end_date_time
        FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                ON deal.d_pid = history_records.d_pid
                    AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON deal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.d_pid IS NULL
    ) AS deal
        JOIN (
            SELECT *
            FROM (
                SELECT <<proposal_partial_load_condition>> AS include_record
                    , proposal.*
                    , etl_log.etl_end_date_time
                FROM history_octane.proposal
                    LEFT JOIN history_octane.proposal AS history_records
                        ON proposal.prp_pid = history_records.prp_pid
                            AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON proposal.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.prp_pid IS NULL
            ) AS primary_table
        ) AS proposal
            ON deal.d_active_proposal_pid = proposal.prp_pid
        JOIN (
            SELECT *
            FROM (
                SELECT <<fha_non_arms_length_ltv_limit_exception_type_partial_load_condition>> AS include_record
                    , fha_non_arms_length_ltv_limit_exception_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.fha_non_arms_length_ltv_limit_exception_type
                    LEFT JOIN history_octane.fha_non_arms_length_ltv_limit_exception_type AS history_records
                        ON fha_non_arms_length_ltv_limit_exception_type.code = history_records.code
                            AND fha_non_arms_length_ltv_limit_exception_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON fha_non_arms_length_ltv_limit_exception_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS fha_non_arms_length_ltv_limit_exception_type
                ON proposal.prp_fha_non_arms_length_ltv_exception_type = fha_non_arms_length_ltv_limit_exception_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<hud_fha_de_approval_type_partial_load_condition>> AS include_record
                    , hud_fha_de_approval_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.hud_fha_de_approval_type
                    LEFT JOIN history_octane.hud_fha_de_approval_type AS history_records
                        ON hud_fha_de_approval_type.code = history_records.code
                            AND hud_fha_de_approval_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON hud_fha_de_approval_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hud_fha_de_approval_type
            ON proposal.prp_hud_fha_de_approval_type = hud_fha_de_approval_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<usda_rd_single_family_housing_type_partial_load_condition>> AS include_record
                    , usda_rd_single_family_housing_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.usda_rd_single_family_housing_type
                    LEFT JOIN history_octane.usda_rd_single_family_housing_type AS history_records
                        ON usda_rd_single_family_housing_type.code = history_records.code
                            AND usda_rd_single_family_housing_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON usda_rd_single_family_housing_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS usda_rd_single_family_housing_type
            ON proposal.prp_usda_rd_single_family_housing_type = usda_rd_single_family_housing_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<va_notice_of_value_source_type_partial_load_condition>> AS include_record
                    , va_notice_of_value_source_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.va_notice_of_value_source_type
                    LEFT JOIN history_octane.va_notice_of_value_source_type AS history_records
                        ON va_notice_of_value_source_type.code = history_records.code
                            AND va_notice_of_value_source_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON va_notice_of_value_source_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS va_notice_of_value_source_type
            ON proposal.prp_va_notice_of_value_source_type = va_notice_of_value_source_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<va_past_credit_record_type_partial_load_condition>> AS include_record
                    , va_past_credit_record_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.va_past_credit_record_type
                    LEFT JOIN history_octane.va_past_credit_record_type AS history_records
                        ON va_past_credit_record_type.code = history_records.code
                            AND va_past_credit_record_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON va_past_credit_record_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS va_past_credit_record_type
            ON proposal.prp_va_past_credit_record_type = va_past_credit_record_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_na_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_na_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_na_unknown_type
                    LEFT JOIN history_octane.yes_no_na_unknown_type AS history_records
                        ON yes_no_na_unknown_type.code = history_records.code
                            AND yes_no_na_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_na_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
                ) AS primary_table
            ) AS cema_ynnau_type
                ON proposal.prp_cema = cema_ynnau_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS fha_eligible_maximum_financing_ynu_type
                ON proposal.prp_fha_eligible_maximum_financing = fha_eligible_maximum_financing_ynu_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS usda_gsa_sam_exclusion_ynu_type
            ON proposal.prp_usda_gsa_sam_exclusion = usda_gsa_sam_exclusion_ynu_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS va_meets_credit_standards_ynu_type
            ON proposal.prp_va_meets_credit_standards = va_meets_credit_standards_ynu_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS va_monthly_utilities_included_ynu_type
            ON proposal.prp_va_monthly_utilities_included = va_monthly_utilities_included_ynu_type.code
        JOIN (
            SELECT <<transaction_dim_partial_load_condition>> AS include_record
                , transaction_dim.*
                , etl_log.etl_end_date_time
            FROM star_loan.transaction_dim
                JOIN star_common.etl_log
                    ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
        ) AS transaction_dim
            ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, fha_non_arms_length_ltv_limit_exception_type
        .include_record, hud_fha_de_approval_type.include_record, usda_rd_single_family_housing_type
                       .include_record, va_notice_of_value_source_type.include_record, va_past_credit_record_type
                       .include_record, cema_ynnau_type.include_record, fha_eligible_maximum_financing_ynu_type
                       .include_record, usda_gsa_sam_exclusion_ynu_type.include_record,
                   va_meets_credit_standards_ynu_type.include_record, va_monthly_utilities_included_ynu_type
                       .include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_govt_programs_dim_incl_new_records.*
FROM transaction_aux_govt_programs_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_govt_programs_dim
    ON transaction_aux_govt_programs_dim_incl_new_records.data_source_integration_id =
       transaction_aux_govt_programs_dim.data_source_integration_id
WHERE transaction_aux_govt_programs_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_govt_programs_dim_incl_new_records.*
FROM transaction_aux_govt_programs_dim_incl_new_records
JOIN (
    SELECT transaction_aux_govt_programs_dim.data_source_integration_id
        , etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_govt_programs_dim
        JOIN star_common.etl_log
            ON transaction_aux_govt_programs_dim.etl_batch_id = etl_log.etl_batch_id
        ) AS transaction_aux_govt_programs_dim_etl_start_times
        ON transaction_aux_govt_programs_dim_incl_new_records.data_source_integration_id =
           transaction_aux_govt_programs_dim_etl_start_times.data_source_integration_id
            AND transaction_aux_govt_programs_dim_incl_new_records.max_source_etl_end_date_time >=
                transaction_aux_govt_programs_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200029', 1, 'WITH transaction_aux_property_repairs_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , proposal.data_source_updated_datetime AS data_source_modified_datetime
        , transaction_dim.dwid AS transaction_dwid
        , deal.d_pid AS deal_pid
        , proposal.prp_pid AS active_proposal_pid
        , proposal.prp_property_repairs_completed_notification_date AS property_repairs_completed_notification_date
        , proposal.prp_property_repairs_funds_released_contractor_date AS property_repairs_funds_released_contractor_date
        , proposal.prp_property_repairs_holdback_required_completion_date AS property_repairs_holdback_required_completion_date
        , proposal.prp_property_repairs_inspection_completed_date AS property_repairs_inspection_completed_date
        , proposal.prp_property_repairs_inspection_ordered_date AS property_repairs_inspection_ordered_date
        , proposal.prp_property_repairs_cost_amount AS property_repairs_cost_amount
        , proposal.prp_property_repairs_holdback_amount AS property_repairs_holdback_amount
        , proposal.prp_property_repairs_description AS property_repairs_description
        , proposal.prp_property_repairs_holdback_administrator AS property_repairs_holdback_administrator
        , property_repairs_holdback_calc_type.value AS property_repairs_holdback_calc
        , proposal.prp_property_repairs_holdback_calc_type AS property_repairs_holdback_calc_code
        , property_repairs_holdback_payer_type.value AS property_repairs_holdback_payer
        , proposal.prp_property_repairs_holdback_payer_type AS property_repairs_holdback_payer_code
        , property_repairs_required_type.value AS property_repairs_required
        , proposal.prp_property_repairs_required_type AS property_repairs_required_code
        , GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, property_repairs_holdback_calc_type
            .etl_end_date_time, property_repairs_holdback_payer_type.etl_end_date_time,
            property_repairs_required_type.etl_end_date_time, transaction_dim.etl_end_date_time) AS
            max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
            , deal.*
            , etl_log.etl_end_date_time
        FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                ON deal.d_pid = history_records.d_pid
                    AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON deal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.d_pid IS NULL
    ) AS deal
        JOIN (
            SELECT *
            FROM (
                SELECT <<proposal_partial_load_condition>> AS include_record
                    , proposal.*
                    , etl_log.etl_end_date_time
                FROM history_octane.proposal
                    LEFT JOIN history_octane.proposal AS history_records
                        ON proposal.prp_pid = history_records.prp_pid
                            AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON proposal.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.prp_pid IS NULL
            ) AS primary_table
        ) AS proposal
            ON deal.d_active_proposal_pid = proposal.prp_pid
        JOIN (
            SELECT *
            FROM (
                SELECT <<property_repairs_holdback_calc_type_partial_load_condition>> AS include_record
                    , property_repairs_holdback_calc_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.property_repairs_holdback_calc_type
                    LEFT JOIN history_octane.property_repairs_holdback_calc_type AS history_records
                        ON property_repairs_holdback_calc_type.code = history_records.code
                            AND property_repairs_holdback_calc_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON property_repairs_holdback_calc_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
                ) AS primary_table
            ) AS property_repairs_holdback_calc_type
                ON proposal.prp_property_repairs_holdback_calc_type = property_repairs_holdback_calc_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<property_repairs_holdback_payer_type_partial_load_condition>> AS include_record
                    , property_repairs_holdback_payer_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.property_repairs_holdback_payer_type
                    LEFT JOIN history_octane.property_repairs_holdback_payer_type AS history_records
                        ON property_repairs_holdback_payer_type.code = history_records.code
                            AND property_repairs_holdback_payer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON property_repairs_holdback_payer_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
                ) AS primary_table
            ) AS property_repairs_holdback_payer_type
                ON proposal.prp_property_repairs_holdback_payer_type = property_repairs_holdback_payer_type.code
        JOIN (
            SELECT *
            FROM (
                SELECT <<property_repairs_required_type_partial_load_condition>> AS include_record
                    , property_repairs_required_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.property_repairs_required_type
                    LEFT JOIN history_octane.property_repairs_required_type AS history_records
                        ON property_repairs_required_type.code = history_records.code
                            AND property_repairs_required_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON property_repairs_required_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
                ) AS primary_table
            ) AS property_repairs_required_type
                ON proposal.prp_property_repairs_required_type = property_repairs_required_type.code
        JOIN (
            SELECT <<transaction_dim_partial_load_condition>> AS include_record
                , transaction_dim.*
                , etl_log.etl_end_date_time
            FROM star_loan.transaction_dim
                JOIN star_common.etl_log
                    ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
            ) AS transaction_dim
                ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, property_repairs_holdback_calc_type
        .include_record, property_repairs_holdback_payer_type.include_record,
                   property_repairs_required_type.include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_property_repairs_dim_incl_new_records.*
FROM transaction_aux_property_repairs_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_property_repairs_dim
    ON transaction_aux_property_repairs_dim_incl_new_records.data_source_integration_id =
       transaction_aux_property_repairs_dim.data_source_integration_id
WHERE transaction_aux_property_repairs_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_property_repairs_dim_incl_new_records.*
FROM transaction_aux_property_repairs_dim_incl_new_records
JOIN (
    SELECT transaction_aux_property_repairs_dim.data_source_integration_id
        , etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_property_repairs_dim
        JOIN star_common.etl_log
            ON transaction_aux_property_repairs_dim.etl_batch_id = etl_log.etl_batch_id
        ) AS transaction_aux_property_repairs_dim_etl_start_times
        ON transaction_aux_property_repairs_dim_incl_new_records.data_source_integration_id =
           transaction_aux_property_repairs_dim_etl_start_times.data_source_integration_id
            AND transaction_aux_property_repairs_dim_incl_new_records.max_source_etl_end_date_time >=
                transaction_aux_property_repairs_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200041', 1, 'WITH transaction_aux_subject_property_dim_incl_new_records AS (
    SELECT ''deal_pid~data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~1'' AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , deal.data_source_updated_datetime AS data_source_modified_datetime
        , transaction_dim.dwid AS transaction_dwid
        , deal.d_pid AS deal_pid
        , subject_property.pl_street1 AS street1
        , subject_property.pl_street2 AS street2
        , subject_property.pl_city AS city
        , subject_property.pl_property_tax_id AS tax_id
        , subject_property.pl_postal_code AS postal_code
        , county.c_name AS county_name
        , subject_property.pl_county_fips AS county_fips
        , subject_property.pl_state AS state
        , subject_property.pl_state_fips AS state_fips
        , subject_property.pl_country AS country_code
        , country_type.value AS country
        , subject_property.pl_structure_built_year AS year_built
        , subject_property.pl_property_category_type AS property_category_code
        , property_category_type.value AS property_category
        , subject_property.pl_building_status_type AS building_status_code
        , building_status_type.value AS building_status
        , subject_property.pl_rental AS rental_flag
        , subject_property.pl_property_rights_type AS property_rights_code
        , property_rights_type.value AS property_rights
        , subject_property.pl_neighborhood_location_type AS neighborhood_location_code
        , neighborhood_location_type.value AS neighborhood_location
        , GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, subject_property.etl_end_date_time, county
        .etl_end_date_time, country_type.etl_end_date_time, property_category_type.etl_end_date_time,
                   building_status_type.etl_end_date_time, neighborhood_location_type.etl_end_date_time,
            transaction_dim.etl_end_date_time, property_rights_type.etl_end_date_time) AS
max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
            , deal.*
            , etl_log.etl_end_date_time
        FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                ON deal.d_pid = history_records.d_pid
                    AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON deal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.d_pid IS NULL
    ) AS deal
        JOIN (
            SELECT <<proposal_partial_load_condition>> AS include_record
                , proposal.*
                , etl_log.etl_end_date_time
            FROM history_octane.proposal
                LEFT JOIN history_octane.proposal AS history_records
                    ON proposal.prp_pid = history_records.prp_pid
                        AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON proposal.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.prp_pid IS NULL
        ) AS proposal
            ON deal.d_active_proposal_pid = proposal.prp_pid
        JOIN (
            SELECT <<place_partial_load_condition>> AS include_record
                , place.*
                , etl_log.etl_end_date_time
            FROM history_octane.place
                LEFT JOIN history_octane.place AS history_records
                    ON place.pl_pid = history_records.pl_pid
                        AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON place.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.pl_pid IS NULL
        ) AS subject_property
            ON proposal.prp_pid = subject_property.pl_proposal_pid
                AND subject_property.pl_subject_property IS TRUE
        LEFT JOIN (
            SELECT <<county_partial_load_condition>> AS include_record
                , county.*
                , etl_log.etl_end_date_time
            FROM history_octane.county
                LEFT JOIN history_octane.county AS history_records
                    ON county.c_pid = history_records.c_pid
                        AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON county.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.c_pid IS NULL
        ) AS county ON subject_property.pl_county_pid = county.c_pid
        JOIN (
            SELECT <<country_type_partial_load_condition>> AS include_record
                , country_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records
                    ON country_type.code = history_records.code
                        AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON country_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS country_type ON subject_property.pl_country = country_type.code
        JOIN (
            SELECT <<property_category_type_partial_load_condition>> AS include_record
                , property_category_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.property_category_type
                LEFT JOIN history_octane.property_category_type AS history_records
                    ON property_category_type.code = history_records.code
                        AND property_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON property_category_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS property_category_type ON subject_property.pl_property_category_type = property_category_type.code
        JOIN (
            SELECT <<building_status_type_partial_load_condition>> AS include_record
                , building_status_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.building_status_type
                LEFT JOIN history_octane.building_status_type AS history_records
                    ON building_status_type.code = history_records.code
                        AND building_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON building_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS building_status_type ON subject_property.pl_building_status_type = building_status_type.code
        JOIN (
            SELECT <<property_rights_type_partial_load_condition>> AS include_record
                , property_rights_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.property_rights_type
                LEFT JOIN history_octane.property_rights_type AS history_records
                    ON property_rights_type.code = history_records.code
                        AND property_rights_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON property_rights_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS property_rights_type ON subject_property.pl_property_rights_type = property_rights_type.code
        JOIN (
            SELECT <<neighborhood_location_type_partial_load_condition>> AS include_record
                , neighborhood_location_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.neighborhood_location_type
                LEFT JOIN history_octane.neighborhood_location_type AS history_records
                    ON neighborhood_location_type.code = history_records.code
                        AND neighborhood_location_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log ON neighborhood_location_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS neighborhood_location_type ON subject_property.pl_neighborhood_location_type = neighborhood_location_type.code
        JOIN (
            SELECT <<transaction_dim_partial_load_condition>> AS include_record
                , transaction_dim.*
                , etl_log.etl_end_date_time
            FROM star_loan.transaction_dim
                JOIN star_common.etl_log
                    ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
            ) AS transaction_dim
                ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, subject_property.include_record, county
        .include_record, country_type.include_record, property_category_type.include_record,
                   building_status_type.include_record, neighborhood_location_type.include_record, transaction_dim
                       .include_record, property_rights_type.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_subject_property_dim_incl_new_records.*
FROM transaction_aux_subject_property_dim_incl_new_records
    LEFT JOIN star_loan.transaction_aux_subject_property_dim
        ON transaction_aux_subject_property_dim_incl_new_records.data_source_integration_id =
           transaction_aux_subject_property_dim.data_source_integration_id
WHERE transaction_aux_subject_property_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_subject_property_dim_incl_new_records.*
FROM transaction_aux_subject_property_dim_incl_new_records
    JOIN (
        SELECT transaction_aux_subject_property_dim.data_source_integration_id
            , etl_log.etl_start_date_time
        FROM star_loan.transaction_aux_subject_property_dim
            JOIN star_common.etl_log
                ON transaction_aux_subject_property_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS transaction_aux_subject_property_dim_etl_start_times
        ON transaction_aux_subject_property_dim_incl_new_records.data_source_integration_id =
           transaction_aux_subject_property_dim_etl_start_times.data_source_integration_id
            AND transaction_aux_subject_property_dim_incl_new_records.max_source_etl_end_date_time >=
                transaction_aux_subject_property_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200019', 1, 'WITH transaction_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE( CAST( t1441.d_pid AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
        , NOW( ) AS edw_created_datetime
        , NOW( ) AS edw_modified_datetime
        , primary_table.data_source_updated_datetime AS data_source_modified_datetime
        , t1441.d_pid AS deal_pid
        , primary_table.prp_pid AS active_proposal_pid
        , current_deal_stage_records.dst_deal_stage_type as current_transaction_stage_code
        , current_deal_stage_type_records.value as current_transaction_stage
        , subject_property.pl_street1 AS subject_property_street1
        , subject_property.pl_street2 AS subject_property_street2
        , subject_property.pl_city subject_property_city
        , subject_property.pl_property_tax_id AS subject_property_tax_id
        , subject_property.pl_postal_code AS subject_property_postal_code
        , county.c_name AS subject_property_county_name
        , subject_property.pl_county_fips AS subject_property_county_fips
        , subject_property.pl_state AS subject_property_state
        , subject_property.pl_state_fips subject_property_state_fips
        , subject_property.pl_country AS subject_property_country_code
        , country_type.value AS subject_property_country
        , subject_property.pl_structure_built_year AS subject_property_year_built
        , subject_property.pl_property_category_type AS subject_property_category_code
        , property_category_type.value AS subject_property_category
        , subject_property.pl_building_status_type AS subject_property_building_status_code
        , building_status_type.value AS subject_property_building_status
        , subject_property.pl_rental AS subject_property_rental_flag
        , subject_property.pl_property_rights_type AS subject_property_rights_code
        , property_rights_type.value AS subject_property_rights
        , subject_property.pl_neighborhood_location_type AS subject_property_neighborhood_location_code
        , neighborhood_location_type.value AS subject_property_neighborhood_location
        , t1441.d_borrower_esign AS borrower_esign_flag
        , primary_table.prp_deed_taxes_applicable AS deed_taxes_applicable_flag
        , primary_table.prp_deed_taxes_auto_compute AS deed_taxes_auto_compute_flag
        , primary_table.prp_delayed_financing_exception_guidelines_applicable AS delayed_financing_exception_guidelines_applicable_flag
        , primary_table.prp_delayed_financing_exception_verified AS delayed_financing_exception_verified_flag
        , primary_table.prp_down_payment_percent_mode AS down_payment_percent_mode_flag
        , t1441.d_early_wire_request AS early_wire_request_flag
        , t1441.d_enable_electronic_transaction AS enable_electronic_transaction_flag
        , primary_table.prp_escrow_cushion_months_auto_compute AS escrow_cushion_months_auto_compute_flag
        , primary_table.prp_first_payment_date_auto_compute AS first_payment_date_auto_compute_flag
        , primary_table.prp_household_income_exclusive_edit AS household_income_exclusive_edit_flag
        , primary_table.prp_intent_to_proceed_provided AS intent_to_proceed_provided_flag
        , t1441.d_invoices_enabled AS invoices_enabled_flag
        , primary_table.prp_ipc_auto_compute AS ipc_auto_compute_flag
        , primary_table.prp_minimum_residual_income_auto_compute AS minimum_residual_income_auto_compute_flag
        , primary_table.prp_other_lender_requires_appraisal AS other_lender_requires_appraisal_flag
        , primary_table.prp_owner_occupancy_not_required AS owner_occupancy_not_required_flag
        , primary_table.prp_property_taxes_request_input_error AS property_taxes_request_input_error_flag
        , primary_table.prp_publish AS publish_flag
        , primary_table.prp_recording_fees_request_input_error AS recording_fees_request_input_error_flag
        , primary_table.prp_request_property_taxes_required AS request_property_taxes_required_flag
        , primary_table.prp_request_recording_fees_required AS request_recording_fees_required_flag
        , primary_table.prp_rescission_applicable AS rescission_applicable_flag
        , primary_table.prp_reserves_auto_compute AS reserves_auto_compute_flag
        , t1441.d_sap_deal AS sap_deal_flag
        , primary_table.prp_sar_significant_adjustments AS sar_significant_adjustments_flag
        , primary_table.prp_smart_charges_enabled AS smart_charges_enabled_flag
        , primary_table.prp_smart_docs_enabled AS smart_docs_enabled_flag
        , t1441.d_training_loan AS training_loan_flag
        , primary_table.prp_publish_date AS active_proposal_publish_date
        , primary_table.prp_calculated_earliest_allowed_consummation_date AS calculated_earliest_allowed_consummation_date
        , primary_table.prp_charges_updated_datetime AS charges_updated_datetime
        , primary_table.prp_closing_document_sign_datetime AS closing_document_sign_datetime
        , primary_table.prp_docs_enabled_datetime AS docs_enabled_datetime
        , t1441.d_ecoa_application_complete_date AS ecoa_application_complete_date
      , t1441.d_ecoa_application_received_date AS ecoa_application_received_date
        , t1441.d_ecoa_decision_due_date AS ecoa_decision_due_date
        , t1441.d_ecoa_notice_of_incomplete_date AS ecoa_notice_of_incomplete_date
        , t1441.d_ecoa_notice_of_incomplete_due_date AS ecoa_notice_of_incomplete_due_date
        , primary_table.prp_effective_earliest_allowed_consummation_date AS effective_earliest_allowed_consummation_date
        , primary_table.prp_first_payment_date AS first_payment_date
        , primary_table.prp_fre_ctp_first_payment_due_date AS fre_ctp_first_payment_due_date
        , primary_table.prp_gfe_interest_rate_expiration_date AS gfe_interest_rate_expiration_date
        , primary_table.prp_initial_uw_disposition_datetime AS initial_uw_disposition_datetime
        , primary_table.prp_initial_uw_submit_datetime AS initial_uw_submit_datetime
        , t1441.d_invoices_enabled_date AS invoices_enabled_date
        , primary_table.prp_land_acquisition_transaction_date AS land_acquisition_transaction_date
        , primary_table.prp_last_corrective_disclosure_processed_datetime AS last_corrective_disclosure_processed_datetime
        , primary_table.prp_last_requested_disclosure_date AS last_requested_disclosure_date
        , primary_table.prp_lender_escrow_loan_due_date AS lender_escrow_loan_due_date
        , primary_table.prp_overridden_earliest_allowed_consummation_date AS overridden_earliest_allowed_consummation_date
        , primary_table.prp_preapproval_disposition_datetime AS preapproval_disposition_datetime
        , primary_table.prp_preapproval_complete_datetime AS preapproval_complete_datetime
        , primary_table.prp_proposal_expiration_date AS proposal_expiration_date
        , primary_table.prp_purchase_contract_date AS purchase_contract_date
        , primary_table.prp_purchase_contract_financing_contingency_date AS purchase_contract_financing_contingency_date
        , primary_table.prp_purchase_contract_funding_date AS purchase_contract_funding_date
        , primary_table.prp_purchase_contract_received_date AS purchase_contract_received_date
        , primary_table.prp_rescission_effective_date AS rescission_effective_date
        , primary_table.prp_rescission_notification_date AS rescission_notification_date
        , primary_table.prp_rescission_through_date AS rescission_through_date
        , primary_table.prp_scheduled_closing_document_sign_datetime AS scheduled_closing_document_sign_datetime
        , primary_table.prp_signed_closing_doc_received_datetime AS signed_closing_doc_received_datetime
        , t1441.d_deal_create_date_time AS transaction_deal_create_datetime
        , t1441.d_deal_orphan_earliest_check_date AS transaction_orphan_earliest_check_date
        , primary_table.prp_create_datetime AS transaction_proposal_create_datetime
        , t1441.d_deal_status_date AS transaction_status_date
        , t1441.d_welcome_call_datetime AS transaction_welcome_call_datetime
        , primary_table.prp_underwrite_expiration_date AS underwrite_expiration_date
        , primary_table.prp_user_entered_note_date AS user_entered_note_date
        , primary_table.prp_anti_steering_lowest_cost_option_fee_amount AS anti_steering_lowest_cost_option_fee_amount
        , primary_table.prp_anti_steering_lowest_cost_option_rate_percent AS anti_steering_lowest_cost_option_rate_percent
        , primary_table.prp_anti_steering_lowest_rate_option_fee_amount AS anti_steering_lowest_rate_option_fee_amount
        , primary_table.prp_anti_steering_lowest_rate_option_rate_percent AS anti_steering_lowest_rate_option_rate_percent
        , primary_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount AS anti_steering_lowest_rate_wo_neg_option_fee_amount
        , primary_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent AS anti_steering_lowest_rate_wo_neg_option_rate_percent
        , primary_table.prp_area_median_income AS area_median_income
        , primary_table.prp_decision_appraised_value_amount AS decision_appraised_value_amount
        , primary_table.prp_decision_credit_score AS decision_credit_score
        , primary_table.prp_down_payment_percent AS down_payment_percent
        , primary_table.prp_effective_credit_score AS effective_credit_score
        , primary_table.prp_effective_property_value_amount AS effective_property_value_amount
        , primary_table.prp_escrow_cushion_months AS escrow_cushion_months
        , primary_table.prp_estimated_credit_score AS estimated_credit_score
        , primary_table.prp_estimated_property_value_amount AS estimated_property_value_amount
        , primary_table.prp_gfe_lock_before_settlement_days AS gfe_lock_before_settlement_days
        , primary_table.prp_gfe_lock_duration_days AS gfe_lock_duration_days
        , primary_table.prp_household_size_count AS household_size_count
        , primary_table.prp_ipc_amount AS ipc_amount
        , primary_table.prp_ipc_financing_concession_amount AS ipc_financing_concession_amount
        , primary_table.prp_ipc_limit_percent AS ipc_limit_percent
        , primary_table.prp_ipc_maximum_amount_allowed AS ipc_maximum_amount_allowed
        , primary_table.prp_ipc_non_cash_concession_amount AS ipc_non_cash_concession_amount
        , primary_table.prp_ipc_percent AS ipc_percent
        , primary_table.prp_land_acquisition_price AS land_acquisition_price
        , primary_table.prp_lender_escrow_loan_amount AS lender_escrow_loan_amount
        , primary_table.prp_minimum_household_income_amount AS minimum_household_income_amount
        , primary_table.prp_minimum_residual_income_amount AS minimum_residual_income_amount
        , primary_table.prp_proposed_additional_monthly_payment AS proposed_additional_monthly_payment
        , primary_table.prp_reserves_amount AS reserves_amount
        , primary_table.prp_reserves_months AS reserves_months
        , primary_table.prp_sale_price_amount AS sale_price_amount
        , primary_table.prp_term_borrower_intends_to_retain_property AS term_borrower_intends_to_retain_property
        , primary_table.prp_total_income_to_ami_ratio AS total_income_to_ami_ratio
        , primary_table.prp_description AS active_proposal_description
        , primary_table.prp_name AS active_proposal_name
        , t1441.d_calyx_loan_guid AS calyx_loan_guid
        , primary_table.prp_cash_out_reason_other_text AS cash_out_reason_other_text
        , t1441.d_copy_source_los_loan_id_main AS copy_source_los_loan_id_main
        , t1441.d_copy_source_los_loan_id_piggyback AS copy_source_los_loan_id_piggyback
        , primary_table.prp_deed_taxes_applicable_explanation AS deed_taxes_applicable_explanation
        , primary_table.prp_deed_taxes_auto_compute_override_reason AS deed_taxes_auto_compute_override_reason
        , primary_table.prp_earliest_allowed_consummation_date_override_reason AS earliest_allowed_consummation_date_override_reason
        , primary_table.prp_effective_signing_location_city AS effective_signing_location_city
        , t1441.d_external_loan_id_main AS external_loan_id_main
        , t1441.d_external_loan_id_piggyback AS external_loan_id_piggyback
        , t1441.d_hmda_denial_reason_other_description AS hmda_denial_reason_other_description
        , t1441.d_hmda_universal_loan_id_main AS hmda_universal_loan_id_main
        , t1441.d_hmda_universal_loan_id_piggyback AS hmda_universal_loan_id_piggyback
        , primary_table.prp_intent_to_proceed_obtainer_unparsed_name AS intent_to_proceed_obtainer_unparsed_name
        , primary_table.prp_intent_to_proceed_provider_unparsed_name AS intent_to_proceed_provider_unparsed_name
        , t1441.d_lead_reference_id AS lead_reference_id
        , t1441.d_lead_tracking_id AS lead_tracking_id
        , t1441.d_lead_zillow_zq AS lead_zillow_zq
        , t1441.d_los_loan_id_main AS los_loan_number_main
        , t1441.d_los_loan_id_piggyback AS los_loan_number_piggyback
        , t1441.d_mers_min_main AS mers_min_main
        , t1441.d_mers_min_piggyback AS mers_min_piggyback
        , primary_table.prp_other_lender_requires_appraisal_reason AS other_lender_requires_appraisal_reason
        , primary_table.prp_property_tax_request_error_messages AS property_tax_request_error_messages
        , primary_table.prp_rescission_notification_by AS recsission_notication_by
        , t1441.d_referred_by_name AS referred_by_name
        , primary_table.prp_trustee_address_city AS trustee_address_city
        , primary_table.prp_trustee_address_country AS trustee_address_country
        , primary_table.prp_trustee_address_postal_code AS trustee_address_postal_code
        , primary_table.prp_trustee_address_state AS trustee_address_state
        , primary_table.prp_trustee_address_street1 AS trustee_address_street1
        , primary_table.prp_trustee_address_street2 AS trustee_address_street2
        , primary_table.prp_trustee_mers_org_id AS trustee_mers_org_id
        , primary_table.prp_trustee_name AS trustee_name
        , primary_table.prp_trustee_phone_number AS trustee_phone_number
        , primary_table.prp_underwrite_disposition_note AS underwrite_disposition_note
        , primary_table.prp_underwriting_comments AS underwriting_comments
        , primary_table.prp_uuts_master_contact_name AS uuts_master_contact_name
        , primary_table.prp_uuts_master_contact_title AS uuts_master_contact_title
        , primary_table.prp_uuts_master_office_phone AS uuts_master_office_phone
        , primary_table.prp_uuts_master_office_phone_extension AS uuts_master_office_phone_extension
        , t1441.d_velocify_lead_id AS velocify_lead_id
        , proposal_type.value AS active_proposal_type
        , primary_table.prp_proposal_type AS active_proposal_type_code
        , application_type.value AS application_type
        , t1441.d_application_type AS application_type_code
        , credit_bureau_type.value AS credit_bureau
        , t1441.d_credit_bureau_type AS credit_bureau_code
        , disclosure_action_type.value AS disclosure_action
        , primary_table.prp_disclosure_action_type AS disclosure_action_code
        , doc_level_type.value AS doc_level
        , primary_table.prp_doc_level_type AS doc_level_code
        , effective_property_value_explanation_type.value AS effective_property_value_explanation
        , primary_table.prp_effective_property_value_explanation_type AS effective_property_value_explanation_code
        , effective_property_value_type.value AS effective_property_value_type
        , primary_table.prp_effective_property_value_type AS effective_property_value_type_code
        , state_type.value AS effective_signing_location_state
        , primary_table.prp_effective_signing_location_state AS effective_signing_location_state_code
        , fre_ctp_closing_feature_type.value AS fre_ctp_closing_feature
        , primary_table.prp_fre_ctp_closing_feature_type AS fre_ctp_closing_feature_code
        , gse_version_type.value AS gse_version
        , primary_table.prp_gse_version_type AS gse_version_code
        , intent_to_proceed_type.value AS intent_to_proceed
        , primary_table.prp_intent_to_proceed_type AS intent_to_proceed_code
        , deal_orphan_status_type.value AS orphan_status
        , t1441.d_deal_orphan_status_type AS orphan_status_code
        , realty_agent_scenario_type.value AS realty_agent_scenario
        , t1441.d_realty_agent_scenario_type AS realty_agent_scenario_code
        , rescission_notification_type.value AS rescission_notification
        , primary_table.prp_rescission_notification_type AS rescission_notification_code
        , security_instrument_type.value AS security_instrument
        , primary_table.prp_security_instrument_type AS security_instrument_code
        , deal_create_type.value AS transaction_create_type
        , t1441.d_deal_create_type AS transaction_create_type_code
        , deal_status_type.value AS transaction_status
        , t1441.d_deal_status_type AS transaction_status_code
        , any_vesting_changes_ynu_type.value AS any_vesting_changes
        , primary_table.prp_any_vesting_changes AS any_vesting_changes_code
        , arms_length_ynu_type.value AS arms_length
        , primary_table.prp_arms_length AS arms_length_code
        , early_first_payment_ynu_type.value AS early_first_payment
        , primary_table.prp_early_first_payment AS early_first_payment_code
        , earthquake_insurance_applicable_ynu_type.value AS earthquake_insurance_applicable
        , primary_table.prp_earthquake_insurance_applicable AS earthquake_insurance_applicable_code
        , flood_insurance_applicable_ynu_type.value AS flood_insurance_applicable
        , primary_table.prp_flood_insurance_applicable AS flood_insurance_applicable_code
        , hazard_insurance_applicable_ynu_type.value AS hazard_insurance_applicable
        , primary_table.prp_hazard_insurance_applicable AS hazard_insurance_applicable_code
        , hud_consultant_ynu_type.value AS hud_consultant
        , primary_table.prp_hud_consultant AS hud_consultant_code
        , mortgagee_builder_seller_relationship_ynu_type.value AS mortgagee_builder_seller_relationship
        , primary_table.prp_mortgagee_builder_seller_relationship AS mortgagee_builder_seller_relationship_code
        , property_acquired_through_ancillary_relief_ynu_type.value AS property_acquired_through_ancillary_relief
        , primary_table.prp_property_acquired_through_ancillary_relief AS property_acquired_through_ancillary_relief_code
        , property_acquired_through_inheritance_ynu_type.value AS property_acquired_through_inheritance
        , primary_table.prp_property_acquired_through_inheritance AS property_acquired_through_inheritance_code
        , separate_transaction_for_land_acquisition_ynu_type.value AS separate_transaction_for_land_acquisition
        , primary_table.prp_separate_transaction_for_land_acquisition AS separate_transaction_for_land_acquisition_code
        , taxes_escrowed_ynu_type.value AS taxes_escrowed
        , primary_table.prp_taxes_escrowed AS taxes_escrowed_code
        , vesting_change_titleholder_added_ynu_type.value AS vesting_change_titleholder_added
        , primary_table.prp_vesting_change_titleholder_added AS vesting_change_titleholder_added_code
        , vesting_change_titleholder_name_change_ynu_type.value AS vesting_change_titleholder_name_change
        , primary_table.prp_vesting_change_titleholder_name_change AS vesting_change_titleholder_name_change_code
        , vesting_change_titleholder_removed_ynu_type.value AS vesting_change_titleholder_removed
        , primary_table.prp_vesting_change_titleholder_removed AS vesting_change_titleholder_removed_code
        , windstorm_insurance_applicable_ynu_type.value AS windstorm_insurance_applicable
        , primary_table.prp_windstorm_insurance_applicable AS windstorm_insurance_applicable_code
        , GREATEST( primary_table.etl_end_date_time, t1441.etl_end_date_time, current_deal_stage_records.etl_end_date_time,
                    current_deal_stage_type_records.etl_end_date_time, subject_property.etl_end_date_time, county.etl_end_date_time,
                    country_type.etl_end_date_time, property_category_type.etl_end_date_time, building_status_type.etl_end_date_time,
                    property_rights_type.etl_end_date_time, neighborhood_location_type.etl_end_date_time, proposal_type.etl_end_date_time,
                    application_type.etl_end_date_time, credit_bureau_type.etl_end_date_time, disclosure_action_type.etl_end_date_time,
                    doc_level_type.etl_end_date_time, effective_property_value_explanation_type.etl_end_date_time,
                    effective_property_value_type.etl_end_date_time, state_type.etl_end_date_time,
                    fre_ctp_closing_feature_type.etl_end_date_time, gse_version_type.etl_end_date_time,
                    intent_to_proceed_type.etl_end_date_time, deal_orphan_status_type.etl_end_date_time,
                    realty_agent_scenario_type.etl_end_date_time, rescission_notification_type.etl_end_date_time,
                    security_instrument_type.etl_end_date_time, deal_create_type.etl_end_date_time, deal_status_type.etl_end_date_time,
                    any_vesting_changes_ynu_type.etl_end_date_time,
                    arms_length_ynu_type.etl_end_date_time,
                    early_first_payment_ynu_type.etl_end_date_time,
                    earthquake_insurance_applicable_ynu_type.etl_end_date_time,
                    flood_insurance_applicable_ynu_type.etl_end_date_time,
                    hazard_insurance_applicable_ynu_type.etl_end_date_time,
                    hud_consultant_ynu_type.etl_end_date_time,
                    mortgagee_builder_seller_relationship_ynu_type.etl_end_date_time,
                    property_acquired_through_ancillary_relief_ynu_type.etl_end_date_time,
                    property_acquired_through_inheritance_ynu_type.etl_end_date_time,
                    separate_transaction_for_land_acquisition_ynu_type.etl_end_date_time,
                    taxes_escrowed_ynu_type.etl_end_date_time,
                    vesting_change_titleholder_added_ynu_type.etl_end_date_time,
                    vesting_change_titleholder_name_change_ynu_type.etl_end_date_time,
                    vesting_change_titleholder_removed_ynu_type.etl_end_date_time,
                    windstorm_insurance_applicable_ynu_type.etl_end_date_time) AS max_source_etl_end_date_time
    FROM (
        SELECT <<proposal_partial_load_condition>> AS include_record
            , proposal.*
            , etl_log.etl_end_date_time
        FROM history_octane.proposal
            LEFT JOIN history_octane.proposal AS history_records
                ON proposal.prp_pid = history_records.prp_pid
                    AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON proposal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.prp_pid IS NULL
    ) AS primary_table
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<deal_partial_load_condition>> AS include_record
                    , deal.*
                    , etl_log.etl_end_date_time
                FROM history_octane.deal
                    LEFT JOIN history_octane.deal AS history_records
                        ON deal.d_pid = history_records.d_pid
                            AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON deal.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.d_pid IS NULL
            ) AS primary_table
        ) AS t1441
            ON primary_table.prp_pid = t1441.d_active_proposal_pid
        INNER JOIN (
            SELECT <<deal_stage_partial_load_condition>> AS include_record
                , deal_stage.*
                , etl_log.etl_end_date_time as etl_end_date_time
            FROM history_octane.deal_stage
                LEFT JOIN history_octane.deal_stage AS history_records
                    ON deal_stage.dst_pid = history_records.dst_pid
                        AND deal_stage.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log
                    ON deal_stage.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.dst_pid IS NULL
                AND deal_stage.dst_through_date IS NULL
        ) as current_deal_stage_records ON t1441.d_pid = current_deal_stage_records.dst_deal_pid
        INNER JOIN (
            SELECT <<deal_stage_type_partial_load_condition>> AS include_record
                , deal_stage_type.code
                , deal_stage_type.value
                , etl_log.etl_end_date_time as etl_end_date_time
            FROM history_octane.deal_stage_type
                LEFT JOIN history_octane.deal_stage_type AS history_records
                    ON deal_stage_type.code = history_records.code
                        AND deal_stage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                JOIN star_common.etl_log ON deal_stage_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS current_deal_stage_type_records ON current_deal_stage_records.dst_deal_stage_type = current_deal_stage_type_records.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<place_partial_load_condition>> AS include_record
                    , place.*
                    , etl_log.etl_end_date_time
                FROM history_octane.place
                    LEFT JOIN history_octane.place AS history_records
                        ON place.pl_pid = history_records.pl_pid
                            AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON place.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.pl_pid IS NULL
            ) AS primary_table
        ) AS subject_property ON primary_table.prp_pid = subject_property.pl_proposal_pid
            AND subject_property.pl_subject_property IS TRUE
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT <<county_partial_load_condition>> AS include_record
                    , county.*
                    , etl_log.etl_end_date_time
                FROM history_octane.county
                    LEFT JOIN history_octane.county AS history_records
                        ON county.c_pid = history_records.c_pid
                            AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON county.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.c_pid IS NULL
            ) AS primary_table
        ) AS county ON subject_property.pl_county_pid = county.c_pid
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<country_type_partial_load_condition>> AS include_record
                    , country_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.country_type
                    LEFT JOIN history_octane.country_type AS history_records
                        ON country_type.code = history_records.code
                            AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON country_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS country_type ON subject_property.pl_country = country_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<property_category_type_partial_load_condition>> AS include_record
                    , property_category_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.property_category_type
                    LEFT JOIN history_octane.property_category_type AS history_records
                        ON property_category_type.code = history_records.code
                            AND property_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON property_category_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS property_category_type ON subject_property.pl_property_category_type = property_category_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<building_status_type_partial_load_condition>> AS include_record
                    , building_status_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.building_status_type
                    LEFT JOIN history_octane.building_status_type AS history_records
                        ON building_status_type.code = history_records.code
                            AND building_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON building_status_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS building_status_type ON subject_property.pl_building_status_type = building_status_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<property_rights_type_partial_load_condition>> AS include_record
                    , property_rights_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.property_rights_type
                    LEFT JOIN history_octane.property_rights_type AS history_records
                        ON property_rights_type.code = history_records.code
                            AND property_rights_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON property_rights_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS property_rights_type ON subject_property.pl_property_rights_type = property_rights_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<neighborhood_location_type_partial_load_condition>> AS include_record
                    , neighborhood_location_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.neighborhood_location_type
                    LEFT JOIN history_octane.neighborhood_location_type AS history_records
                        ON neighborhood_location_type.code = history_records.code
                            AND neighborhood_location_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log ON neighborhood_location_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS neighborhood_location_type ON subject_property.pl_neighborhood_location_type = neighborhood_location_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<proposal_type_partial_load_condition>> AS include_record
                    , proposal_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.proposal_type
                    LEFT JOIN history_octane.proposal_type AS history_records
                        ON proposal_type.code = history_records.code
                            AND proposal_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON proposal_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS proposal_type
            ON primary_table.prp_proposal_type = proposal_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<application_type_partial_load_condition>> AS include_record
                    , application_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.application_type
                    LEFT JOIN history_octane.application_type AS history_records
                        ON application_type.code = history_records.code
                            AND application_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON application_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS application_type
            ON t1441.d_application_type = application_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<credit_bureau_type_partial_load_condition>> AS include_record
                    , credit_bureau_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.credit_bureau_type
                    LEFT JOIN history_octane.credit_bureau_type AS history_records
                        ON credit_bureau_type.code = history_records.code
                            AND credit_bureau_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON credit_bureau_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS credit_bureau_type
                ON t1441.d_credit_bureau_type = credit_bureau_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<disclosure_action_type_partial_load_condition>> AS include_record
                    , disclosure_action_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.disclosure_action_type
                    LEFT JOIN history_octane.disclosure_action_type AS history_records
                        ON disclosure_action_type.code = history_records.code
                            AND disclosure_action_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON disclosure_action_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS disclosure_action_type
                ON primary_table.prp_disclosure_action_type = disclosure_action_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<doc_level_type_partial_load_condition>> AS include_record
                    , doc_level_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.doc_level_type
                    LEFT JOIN history_octane.doc_level_type AS history_records
                        ON doc_level_type.code = history_records.code
                            AND doc_level_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON doc_level_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS doc_level_type
                ON primary_table.prp_doc_level_type = doc_level_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<effective_property_value_explanation_type_partial_load_condition>> AS include_record
                    , effective_property_value_explanation_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.effective_property_value_explanation_type
                    LEFT JOIN history_octane.effective_property_value_explanation_type AS history_records
                        ON effective_property_value_explanation_type.code = history_records.code
                            AND effective_property_value_explanation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON effective_property_value_explanation_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS effective_property_value_explanation_type
                ON primary_table.prp_effective_property_value_explanation_type = effective_property_value_explanation_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<effective_property_value_type_partial_load_condition>> AS include_record
                    , effective_property_value_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.effective_property_value_type
                    LEFT JOIN history_octane.effective_property_value_type AS history_records
                        ON effective_property_value_type.code = history_records.code
                            AND effective_property_value_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON effective_property_value_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
                ) AS primary_table
            ) AS effective_property_value_type
                ON primary_table.prp_effective_property_value_type = effective_property_value_type.code
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT <<state_type_partial_load_condition>> AS include_record
                    , state_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.state_type
                    LEFT JOIN history_octane.state_type AS history_records
                        ON state_type.code = history_records.code
                            AND state_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON state_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS state_type
            ON primary_table.prp_effective_signing_location_state = state_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<fre_ctp_closing_feature_type_partial_load_condition>> AS include_record
                    , fre_ctp_closing_feature_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.fre_ctp_closing_feature_type
                    LEFT JOIN history_octane.fre_ctp_closing_feature_type AS history_records
                        ON fre_ctp_closing_feature_type.code = history_records.code
                            AND fre_ctp_closing_feature_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON fre_ctp_closing_feature_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS fre_ctp_closing_feature_type
            ON primary_table.prp_fre_ctp_closing_feature_type = fre_ctp_closing_feature_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<gse_version_type_partial_load_condition>> AS include_record
                    , gse_version_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.gse_version_type
                    LEFT JOIN history_octane.gse_version_type AS history_records
                        ON gse_version_type.code = history_records.code
                            AND gse_version_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON gse_version_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS gse_version_type
            ON primary_table.prp_gse_version_type = gse_version_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<intent_to_proceed_type_partial_load_condition>> AS include_record
                    , intent_to_proceed_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.intent_to_proceed_type
                    LEFT JOIN history_octane.intent_to_proceed_type AS history_records
                        ON intent_to_proceed_type.code = history_records.code
                            AND intent_to_proceed_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON intent_to_proceed_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS intent_to_proceed_type
            ON primary_table.prp_intent_to_proceed_type = intent_to_proceed_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<deal_orphan_status_type_partial_load_condition>> AS include_record
                    , deal_orphan_status_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.deal_orphan_status_type
                    LEFT JOIN history_octane.deal_orphan_status_type AS history_records
                        ON deal_orphan_status_type.code = history_records.code
                            AND deal_orphan_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON deal_orphan_status_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS deal_orphan_status_type
            ON t1441.d_deal_orphan_status_type = deal_orphan_status_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<realty_agent_scenario_type_partial_load_condition>> AS include_record
                    , realty_agent_scenario_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.realty_agent_scenario_type
                    LEFT JOIN history_octane.realty_agent_scenario_type AS history_records
                        ON realty_agent_scenario_type.code = history_records.code
                            AND realty_agent_scenario_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON realty_agent_scenario_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS realty_agent_scenario_type
            ON t1441.d_realty_agent_scenario_type = realty_agent_scenario_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<rescission_notification_type_partial_load_condition>> AS include_record
                    , rescission_notification_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.rescission_notification_type
                    LEFT JOIN history_octane.rescission_notification_type AS history_records
                        ON rescission_notification_type.code = history_records.code
                            AND rescission_notification_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON rescission_notification_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS rescission_notification_type
            ON primary_table.prp_rescission_notification_type = rescission_notification_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<security_instrument_type_partial_load_condition>> AS include_record
                    , security_instrument_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.security_instrument_type
                    LEFT JOIN history_octane.security_instrument_type AS history_records
                        ON security_instrument_type.code = history_records.code
                            AND security_instrument_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON security_instrument_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS security_instrument_type
            ON primary_table.prp_security_instrument_type = security_instrument_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<deal_create_type_partial_load_condition>> AS include_record
                    , deal_create_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.deal_create_type
                    LEFT JOIN history_octane.deal_create_type AS history_records
                        ON deal_create_type.code = history_records.code
                            AND deal_create_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON deal_create_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS deal_create_type
            ON t1441.d_deal_create_type = deal_create_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<deal_status_type_partial_load_condition>> AS include_record
                    , deal_status_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.deal_status_type
                    LEFT JOIN history_octane.deal_status_type AS history_records
                        ON deal_status_type.code = history_records.code
                            AND deal_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON deal_status_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS deal_status_type
            ON t1441.d_deal_status_type = deal_status_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS any_vesting_changes_ynu_type
            ON primary_table.prp_any_vesting_changes = any_vesting_changes_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS arms_length_ynu_type
            ON primary_table.prp_arms_length = arms_length_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS early_first_payment_ynu_type
            ON primary_table.prp_early_first_payment = early_first_payment_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS earthquake_insurance_applicable_ynu_type
            ON primary_table.prp_earthquake_insurance_applicable = earthquake_insurance_applicable_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS flood_insurance_applicable_ynu_type
            ON primary_table.prp_flood_insurance_applicable = flood_insurance_applicable_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hazard_insurance_applicable_ynu_type
            ON primary_table.prp_hazard_insurance_applicable = hazard_insurance_applicable_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS hud_consultant_ynu_type
            ON primary_table.prp_hud_consultant = hud_consultant_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS mortgagee_builder_seller_relationship_ynu_type
            ON primary_table.prp_mortgagee_builder_seller_relationship = mortgagee_builder_seller_relationship_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS property_acquired_through_ancillary_relief_ynu_type
            ON primary_table.prp_property_acquired_through_ancillary_relief = property_acquired_through_ancillary_relief_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS property_acquired_through_inheritance_ynu_type
            ON primary_table.prp_property_acquired_through_inheritance = property_acquired_through_inheritance_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS separate_transaction_for_land_acquisition_ynu_type
            ON primary_table.prp_separate_transaction_for_land_acquisition = separate_transaction_for_land_acquisition_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS taxes_escrowed_ynu_type
            ON primary_table.prp_taxes_escrowed = taxes_escrowed_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS vesting_change_titleholder_added_ynu_type
            ON primary_table.prp_vesting_change_titleholder_added = vesting_change_titleholder_added_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS vesting_change_titleholder_name_change_ynu_type
            ON primary_table.prp_vesting_change_titleholder_name_change = vesting_change_titleholder_name_change_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS vesting_change_titleholder_removed_ynu_type
            ON primary_table.prp_vesting_change_titleholder_removed = vesting_change_titleholder_removed_ynu_type.code
        INNER JOIN (
            SELECT *
            FROM (
                SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                    , yes_no_unknown_type.*
                    , etl_log.etl_end_date_time
                FROM history_octane.yes_no_unknown_type
                    LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                        ON yes_no_unknown_type.code = history_records.code
                            AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                    JOIN star_common.etl_log
                        ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
                WHERE history_records.code IS NULL
            ) AS primary_table
        ) AS windstorm_insurance_applicable_ynu_type
            ON primary_table.prp_windstorm_insurance_applicable = windstorm_insurance_applicable_ynu_type.code
    WHERE GREATEST( primary_table.include_record, t1441.include_record, current_deal_stage_records.include_record,
                    current_deal_stage_type_records.include_record, subject_property.include_record, county.include_record,
                    country_type.include_record, property_category_type.include_record, building_status_type.include_record,
                    property_rights_type.include_record, neighborhood_location_type.include_record, proposal_type.include_record,
                    application_type.include_record, credit_bureau_type.include_record, disclosure_action_type.include_record,
                    doc_level_type.include_record, effective_property_value_explanation_type.include_record,
                    effective_property_value_type.include_record, state_type.include_record,
                    fre_ctp_closing_feature_type.include_record, gse_version_type.include_record,
                    intent_to_proceed_type.include_record, deal_orphan_status_type.include_record,
                    realty_agent_scenario_type.include_record, rescission_notification_type.include_record,
                    security_instrument_type.include_record, deal_create_type.include_record, deal_status_type.include_record,
                    any_vesting_changes_ynu_type.include_record,
                    arms_length_ynu_type.include_record,
                    early_first_payment_ynu_type.include_record,
                    earthquake_insurance_applicable_ynu_type.include_record,
                    flood_insurance_applicable_ynu_type.include_record,
                    hazard_insurance_applicable_ynu_type.include_record,
                    hud_consultant_ynu_type.include_record,
                    mortgagee_builder_seller_relationship_ynu_type.include_record,
                    property_acquired_through_ancillary_relief_ynu_type.include_record,
                    property_acquired_through_inheritance_ynu_type.include_record,
                    separate_transaction_for_land_acquisition_ynu_type.include_record,
                    taxes_escrowed_ynu_type.include_record,
                    vesting_change_titleholder_added_ynu_type.include_record,
                    vesting_change_titleholder_name_change_ynu_type.include_record,
                    vesting_change_titleholder_removed_ynu_type.include_record,
                    windstorm_insurance_applicable_ynu_type.include_record) IS TRUE
)
--new records that should be inserted
SELECT transaction_dim_incl_new_records.*
FROM transaction_dim_incl_new_records
    LEFT JOIN star_loan.transaction_dim
        ON transaction_dim_incl_new_records.data_source_integration_id = transaction_dim.data_source_integration_id
WHERE transaction_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT transaction_dim_incl_new_records.*
FROM transaction_dim_incl_new_records
    JOIN (
        SELECT transaction_dim.data_source_integration_id, etl_log.etl_start_date_time
        FROM star_loan.transaction_dim
            JOIN star_common.etl_log
                ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS transaction_dim_etl_start_times
        ON transaction_dim_incl_new_records.data_source_integration_id = transaction_dim_etl_start_times.data_source_integration_id
            AND transaction_dim_incl_new_records.max_source_etl_end_date_time >= transaction_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200025', 1, 'WITH underwrite_dim_new_records AS (
    SELECT ''underwrite_disposition_code~'' ||
           ''underwrite_method_code~'' ||
           ''underwrite_risk_assessment_code~'' ||
           ''data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(proposal.prp_underwrite_disposition_type AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(proposal.prp_underwrite_method_type AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(proposal.prp_underwrite_risk_assessment_type AS TEXT), ''<NULL>'') || ''~'' ||
          COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , MAX(proposal.data_source_updated_datetime) AS data_source_modified_datetime
        , underwrite_disposition_type.value AS underwrite_disposition
        , proposal.prp_underwrite_disposition_type AS underwrite_disposition_code
        , underwrite_method_type.value AS underwrite_method
        , proposal.prp_underwrite_method_type AS underwrite_method_code
        , underwrite_risk_assessment_type.value AS underwrite_risk_assessment
        , proposal.prp_underwrite_risk_assessment_type AS underwrite_risk_assessment_code
        , MAX(GREATEST(underwrite_disposition_type.etl_end_date_time, underwrite_method_type.etl_end_date_time,
            underwrite_risk_assessment_type.etl_end_date_time)) AS max_source_etl_end_date_time
    FROM (
         SELECT <<proposal_partial_load_condition>> AS include_record
            , proposal.*
         FROM history_octane.proposal
         LEFT JOIN history_octane.proposal AS history_records
            ON proposal.prp_pid = history_records.prp_pid
                AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.prp_pid IS NULL
    ) AS proposal
    JOIN (
        SELECT *
        FROM (
             SELECT <<underwrite_disposition_type_partial_load_condition>> AS include_record
                , underwrite_disposition_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.underwrite_disposition_type
            LEFT JOIN history_octane.underwrite_disposition_type AS history_records
                ON underwrite_disposition_type.code = history_records.code
                    AND underwrite_disposition_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON underwrite_disposition_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS underwrite_disposition_type
        ON proposal.prp_underwrite_disposition_type = underwrite_disposition_type.code
    JOIN (
        SELECT *
        FROM (
             SELECT <<underwrite_method_type_partial_load_condition>> AS include_record
                , underwrite_method_type.*
                , etl_log.etl_end_date_time
             FROM history_octane.underwrite_method_type
             LEFT JOIN history_octane.underwrite_method_type AS history_records
                 ON underwrite_method_type.code = history_records.code
                     AND underwrite_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
             JOIN star_common.etl_log
                 ON underwrite_method_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS underwrite_method_type
        ON proposal.prp_underwrite_method_type = underwrite_method_type.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<underwrite_risk_assessment_type_partial_load_condition>> AS include_record
                , underwrite_risk_assessment_type.*
                , etl_log.etl_end_date_time
            FROM history_octane.underwrite_risk_assessment_type
            LEFT JOIN history_octane.underwrite_risk_assessment_type AS history_records
                ON underwrite_risk_assessment_type.code = history_records.code
                    AND underwrite_risk_assessment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                ON underwrite_risk_assessment_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS underwrite_risk_assessment_type
        ON proposal.prp_underwrite_risk_assessment_type = underwrite_risk_assessment_type.code
    WHERE GREATEST(proposal.include_record, underwrite_disposition_type.include_record, underwrite_method_type
        .include_record, underwrite_risk_assessment_type.include_record) IS TRUE
    GROUP BY underwrite_disposition_type.value
        , proposal.prp_underwrite_disposition_type
        , underwrite_method_type.value
        , proposal.prp_underwrite_method_type
        , underwrite_risk_assessment_type.value
        , proposal.prp_underwrite_risk_assessment_type
)
-- new records that should be inserted
SELECT underwrite_dim_new_records.*
FROM underwrite_dim_new_records
LEFT JOIN star_loan.underwrite_dim
    ON underwrite_dim_new_records.data_source_integration_id = underwrite_dim.data_source_integration_id
WHERE underwrite_dim.dwid IS NULL
UNION ALL
-- existing records that should be updated
SELECT underwrite_dim_new_records.*
FROM underwrite_dim_new_records
JOIN (
    SELECT underwrite_dim.data_source_integration_id
        , etl_log.etl_start_date_time
    FROM star_loan.underwrite_dim
        JOIN star_common.etl_log
            ON underwrite_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS underwrite_dim_etl_start_times
    ON underwrite_dim_new_records.data_source_integration_id = underwrite_dim_etl_start_times.data_source_integration_id
        AND underwrite_dim_new_records.max_source_etl_end_date_time >= underwrite_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
	, sql = update_rows.sql
	, connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
	JOIN mdi.process
		ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;