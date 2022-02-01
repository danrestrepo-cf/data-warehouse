--
-- EDW | Octane Type tables with updated values will cause duplicated fact records
-- https://app.asana.com/0/0/1201056914554058
--

/*
 Update each unique dimension's data_source_integration_columns/id to remove domain (type table) "value" fields
 */

--hmda_purchaser_of_loan_dim
UPDATE star_loan.hmda_purchaser_of_loan_dim
SET data_source_integration_columns = 'code_2017~code_2018~data_source_dwid'
  , data_source_integration_id = COALESCE( hmda_purchaser_of_loan_dim.code_2017, '<NULL>' ) || '~' ||
                                 COALESCE( hmda_purchaser_of_loan_dim.code_2018, '<NULL>' ) || '~' ||
                                 CAST( hmda_purchaser_of_loan_dim.data_source_dwid AS TEXT )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

/*
 Delete duplicate rows from unique dims and update any loan_fact records that pointed to deleted unique dim rows
 */

--hmda_purchaser_of_loan_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.hmda_purchaser_of_loan_dim
            USING (
                SELECT up_to_date_dim_rows.dwid AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM (
                    SELECT DISTINCT all_rows.dwid
                                  , all_rows.data_source_integration_id
                    FROM star_loan.hmda_purchaser_of_loan_dim all_rows
                    JOIN star_loan.hmda_purchaser_of_loan_dim duplicates
                         ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                             AND all_rows.dwid <> duplicates.dwid
                ) AS duplicates
                JOIN (
                    SELECT hmda_purchaser_of_loan_dim.*
                    FROM star_loan.hmda_purchaser_of_loan_dim
                    JOIN (
                        SELECT hmda_purchaser_of_loan_2017_type.*
                        FROM history_octane.hmda_purchaser_of_loan_2017_type
                        LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type AS history_records
                                  ON hmda_purchaser_of_loan_2017_type.code = history_records.code
                                      AND
                                     hmda_purchaser_of_loan_2017_type.data_source_updated_datetime <
                                     history_records.data_source_updated_datetime
                        WHERE history_records.code IS NULL
                    ) AS most_recent_hmda_purchaser_of_loan_2017_type
                         ON hmda_purchaser_of_loan_dim.code_2017 = most_recent_hmda_purchaser_of_loan_2017_type.code
                             AND hmda_purchaser_of_loan_dim.value_2017 = most_recent_hmda_purchaser_of_loan_2017_type.value
                    JOIN (
                        SELECT hmda_purchaser_of_loan_2018_type.*
                        FROM history_octane.hmda_purchaser_of_loan_2018_type
                        LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type AS history_records
                                  ON hmda_purchaser_of_loan_2018_type.code = history_records.code
                                      AND
                                     hmda_purchaser_of_loan_2018_type.data_source_updated_datetime <
                                     history_records.data_source_updated_datetime
                        WHERE history_records.code IS NULL
                    ) AS most_recent_hmda_purchaser_of_loan_2018_type
                         ON hmda_purchaser_of_loan_dim.code_2018 = most_recent_hmda_purchaser_of_loan_2018_type.code
                             AND hmda_purchaser_of_loan_dim.value_2018 = most_recent_hmda_purchaser_of_loan_2018_type.value
                ) AS up_to_date_dim_rows
                     ON up_to_date_dim_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND up_to_date_dim_rows.dwid <> duplicates.dwid
            ) AS duplicates
            WHERE hmda_purchaser_of_loan_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
   , update_loan_fact AS (
    UPDATE star_loan.loan_fact
        SET hmda_purchaser_of_loan_dwid = delete_query.current_dwid
        FROM delete_query
        WHERE loan_fact.hmda_purchaser_of_loan_dwid = delete_query.duplicate_dwid
)
SELECT 'Finished processing changes to hmda_purchaser_of_loan_dim''s integration ID';
;
