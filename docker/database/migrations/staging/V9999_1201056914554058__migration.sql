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
