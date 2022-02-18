--
-- EDW | star_loan - improve loan_lender_user_access delete query run times
-- https://app.asana.com/0/0/1201486823872698
--

/*
INSERTIONS
*/

--process
INSERT
INTO mdi.process (name, description)
VALUES ('SP-200001-delete-0', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-1', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-2', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-3', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-4', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-5', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-6', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-7', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-8', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-9', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-10', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-11', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-12', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-13', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-14', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-15', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-16', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-17', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-18', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-19', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-20', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-21', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-22', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-23', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-24', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-25', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-26', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-27', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-28', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-29', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-30', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-31', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-32', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-33', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-34', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-35', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-36', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-37', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-38', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-39', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-40', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-41', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-42', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-43', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-44', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-45', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-46', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-47', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-48', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-49', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-50', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-51', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-52', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-53', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-54', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-55', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-56', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-57', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-58', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-59', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-60', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-61', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-62', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-63', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-64', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-65', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-66', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-67', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-68', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-69', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-70', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-71', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-72', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-73', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-74', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-75', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-76', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-77', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-78', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-79', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-80', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-81', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-82', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-83', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-84', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-85', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-86', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-87', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-88', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-89', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-90', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-91', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-92', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-93', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-94', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-95', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-96', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-97', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-98', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
     , ('SP-200001-delete-99', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-200001-delete-0', 1, 'SELECT loan_lender_user_access_0.loan_dwid
     , loan_lender_user_access_0.octane_username
     , loan_lender_user_access_0.account_pid
FROM star_loan.loan_lender_user_access_0
LEFT JOIN (
    SELECT loan_lender_user_access_0.*
    FROM star_loan.loan_lender_user_access_0
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_0.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_0.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_0.octane_username = lender_user.lu_username
             AND loan_lender_user_access_0.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_0.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_0.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_0.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-1', 1, 'SELECT loan_lender_user_access_1.loan_dwid
     , loan_lender_user_access_1.octane_username
     , loan_lender_user_access_1.account_pid
FROM star_loan.loan_lender_user_access_1
LEFT JOIN (
    SELECT loan_lender_user_access_1.*
    FROM star_loan.loan_lender_user_access_1
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_1.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_1.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_1.octane_username = lender_user.lu_username
             AND loan_lender_user_access_1.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_1.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_1.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_1.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-2', 1, 'SELECT loan_lender_user_access_2.loan_dwid
     , loan_lender_user_access_2.octane_username
     , loan_lender_user_access_2.account_pid
FROM star_loan.loan_lender_user_access_2
LEFT JOIN (
    SELECT loan_lender_user_access_2.*
    FROM star_loan.loan_lender_user_access_2
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_2.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_2.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_2.octane_username = lender_user.lu_username
             AND loan_lender_user_access_2.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_2.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_2.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_2.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-3', 1, 'SELECT loan_lender_user_access_3.loan_dwid
     , loan_lender_user_access_3.octane_username
     , loan_lender_user_access_3.account_pid
FROM star_loan.loan_lender_user_access_3
LEFT JOIN (
    SELECT loan_lender_user_access_3.*
    FROM star_loan.loan_lender_user_access_3
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_3.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_3.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_3.octane_username = lender_user.lu_username
             AND loan_lender_user_access_3.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_3.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_3.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_3.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-4', 1, 'SELECT loan_lender_user_access_4.loan_dwid
     , loan_lender_user_access_4.octane_username
     , loan_lender_user_access_4.account_pid
FROM star_loan.loan_lender_user_access_4
LEFT JOIN (
    SELECT loan_lender_user_access_4.*
    FROM star_loan.loan_lender_user_access_4
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_4.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_4.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_4.octane_username = lender_user.lu_username
             AND loan_lender_user_access_4.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_4.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_4.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_4.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-5', 1, 'SELECT loan_lender_user_access_5.loan_dwid
     , loan_lender_user_access_5.octane_username
     , loan_lender_user_access_5.account_pid
FROM star_loan.loan_lender_user_access_5
LEFT JOIN (
    SELECT loan_lender_user_access_5.*
    FROM star_loan.loan_lender_user_access_5
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_5.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_5.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_5.octane_username = lender_user.lu_username
             AND loan_lender_user_access_5.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_5.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_5.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_5.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-6', 1, 'SELECT loan_lender_user_access_6.loan_dwid
     , loan_lender_user_access_6.octane_username
     , loan_lender_user_access_6.account_pid
FROM star_loan.loan_lender_user_access_6
LEFT JOIN (
    SELECT loan_lender_user_access_6.*
    FROM star_loan.loan_lender_user_access_6
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_6.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_6.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_6.octane_username = lender_user.lu_username
             AND loan_lender_user_access_6.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_6.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_6.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_6.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-7', 1, 'SELECT loan_lender_user_access_7.loan_dwid
     , loan_lender_user_access_7.octane_username
     , loan_lender_user_access_7.account_pid
FROM star_loan.loan_lender_user_access_7
LEFT JOIN (
    SELECT loan_lender_user_access_7.*
    FROM star_loan.loan_lender_user_access_7
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_7.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_7.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_7.octane_username = lender_user.lu_username
             AND loan_lender_user_access_7.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_7.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_7.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_7.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-8', 1, 'SELECT loan_lender_user_access_8.loan_dwid
     , loan_lender_user_access_8.octane_username
     , loan_lender_user_access_8.account_pid
FROM star_loan.loan_lender_user_access_8
LEFT JOIN (
    SELECT loan_lender_user_access_8.*
    FROM star_loan.loan_lender_user_access_8
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_8.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_8.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_8.octane_username = lender_user.lu_username
             AND loan_lender_user_access_8.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_8.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_8.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_8.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-9', 1, 'SELECT loan_lender_user_access_9.loan_dwid
     , loan_lender_user_access_9.octane_username
     , loan_lender_user_access_9.account_pid
FROM star_loan.loan_lender_user_access_9
LEFT JOIN (
    SELECT loan_lender_user_access_9.*
    FROM star_loan.loan_lender_user_access_9
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_9.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_9.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_9.octane_username = lender_user.lu_username
             AND loan_lender_user_access_9.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_9.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_9.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_9.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-10', 1, 'SELECT loan_lender_user_access_10.loan_dwid
     , loan_lender_user_access_10.octane_username
     , loan_lender_user_access_10.account_pid
FROM star_loan.loan_lender_user_access_10
LEFT JOIN (
    SELECT loan_lender_user_access_10.*
    FROM star_loan.loan_lender_user_access_10
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_10.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_10.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_10.octane_username = lender_user.lu_username
             AND loan_lender_user_access_10.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_10.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_10.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_10.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-11', 1, 'SELECT loan_lender_user_access_11.loan_dwid
     , loan_lender_user_access_11.octane_username
     , loan_lender_user_access_11.account_pid
FROM star_loan.loan_lender_user_access_11
LEFT JOIN (
    SELECT loan_lender_user_access_11.*
    FROM star_loan.loan_lender_user_access_11
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_11.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_11.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_11.octane_username = lender_user.lu_username
             AND loan_lender_user_access_11.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_11.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_11.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_11.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-12', 1, 'SELECT loan_lender_user_access_12.loan_dwid
     , loan_lender_user_access_12.octane_username
     , loan_lender_user_access_12.account_pid
FROM star_loan.loan_lender_user_access_12
LEFT JOIN (
    SELECT loan_lender_user_access_12.*
    FROM star_loan.loan_lender_user_access_12
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_12.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_12.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_12.octane_username = lender_user.lu_username
             AND loan_lender_user_access_12.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_12.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_12.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_12.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-13', 1, 'SELECT loan_lender_user_access_13.loan_dwid
     , loan_lender_user_access_13.octane_username
     , loan_lender_user_access_13.account_pid
FROM star_loan.loan_lender_user_access_13
LEFT JOIN (
    SELECT loan_lender_user_access_13.*
    FROM star_loan.loan_lender_user_access_13
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_13.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_13.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_13.octane_username = lender_user.lu_username
             AND loan_lender_user_access_13.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_13.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_13.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_13.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-14', 1, 'SELECT loan_lender_user_access_14.loan_dwid
     , loan_lender_user_access_14.octane_username
     , loan_lender_user_access_14.account_pid
FROM star_loan.loan_lender_user_access_14
LEFT JOIN (
    SELECT loan_lender_user_access_14.*
    FROM star_loan.loan_lender_user_access_14
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_14.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_14.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_14.octane_username = lender_user.lu_username
             AND loan_lender_user_access_14.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_14.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_14.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_14.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-15', 1, 'SELECT loan_lender_user_access_15.loan_dwid
     , loan_lender_user_access_15.octane_username
     , loan_lender_user_access_15.account_pid
FROM star_loan.loan_lender_user_access_15
LEFT JOIN (
    SELECT loan_lender_user_access_15.*
    FROM star_loan.loan_lender_user_access_15
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_15.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_15.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_15.octane_username = lender_user.lu_username
             AND loan_lender_user_access_15.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_15.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_15.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_15.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-16', 1, 'SELECT loan_lender_user_access_16.loan_dwid
     , loan_lender_user_access_16.octane_username
     , loan_lender_user_access_16.account_pid
FROM star_loan.loan_lender_user_access_16
LEFT JOIN (
    SELECT loan_lender_user_access_16.*
    FROM star_loan.loan_lender_user_access_16
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_16.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_16.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_16.octane_username = lender_user.lu_username
             AND loan_lender_user_access_16.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_16.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_16.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_16.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-17', 1, 'SELECT loan_lender_user_access_17.loan_dwid
     , loan_lender_user_access_17.octane_username
     , loan_lender_user_access_17.account_pid
FROM star_loan.loan_lender_user_access_17
LEFT JOIN (
    SELECT loan_lender_user_access_17.*
    FROM star_loan.loan_lender_user_access_17
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_17.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_17.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_17.octane_username = lender_user.lu_username
             AND loan_lender_user_access_17.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_17.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_17.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_17.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-18', 1, 'SELECT loan_lender_user_access_18.loan_dwid
     , loan_lender_user_access_18.octane_username
     , loan_lender_user_access_18.account_pid
FROM star_loan.loan_lender_user_access_18
LEFT JOIN (
    SELECT loan_lender_user_access_18.*
    FROM star_loan.loan_lender_user_access_18
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_18.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_18.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_18.octane_username = lender_user.lu_username
             AND loan_lender_user_access_18.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_18.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_18.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_18.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-19', 1, 'SELECT loan_lender_user_access_19.loan_dwid
     , loan_lender_user_access_19.octane_username
     , loan_lender_user_access_19.account_pid
FROM star_loan.loan_lender_user_access_19
LEFT JOIN (
    SELECT loan_lender_user_access_19.*
    FROM star_loan.loan_lender_user_access_19
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_19.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_19.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_19.octane_username = lender_user.lu_username
             AND loan_lender_user_access_19.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_19.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_19.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_19.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-20', 1, 'SELECT loan_lender_user_access_20.loan_dwid
     , loan_lender_user_access_20.octane_username
     , loan_lender_user_access_20.account_pid
FROM star_loan.loan_lender_user_access_20
LEFT JOIN (
    SELECT loan_lender_user_access_20.*
    FROM star_loan.loan_lender_user_access_20
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_20.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_20.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_20.octane_username = lender_user.lu_username
             AND loan_lender_user_access_20.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_20.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_20.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_20.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-21', 1, 'SELECT loan_lender_user_access_21.loan_dwid
     , loan_lender_user_access_21.octane_username
     , loan_lender_user_access_21.account_pid
FROM star_loan.loan_lender_user_access_21
LEFT JOIN (
    SELECT loan_lender_user_access_21.*
    FROM star_loan.loan_lender_user_access_21
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_21.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_21.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_21.octane_username = lender_user.lu_username
             AND loan_lender_user_access_21.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_21.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_21.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_21.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-22', 1, 'SELECT loan_lender_user_access_22.loan_dwid
     , loan_lender_user_access_22.octane_username
     , loan_lender_user_access_22.account_pid
FROM star_loan.loan_lender_user_access_22
LEFT JOIN (
    SELECT loan_lender_user_access_22.*
    FROM star_loan.loan_lender_user_access_22
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_22.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_22.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_22.octane_username = lender_user.lu_username
             AND loan_lender_user_access_22.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_22.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_22.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_22.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-23', 1, 'SELECT loan_lender_user_access_23.loan_dwid
     , loan_lender_user_access_23.octane_username
     , loan_lender_user_access_23.account_pid
FROM star_loan.loan_lender_user_access_23
LEFT JOIN (
    SELECT loan_lender_user_access_23.*
    FROM star_loan.loan_lender_user_access_23
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_23.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_23.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_23.octane_username = lender_user.lu_username
             AND loan_lender_user_access_23.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_23.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_23.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_23.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-24', 1, 'SELECT loan_lender_user_access_24.loan_dwid
     , loan_lender_user_access_24.octane_username
     , loan_lender_user_access_24.account_pid
FROM star_loan.loan_lender_user_access_24
LEFT JOIN (
    SELECT loan_lender_user_access_24.*
    FROM star_loan.loan_lender_user_access_24
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_24.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_24.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_24.octane_username = lender_user.lu_username
             AND loan_lender_user_access_24.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_24.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_24.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_24.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-25', 1, 'SELECT loan_lender_user_access_25.loan_dwid
     , loan_lender_user_access_25.octane_username
     , loan_lender_user_access_25.account_pid
FROM star_loan.loan_lender_user_access_25
LEFT JOIN (
    SELECT loan_lender_user_access_25.*
    FROM star_loan.loan_lender_user_access_25
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_25.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_25.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_25.octane_username = lender_user.lu_username
             AND loan_lender_user_access_25.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_25.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_25.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_25.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-26', 1, 'SELECT loan_lender_user_access_26.loan_dwid
     , loan_lender_user_access_26.octane_username
     , loan_lender_user_access_26.account_pid
FROM star_loan.loan_lender_user_access_26
LEFT JOIN (
    SELECT loan_lender_user_access_26.*
    FROM star_loan.loan_lender_user_access_26
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_26.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_26.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_26.octane_username = lender_user.lu_username
             AND loan_lender_user_access_26.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_26.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_26.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_26.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-27', 1, 'SELECT loan_lender_user_access_27.loan_dwid
     , loan_lender_user_access_27.octane_username
     , loan_lender_user_access_27.account_pid
FROM star_loan.loan_lender_user_access_27
LEFT JOIN (
    SELECT loan_lender_user_access_27.*
    FROM star_loan.loan_lender_user_access_27
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_27.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_27.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_27.octane_username = lender_user.lu_username
             AND loan_lender_user_access_27.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_27.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_27.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_27.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-28', 1, 'SELECT loan_lender_user_access_28.loan_dwid
     , loan_lender_user_access_28.octane_username
     , loan_lender_user_access_28.account_pid
FROM star_loan.loan_lender_user_access_28
LEFT JOIN (
    SELECT loan_lender_user_access_28.*
    FROM star_loan.loan_lender_user_access_28
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_28.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_28.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_28.octane_username = lender_user.lu_username
             AND loan_lender_user_access_28.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_28.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_28.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_28.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-29', 1, 'SELECT loan_lender_user_access_29.loan_dwid
     , loan_lender_user_access_29.octane_username
     , loan_lender_user_access_29.account_pid
FROM star_loan.loan_lender_user_access_29
LEFT JOIN (
    SELECT loan_lender_user_access_29.*
    FROM star_loan.loan_lender_user_access_29
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_29.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_29.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_29.octane_username = lender_user.lu_username
             AND loan_lender_user_access_29.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_29.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_29.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_29.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-30', 1, 'SELECT loan_lender_user_access_30.loan_dwid
     , loan_lender_user_access_30.octane_username
     , loan_lender_user_access_30.account_pid
FROM star_loan.loan_lender_user_access_30
LEFT JOIN (
    SELECT loan_lender_user_access_30.*
    FROM star_loan.loan_lender_user_access_30
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_30.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_30.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_30.octane_username = lender_user.lu_username
             AND loan_lender_user_access_30.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_30.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_30.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_30.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-31', 1, 'SELECT loan_lender_user_access_31.loan_dwid
     , loan_lender_user_access_31.octane_username
     , loan_lender_user_access_31.account_pid
FROM star_loan.loan_lender_user_access_31
LEFT JOIN (
    SELECT loan_lender_user_access_31.*
    FROM star_loan.loan_lender_user_access_31
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_31.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_31.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_31.octane_username = lender_user.lu_username
             AND loan_lender_user_access_31.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_31.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_31.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_31.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-32', 1, 'SELECT loan_lender_user_access_32.loan_dwid
     , loan_lender_user_access_32.octane_username
     , loan_lender_user_access_32.account_pid
FROM star_loan.loan_lender_user_access_32
LEFT JOIN (
    SELECT loan_lender_user_access_32.*
    FROM star_loan.loan_lender_user_access_32
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_32.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_32.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_32.octane_username = lender_user.lu_username
             AND loan_lender_user_access_32.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_32.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_32.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_32.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-33', 1, 'SELECT loan_lender_user_access_33.loan_dwid
     , loan_lender_user_access_33.octane_username
     , loan_lender_user_access_33.account_pid
FROM star_loan.loan_lender_user_access_33
LEFT JOIN (
    SELECT loan_lender_user_access_33.*
    FROM star_loan.loan_lender_user_access_33
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_33.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_33.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_33.octane_username = lender_user.lu_username
             AND loan_lender_user_access_33.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_33.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_33.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_33.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-34', 1, 'SELECT loan_lender_user_access_34.loan_dwid
     , loan_lender_user_access_34.octane_username
     , loan_lender_user_access_34.account_pid
FROM star_loan.loan_lender_user_access_34
LEFT JOIN (
    SELECT loan_lender_user_access_34.*
    FROM star_loan.loan_lender_user_access_34
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_34.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_34.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_34.octane_username = lender_user.lu_username
             AND loan_lender_user_access_34.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_34.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_34.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_34.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-35', 1, 'SELECT loan_lender_user_access_35.loan_dwid
     , loan_lender_user_access_35.octane_username
     , loan_lender_user_access_35.account_pid
FROM star_loan.loan_lender_user_access_35
LEFT JOIN (
    SELECT loan_lender_user_access_35.*
    FROM star_loan.loan_lender_user_access_35
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_35.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_35.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_35.octane_username = lender_user.lu_username
             AND loan_lender_user_access_35.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_35.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_35.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_35.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-36', 1, 'SELECT loan_lender_user_access_36.loan_dwid
     , loan_lender_user_access_36.octane_username
     , loan_lender_user_access_36.account_pid
FROM star_loan.loan_lender_user_access_36
LEFT JOIN (
    SELECT loan_lender_user_access_36.*
    FROM star_loan.loan_lender_user_access_36
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_36.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_36.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_36.octane_username = lender_user.lu_username
             AND loan_lender_user_access_36.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_36.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_36.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_36.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-37', 1, 'SELECT loan_lender_user_access_37.loan_dwid
     , loan_lender_user_access_37.octane_username
     , loan_lender_user_access_37.account_pid
FROM star_loan.loan_lender_user_access_37
LEFT JOIN (
    SELECT loan_lender_user_access_37.*
    FROM star_loan.loan_lender_user_access_37
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_37.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_37.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_37.octane_username = lender_user.lu_username
             AND loan_lender_user_access_37.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_37.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_37.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_37.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-38', 1, 'SELECT loan_lender_user_access_38.loan_dwid
     , loan_lender_user_access_38.octane_username
     , loan_lender_user_access_38.account_pid
FROM star_loan.loan_lender_user_access_38
LEFT JOIN (
    SELECT loan_lender_user_access_38.*
    FROM star_loan.loan_lender_user_access_38
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_38.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_38.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_38.octane_username = lender_user.lu_username
             AND loan_lender_user_access_38.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_38.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_38.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_38.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-39', 1, 'SELECT loan_lender_user_access_39.loan_dwid
     , loan_lender_user_access_39.octane_username
     , loan_lender_user_access_39.account_pid
FROM star_loan.loan_lender_user_access_39
LEFT JOIN (
    SELECT loan_lender_user_access_39.*
    FROM star_loan.loan_lender_user_access_39
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_39.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_39.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_39.octane_username = lender_user.lu_username
             AND loan_lender_user_access_39.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_39.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_39.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_39.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-40', 1, 'SELECT loan_lender_user_access_40.loan_dwid
     , loan_lender_user_access_40.octane_username
     , loan_lender_user_access_40.account_pid
FROM star_loan.loan_lender_user_access_40
LEFT JOIN (
    SELECT loan_lender_user_access_40.*
    FROM star_loan.loan_lender_user_access_40
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_40.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_40.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_40.octane_username = lender_user.lu_username
             AND loan_lender_user_access_40.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_40.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_40.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_40.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-41', 1, 'SELECT loan_lender_user_access_41.loan_dwid
     , loan_lender_user_access_41.octane_username
     , loan_lender_user_access_41.account_pid
FROM star_loan.loan_lender_user_access_41
LEFT JOIN (
    SELECT loan_lender_user_access_41.*
    FROM star_loan.loan_lender_user_access_41
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_41.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_41.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_41.octane_username = lender_user.lu_username
             AND loan_lender_user_access_41.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_41.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_41.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_41.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-42', 1, 'SELECT loan_lender_user_access_42.loan_dwid
     , loan_lender_user_access_42.octane_username
     , loan_lender_user_access_42.account_pid
FROM star_loan.loan_lender_user_access_42
LEFT JOIN (
    SELECT loan_lender_user_access_42.*
    FROM star_loan.loan_lender_user_access_42
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_42.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_42.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_42.octane_username = lender_user.lu_username
             AND loan_lender_user_access_42.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_42.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_42.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_42.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-43', 1, 'SELECT loan_lender_user_access_43.loan_dwid
     , loan_lender_user_access_43.octane_username
     , loan_lender_user_access_43.account_pid
FROM star_loan.loan_lender_user_access_43
LEFT JOIN (
    SELECT loan_lender_user_access_43.*
    FROM star_loan.loan_lender_user_access_43
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_43.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_43.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_43.octane_username = lender_user.lu_username
             AND loan_lender_user_access_43.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_43.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_43.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_43.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-44', 1, 'SELECT loan_lender_user_access_44.loan_dwid
     , loan_lender_user_access_44.octane_username
     , loan_lender_user_access_44.account_pid
FROM star_loan.loan_lender_user_access_44
LEFT JOIN (
    SELECT loan_lender_user_access_44.*
    FROM star_loan.loan_lender_user_access_44
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_44.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_44.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_44.octane_username = lender_user.lu_username
             AND loan_lender_user_access_44.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_44.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_44.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_44.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-45', 1, 'SELECT loan_lender_user_access_45.loan_dwid
     , loan_lender_user_access_45.octane_username
     , loan_lender_user_access_45.account_pid
FROM star_loan.loan_lender_user_access_45
LEFT JOIN (
    SELECT loan_lender_user_access_45.*
    FROM star_loan.loan_lender_user_access_45
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_45.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_45.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_45.octane_username = lender_user.lu_username
             AND loan_lender_user_access_45.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_45.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_45.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_45.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-46', 1, 'SELECT loan_lender_user_access_46.loan_dwid
     , loan_lender_user_access_46.octane_username
     , loan_lender_user_access_46.account_pid
FROM star_loan.loan_lender_user_access_46
LEFT JOIN (
    SELECT loan_lender_user_access_46.*
    FROM star_loan.loan_lender_user_access_46
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_46.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_46.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_46.octane_username = lender_user.lu_username
             AND loan_lender_user_access_46.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_46.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_46.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_46.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-47', 1, 'SELECT loan_lender_user_access_47.loan_dwid
     , loan_lender_user_access_47.octane_username
     , loan_lender_user_access_47.account_pid
FROM star_loan.loan_lender_user_access_47
LEFT JOIN (
    SELECT loan_lender_user_access_47.*
    FROM star_loan.loan_lender_user_access_47
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_47.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_47.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_47.octane_username = lender_user.lu_username
             AND loan_lender_user_access_47.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_47.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_47.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_47.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-48', 1, 'SELECT loan_lender_user_access_48.loan_dwid
     , loan_lender_user_access_48.octane_username
     , loan_lender_user_access_48.account_pid
FROM star_loan.loan_lender_user_access_48
LEFT JOIN (
    SELECT loan_lender_user_access_48.*
    FROM star_loan.loan_lender_user_access_48
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_48.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_48.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_48.octane_username = lender_user.lu_username
             AND loan_lender_user_access_48.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_48.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_48.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_48.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-49', 1, 'SELECT loan_lender_user_access_49.loan_dwid
     , loan_lender_user_access_49.octane_username
     , loan_lender_user_access_49.account_pid
FROM star_loan.loan_lender_user_access_49
LEFT JOIN (
    SELECT loan_lender_user_access_49.*
    FROM star_loan.loan_lender_user_access_49
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_49.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_49.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_49.octane_username = lender_user.lu_username
             AND loan_lender_user_access_49.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_49.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_49.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_49.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-50', 1, 'SELECT loan_lender_user_access_50.loan_dwid
     , loan_lender_user_access_50.octane_username
     , loan_lender_user_access_50.account_pid
FROM star_loan.loan_lender_user_access_50
LEFT JOIN (
    SELECT loan_lender_user_access_50.*
    FROM star_loan.loan_lender_user_access_50
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_50.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_50.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_50.octane_username = lender_user.lu_username
             AND loan_lender_user_access_50.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_50.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_50.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_50.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-51', 1, 'SELECT loan_lender_user_access_51.loan_dwid
     , loan_lender_user_access_51.octane_username
     , loan_lender_user_access_51.account_pid
FROM star_loan.loan_lender_user_access_51
LEFT JOIN (
    SELECT loan_lender_user_access_51.*
    FROM star_loan.loan_lender_user_access_51
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_51.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_51.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_51.octane_username = lender_user.lu_username
             AND loan_lender_user_access_51.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_51.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_51.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_51.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-52', 1, 'SELECT loan_lender_user_access_52.loan_dwid
     , loan_lender_user_access_52.octane_username
     , loan_lender_user_access_52.account_pid
FROM star_loan.loan_lender_user_access_52
LEFT JOIN (
    SELECT loan_lender_user_access_52.*
    FROM star_loan.loan_lender_user_access_52
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_52.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_52.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_52.octane_username = lender_user.lu_username
             AND loan_lender_user_access_52.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_52.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_52.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_52.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-53', 1, 'SELECT loan_lender_user_access_53.loan_dwid
     , loan_lender_user_access_53.octane_username
     , loan_lender_user_access_53.account_pid
FROM star_loan.loan_lender_user_access_53
LEFT JOIN (
    SELECT loan_lender_user_access_53.*
    FROM star_loan.loan_lender_user_access_53
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_53.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_53.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_53.octane_username = lender_user.lu_username
             AND loan_lender_user_access_53.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_53.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_53.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_53.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-54', 1, 'SELECT loan_lender_user_access_54.loan_dwid
     , loan_lender_user_access_54.octane_username
     , loan_lender_user_access_54.account_pid
FROM star_loan.loan_lender_user_access_54
LEFT JOIN (
    SELECT loan_lender_user_access_54.*
    FROM star_loan.loan_lender_user_access_54
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_54.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_54.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_54.octane_username = lender_user.lu_username
             AND loan_lender_user_access_54.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_54.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_54.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_54.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-55', 1, 'SELECT loan_lender_user_access_55.loan_dwid
     , loan_lender_user_access_55.octane_username
     , loan_lender_user_access_55.account_pid
FROM star_loan.loan_lender_user_access_55
LEFT JOIN (
    SELECT loan_lender_user_access_55.*
    FROM star_loan.loan_lender_user_access_55
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_55.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_55.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_55.octane_username = lender_user.lu_username
             AND loan_lender_user_access_55.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_55.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_55.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_55.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-56', 1, 'SELECT loan_lender_user_access_56.loan_dwid
     , loan_lender_user_access_56.octane_username
     , loan_lender_user_access_56.account_pid
FROM star_loan.loan_lender_user_access_56
LEFT JOIN (
    SELECT loan_lender_user_access_56.*
    FROM star_loan.loan_lender_user_access_56
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_56.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_56.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_56.octane_username = lender_user.lu_username
             AND loan_lender_user_access_56.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_56.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_56.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_56.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-57', 1, 'SELECT loan_lender_user_access_57.loan_dwid
     , loan_lender_user_access_57.octane_username
     , loan_lender_user_access_57.account_pid
FROM star_loan.loan_lender_user_access_57
LEFT JOIN (
    SELECT loan_lender_user_access_57.*
    FROM star_loan.loan_lender_user_access_57
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_57.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_57.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_57.octane_username = lender_user.lu_username
             AND loan_lender_user_access_57.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_57.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_57.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_57.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-58', 1, 'SELECT loan_lender_user_access_58.loan_dwid
     , loan_lender_user_access_58.octane_username
     , loan_lender_user_access_58.account_pid
FROM star_loan.loan_lender_user_access_58
LEFT JOIN (
    SELECT loan_lender_user_access_58.*
    FROM star_loan.loan_lender_user_access_58
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_58.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_58.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_58.octane_username = lender_user.lu_username
             AND loan_lender_user_access_58.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_58.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_58.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_58.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-59', 1, 'SELECT loan_lender_user_access_59.loan_dwid
     , loan_lender_user_access_59.octane_username
     , loan_lender_user_access_59.account_pid
FROM star_loan.loan_lender_user_access_59
LEFT JOIN (
    SELECT loan_lender_user_access_59.*
    FROM star_loan.loan_lender_user_access_59
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_59.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_59.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_59.octane_username = lender_user.lu_username
             AND loan_lender_user_access_59.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_59.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_59.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_59.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-60', 1, 'SELECT loan_lender_user_access_60.loan_dwid
     , loan_lender_user_access_60.octane_username
     , loan_lender_user_access_60.account_pid
FROM star_loan.loan_lender_user_access_60
LEFT JOIN (
    SELECT loan_lender_user_access_60.*
    FROM star_loan.loan_lender_user_access_60
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_60.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_60.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_60.octane_username = lender_user.lu_username
             AND loan_lender_user_access_60.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_60.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_60.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_60.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-61', 1, 'SELECT loan_lender_user_access_61.loan_dwid
     , loan_lender_user_access_61.octane_username
     , loan_lender_user_access_61.account_pid
FROM star_loan.loan_lender_user_access_61
LEFT JOIN (
    SELECT loan_lender_user_access_61.*
    FROM star_loan.loan_lender_user_access_61
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_61.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_61.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_61.octane_username = lender_user.lu_username
             AND loan_lender_user_access_61.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_61.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_61.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_61.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-62', 1, 'SELECT loan_lender_user_access_62.loan_dwid
     , loan_lender_user_access_62.octane_username
     , loan_lender_user_access_62.account_pid
FROM star_loan.loan_lender_user_access_62
LEFT JOIN (
    SELECT loan_lender_user_access_62.*
    FROM star_loan.loan_lender_user_access_62
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_62.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_62.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_62.octane_username = lender_user.lu_username
             AND loan_lender_user_access_62.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_62.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_62.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_62.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-63', 1, 'SELECT loan_lender_user_access_63.loan_dwid
     , loan_lender_user_access_63.octane_username
     , loan_lender_user_access_63.account_pid
FROM star_loan.loan_lender_user_access_63
LEFT JOIN (
    SELECT loan_lender_user_access_63.*
    FROM star_loan.loan_lender_user_access_63
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_63.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_63.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_63.octane_username = lender_user.lu_username
             AND loan_lender_user_access_63.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_63.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_63.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_63.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-64', 1, 'SELECT loan_lender_user_access_64.loan_dwid
     , loan_lender_user_access_64.octane_username
     , loan_lender_user_access_64.account_pid
FROM star_loan.loan_lender_user_access_64
LEFT JOIN (
    SELECT loan_lender_user_access_64.*
    FROM star_loan.loan_lender_user_access_64
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_64.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_64.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_64.octane_username = lender_user.lu_username
             AND loan_lender_user_access_64.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_64.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_64.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_64.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-65', 1, 'SELECT loan_lender_user_access_65.loan_dwid
     , loan_lender_user_access_65.octane_username
     , loan_lender_user_access_65.account_pid
FROM star_loan.loan_lender_user_access_65
LEFT JOIN (
    SELECT loan_lender_user_access_65.*
    FROM star_loan.loan_lender_user_access_65
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_65.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_65.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_65.octane_username = lender_user.lu_username
             AND loan_lender_user_access_65.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_65.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_65.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_65.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-66', 1, 'SELECT loan_lender_user_access_66.loan_dwid
     , loan_lender_user_access_66.octane_username
     , loan_lender_user_access_66.account_pid
FROM star_loan.loan_lender_user_access_66
LEFT JOIN (
    SELECT loan_lender_user_access_66.*
    FROM star_loan.loan_lender_user_access_66
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_66.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_66.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_66.octane_username = lender_user.lu_username
             AND loan_lender_user_access_66.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_66.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_66.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_66.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-67', 1, 'SELECT loan_lender_user_access_67.loan_dwid
     , loan_lender_user_access_67.octane_username
     , loan_lender_user_access_67.account_pid
FROM star_loan.loan_lender_user_access_67
LEFT JOIN (
    SELECT loan_lender_user_access_67.*
    FROM star_loan.loan_lender_user_access_67
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_67.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_67.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_67.octane_username = lender_user.lu_username
             AND loan_lender_user_access_67.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_67.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_67.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_67.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-68', 1, 'SELECT loan_lender_user_access_68.loan_dwid
     , loan_lender_user_access_68.octane_username
     , loan_lender_user_access_68.account_pid
FROM star_loan.loan_lender_user_access_68
LEFT JOIN (
    SELECT loan_lender_user_access_68.*
    FROM star_loan.loan_lender_user_access_68
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_68.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_68.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_68.octane_username = lender_user.lu_username
             AND loan_lender_user_access_68.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_68.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_68.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_68.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-69', 1, 'SELECT loan_lender_user_access_69.loan_dwid
     , loan_lender_user_access_69.octane_username
     , loan_lender_user_access_69.account_pid
FROM star_loan.loan_lender_user_access_69
LEFT JOIN (
    SELECT loan_lender_user_access_69.*
    FROM star_loan.loan_lender_user_access_69
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_69.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_69.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_69.octane_username = lender_user.lu_username
             AND loan_lender_user_access_69.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_69.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_69.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_69.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-70', 1, 'SELECT loan_lender_user_access_70.loan_dwid
     , loan_lender_user_access_70.octane_username
     , loan_lender_user_access_70.account_pid
FROM star_loan.loan_lender_user_access_70
LEFT JOIN (
    SELECT loan_lender_user_access_70.*
    FROM star_loan.loan_lender_user_access_70
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_70.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_70.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_70.octane_username = lender_user.lu_username
             AND loan_lender_user_access_70.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_70.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_70.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_70.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-71', 1, 'SELECT loan_lender_user_access_71.loan_dwid
     , loan_lender_user_access_71.octane_username
     , loan_lender_user_access_71.account_pid
FROM star_loan.loan_lender_user_access_71
LEFT JOIN (
    SELECT loan_lender_user_access_71.*
    FROM star_loan.loan_lender_user_access_71
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_71.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_71.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_71.octane_username = lender_user.lu_username
             AND loan_lender_user_access_71.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_71.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_71.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_71.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-72', 1, 'SELECT loan_lender_user_access_72.loan_dwid
     , loan_lender_user_access_72.octane_username
     , loan_lender_user_access_72.account_pid
FROM star_loan.loan_lender_user_access_72
LEFT JOIN (
    SELECT loan_lender_user_access_72.*
    FROM star_loan.loan_lender_user_access_72
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_72.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_72.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_72.octane_username = lender_user.lu_username
             AND loan_lender_user_access_72.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_72.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_72.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_72.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-73', 1, 'SELECT loan_lender_user_access_73.loan_dwid
     , loan_lender_user_access_73.octane_username
     , loan_lender_user_access_73.account_pid
FROM star_loan.loan_lender_user_access_73
LEFT JOIN (
    SELECT loan_lender_user_access_73.*
    FROM star_loan.loan_lender_user_access_73
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_73.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_73.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_73.octane_username = lender_user.lu_username
             AND loan_lender_user_access_73.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_73.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_73.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_73.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-74', 1, 'SELECT loan_lender_user_access_74.loan_dwid
     , loan_lender_user_access_74.octane_username
     , loan_lender_user_access_74.account_pid
FROM star_loan.loan_lender_user_access_74
LEFT JOIN (
    SELECT loan_lender_user_access_74.*
    FROM star_loan.loan_lender_user_access_74
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_74.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_74.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_74.octane_username = lender_user.lu_username
             AND loan_lender_user_access_74.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_74.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_74.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_74.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-75', 1, 'SELECT loan_lender_user_access_75.loan_dwid
     , loan_lender_user_access_75.octane_username
     , loan_lender_user_access_75.account_pid
FROM star_loan.loan_lender_user_access_75
LEFT JOIN (
    SELECT loan_lender_user_access_75.*
    FROM star_loan.loan_lender_user_access_75
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_75.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_75.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_75.octane_username = lender_user.lu_username
             AND loan_lender_user_access_75.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_75.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_75.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_75.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-76', 1, 'SELECT loan_lender_user_access_76.loan_dwid
     , loan_lender_user_access_76.octane_username
     , loan_lender_user_access_76.account_pid
FROM star_loan.loan_lender_user_access_76
LEFT JOIN (
    SELECT loan_lender_user_access_76.*
    FROM star_loan.loan_lender_user_access_76
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_76.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_76.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_76.octane_username = lender_user.lu_username
             AND loan_lender_user_access_76.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_76.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_76.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_76.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-77', 1, 'SELECT loan_lender_user_access_77.loan_dwid
     , loan_lender_user_access_77.octane_username
     , loan_lender_user_access_77.account_pid
FROM star_loan.loan_lender_user_access_77
LEFT JOIN (
    SELECT loan_lender_user_access_77.*
    FROM star_loan.loan_lender_user_access_77
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_77.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_77.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_77.octane_username = lender_user.lu_username
             AND loan_lender_user_access_77.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_77.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_77.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_77.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-78', 1, 'SELECT loan_lender_user_access_78.loan_dwid
     , loan_lender_user_access_78.octane_username
     , loan_lender_user_access_78.account_pid
FROM star_loan.loan_lender_user_access_78
LEFT JOIN (
    SELECT loan_lender_user_access_78.*
    FROM star_loan.loan_lender_user_access_78
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_78.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_78.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_78.octane_username = lender_user.lu_username
             AND loan_lender_user_access_78.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_78.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_78.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_78.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-79', 1, 'SELECT loan_lender_user_access_79.loan_dwid
     , loan_lender_user_access_79.octane_username
     , loan_lender_user_access_79.account_pid
FROM star_loan.loan_lender_user_access_79
LEFT JOIN (
    SELECT loan_lender_user_access_79.*
    FROM star_loan.loan_lender_user_access_79
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_79.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_79.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_79.octane_username = lender_user.lu_username
             AND loan_lender_user_access_79.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_79.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_79.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_79.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-80', 1, 'SELECT loan_lender_user_access_80.loan_dwid
     , loan_lender_user_access_80.octane_username
     , loan_lender_user_access_80.account_pid
FROM star_loan.loan_lender_user_access_80
LEFT JOIN (
    SELECT loan_lender_user_access_80.*
    FROM star_loan.loan_lender_user_access_80
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_80.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_80.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_80.octane_username = lender_user.lu_username
             AND loan_lender_user_access_80.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_80.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_80.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_80.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-81', 1, 'SELECT loan_lender_user_access_81.loan_dwid
     , loan_lender_user_access_81.octane_username
     , loan_lender_user_access_81.account_pid
FROM star_loan.loan_lender_user_access_81
LEFT JOIN (
    SELECT loan_lender_user_access_81.*
    FROM star_loan.loan_lender_user_access_81
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_81.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_81.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_81.octane_username = lender_user.lu_username
             AND loan_lender_user_access_81.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_81.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_81.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_81.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-82', 1, 'SELECT loan_lender_user_access_82.loan_dwid
     , loan_lender_user_access_82.octane_username
     , loan_lender_user_access_82.account_pid
FROM star_loan.loan_lender_user_access_82
LEFT JOIN (
    SELECT loan_lender_user_access_82.*
    FROM star_loan.loan_lender_user_access_82
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_82.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_82.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_82.octane_username = lender_user.lu_username
             AND loan_lender_user_access_82.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_82.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_82.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_82.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-83', 1, 'SELECT loan_lender_user_access_83.loan_dwid
     , loan_lender_user_access_83.octane_username
     , loan_lender_user_access_83.account_pid
FROM star_loan.loan_lender_user_access_83
LEFT JOIN (
    SELECT loan_lender_user_access_83.*
    FROM star_loan.loan_lender_user_access_83
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_83.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_83.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_83.octane_username = lender_user.lu_username
             AND loan_lender_user_access_83.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_83.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_83.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_83.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-84', 1, 'SELECT loan_lender_user_access_84.loan_dwid
     , loan_lender_user_access_84.octane_username
     , loan_lender_user_access_84.account_pid
FROM star_loan.loan_lender_user_access_84
LEFT JOIN (
    SELECT loan_lender_user_access_84.*
    FROM star_loan.loan_lender_user_access_84
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_84.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_84.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_84.octane_username = lender_user.lu_username
             AND loan_lender_user_access_84.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_84.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_84.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_84.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-85', 1, 'SELECT loan_lender_user_access_85.loan_dwid
     , loan_lender_user_access_85.octane_username
     , loan_lender_user_access_85.account_pid
FROM star_loan.loan_lender_user_access_85
LEFT JOIN (
    SELECT loan_lender_user_access_85.*
    FROM star_loan.loan_lender_user_access_85
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_85.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_85.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_85.octane_username = lender_user.lu_username
             AND loan_lender_user_access_85.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_85.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_85.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_85.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-86', 1, 'SELECT loan_lender_user_access_86.loan_dwid
     , loan_lender_user_access_86.octane_username
     , loan_lender_user_access_86.account_pid
FROM star_loan.loan_lender_user_access_86
LEFT JOIN (
    SELECT loan_lender_user_access_86.*
    FROM star_loan.loan_lender_user_access_86
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_86.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_86.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_86.octane_username = lender_user.lu_username
             AND loan_lender_user_access_86.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_86.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_86.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_86.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-87', 1, 'SELECT loan_lender_user_access_87.loan_dwid
     , loan_lender_user_access_87.octane_username
     , loan_lender_user_access_87.account_pid
FROM star_loan.loan_lender_user_access_87
LEFT JOIN (
    SELECT loan_lender_user_access_87.*
    FROM star_loan.loan_lender_user_access_87
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_87.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_87.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_87.octane_username = lender_user.lu_username
             AND loan_lender_user_access_87.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_87.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_87.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_87.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-88', 1, 'SELECT loan_lender_user_access_88.loan_dwid
     , loan_lender_user_access_88.octane_username
     , loan_lender_user_access_88.account_pid
FROM star_loan.loan_lender_user_access_88
LEFT JOIN (
    SELECT loan_lender_user_access_88.*
    FROM star_loan.loan_lender_user_access_88
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_88.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_88.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_88.octane_username = lender_user.lu_username
             AND loan_lender_user_access_88.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_88.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_88.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_88.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-89', 1, 'SELECT loan_lender_user_access_89.loan_dwid
     , loan_lender_user_access_89.octane_username
     , loan_lender_user_access_89.account_pid
FROM star_loan.loan_lender_user_access_89
LEFT JOIN (
    SELECT loan_lender_user_access_89.*
    FROM star_loan.loan_lender_user_access_89
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_89.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_89.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_89.octane_username = lender_user.lu_username
             AND loan_lender_user_access_89.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_89.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_89.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_89.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-90', 1, 'SELECT loan_lender_user_access_90.loan_dwid
     , loan_lender_user_access_90.octane_username
     , loan_lender_user_access_90.account_pid
FROM star_loan.loan_lender_user_access_90
LEFT JOIN (
    SELECT loan_lender_user_access_90.*
    FROM star_loan.loan_lender_user_access_90
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_90.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_90.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_90.octane_username = lender_user.lu_username
             AND loan_lender_user_access_90.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_90.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_90.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_90.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-91', 1, 'SELECT loan_lender_user_access_91.loan_dwid
     , loan_lender_user_access_91.octane_username
     , loan_lender_user_access_91.account_pid
FROM star_loan.loan_lender_user_access_91
LEFT JOIN (
    SELECT loan_lender_user_access_91.*
    FROM star_loan.loan_lender_user_access_91
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_91.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_91.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_91.octane_username = lender_user.lu_username
             AND loan_lender_user_access_91.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_91.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_91.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_91.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-92', 1, 'SELECT loan_lender_user_access_92.loan_dwid
     , loan_lender_user_access_92.octane_username
     , loan_lender_user_access_92.account_pid
FROM star_loan.loan_lender_user_access_92
LEFT JOIN (
    SELECT loan_lender_user_access_92.*
    FROM star_loan.loan_lender_user_access_92
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_92.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_92.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_92.octane_username = lender_user.lu_username
             AND loan_lender_user_access_92.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_92.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_92.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_92.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-93', 1, 'SELECT loan_lender_user_access_93.loan_dwid
     , loan_lender_user_access_93.octane_username
     , loan_lender_user_access_93.account_pid
FROM star_loan.loan_lender_user_access_93
LEFT JOIN (
    SELECT loan_lender_user_access_93.*
    FROM star_loan.loan_lender_user_access_93
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_93.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_93.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_93.octane_username = lender_user.lu_username
             AND loan_lender_user_access_93.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_93.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_93.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_93.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-94', 1, 'SELECT loan_lender_user_access_94.loan_dwid
     , loan_lender_user_access_94.octane_username
     , loan_lender_user_access_94.account_pid
FROM star_loan.loan_lender_user_access_94
LEFT JOIN (
    SELECT loan_lender_user_access_94.*
    FROM star_loan.loan_lender_user_access_94
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_94.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_94.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_94.octane_username = lender_user.lu_username
             AND loan_lender_user_access_94.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_94.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_94.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_94.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-95', 1, 'SELECT loan_lender_user_access_95.loan_dwid
     , loan_lender_user_access_95.octane_username
     , loan_lender_user_access_95.account_pid
FROM star_loan.loan_lender_user_access_95
LEFT JOIN (
    SELECT loan_lender_user_access_95.*
    FROM star_loan.loan_lender_user_access_95
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_95.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_95.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_95.octane_username = lender_user.lu_username
             AND loan_lender_user_access_95.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_95.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_95.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_95.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-96', 1, 'SELECT loan_lender_user_access_96.loan_dwid
     , loan_lender_user_access_96.octane_username
     , loan_lender_user_access_96.account_pid
FROM star_loan.loan_lender_user_access_96
LEFT JOIN (
    SELECT loan_lender_user_access_96.*
    FROM star_loan.loan_lender_user_access_96
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_96.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_96.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_96.octane_username = lender_user.lu_username
             AND loan_lender_user_access_96.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_96.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_96.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_96.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-97', 1, 'SELECT loan_lender_user_access_97.loan_dwid
     , loan_lender_user_access_97.octane_username
     , loan_lender_user_access_97.account_pid
FROM star_loan.loan_lender_user_access_97
LEFT JOIN (
    SELECT loan_lender_user_access_97.*
    FROM star_loan.loan_lender_user_access_97
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_97.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_97.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_97.octane_username = lender_user.lu_username
             AND loan_lender_user_access_97.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_97.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_97.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_97.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-98', 1, 'SELECT loan_lender_user_access_98.loan_dwid
     , loan_lender_user_access_98.octane_username
     , loan_lender_user_access_98.account_pid
FROM star_loan.loan_lender_user_access_98
LEFT JOIN (
    SELECT loan_lender_user_access_98.*
    FROM star_loan.loan_lender_user_access_98
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_98.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_98.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_98.octane_username = lender_user.lu_username
             AND loan_lender_user_access_98.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_98.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_98.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_98.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-200001-delete-99', 1, 'SELECT loan_lender_user_access_99.loan_dwid
     , loan_lender_user_access_99.octane_username
     , loan_lender_user_access_99.account_pid
FROM star_loan.loan_lender_user_access_99
LEFT JOIN (
    SELECT loan_lender_user_access_99.*
    FROM star_loan.loan_lender_user_access_99
        --loan_fact
    JOIN star_loan.loan_fact
         ON loan_lender_user_access_99.loan_dwid = loan_fact.loan_dwid
             AND loan_lender_user_access_99.data_source_dwid = loan_fact.data_source_dwid
        --loan
    JOIN history_octane.loan
         ON loan.l_pid = loan_fact.loan_pid
    LEFT JOIN history_octane.loan loan_history_records
              ON loan.l_pid = loan_history_records.l_pid
                  AND loan.data_source_updated_datetime < loan_history_records.data_source_updated_datetime
        --proposal
    JOIN history_octane.proposal
         ON proposal.prp_pid = loan.l_proposal_pid
    LEFT JOIN history_octane.proposal proposal_history_records
              ON proposal.prp_pid = proposal_history_records.prp_pid
                  AND proposal.data_source_updated_datetime < proposal_history_records.data_source_updated_datetime
        --deal
    JOIN history_octane.deal
         ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN history_octane.deal deal_history_records
              ON deal.d_pid = deal_history_records.d_pid
                  AND deal.data_source_updated_datetime < deal_history_records.data_source_updated_datetime
        --lender_user
    JOIN history_octane.lender_user
         ON loan_lender_user_access_99.octane_username = lender_user.lu_username
             AND loan_lender_user_access_99.account_pid = lender_user.lu_account_pid
    LEFT JOIN history_octane.lender_user AS lender_user_history_records
              ON lender_user.lu_pid = lender_user_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lender_user_history_records.data_source_updated_datetime
        --deal_lender_user
    JOIN history_octane.deal_lender_user
         ON deal.d_pid = deal_lender_user.dlu_deal_pid
             AND lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.deal_lender_user AS deal_lender_user_history_records
              ON deal_lender_user.dlu_pid = deal_lender_user_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < deal_lender_user_history_records.data_source_updated_datetime
    WHERE loan_history_records.l_pid IS NULL
      AND NOT loan.data_source_deleted_flag
      AND proposal_history_records.prp_pid IS NULL
      AND NOT proposal.data_source_deleted_flag
      AND deal_history_records.d_pid IS NULL
      AND NOT deal.data_source_deleted_flag
      AND lender_user_history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND deal_lender_user_history_records.dlu_pid IS NULL
      AND NOT deal_lender_user.data_source_deleted_flag
) AS active_access_data
          ON loan_lender_user_access_99.octane_username = active_access_data.octane_username
              AND loan_lender_user_access_99.account_pid = active_access_data.account_pid
              AND loan_lender_user_access_99.loan_dwid = active_access_data.loan_dwid
WHERE active_access_data.dwid IS NULL;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--delete_step
WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (
    VALUES ('SP-200001-delete-0', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-1', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-2', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-3', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-4', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-5', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-6', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-7', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-8', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-9', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-10', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-11', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-12', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-13', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-14', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-15', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-16', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-17', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-18', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-19', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-20', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-21', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-22', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-23', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-24', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-25', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-26', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-27', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-28', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-29', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-30', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-31', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-32', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-33', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-34', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-35', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-36', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-37', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-38', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-39', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-40', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-41', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-42', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-43', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-44', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-45', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-46', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-47', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-48', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-49', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-50', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-51', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-52', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-53', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-54', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-55', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-56', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-57', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-58', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-59', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-60', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-61', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-62', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-63', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-64', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-65', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-66', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-67', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-68', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-69', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-70', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-71', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-72', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-73', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-74', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-75', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-76', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-77', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-78', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-79', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-80', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-81', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-82', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-83', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-84', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-85', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-86', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-87', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-88', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-89', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-90', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-91', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-92', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-93', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-94', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-95', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-96', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-97', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-98', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-99', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
)
INSERT INTO mdi.delete_step (process_dwid, connectionname, schema_name, table_name, commit_size)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--delete_key
WITH insert_rows (process_name, table_name_field) AS (
    VALUES ('SP-200001-delete-0', 'octane_username')
         , ('SP-200001-delete-0', 'loan_dwid')
         , ('SP-200001-delete-0', 'account_pid')
         , ('SP-200001-delete-1', 'octane_username')
         , ('SP-200001-delete-1', 'loan_dwid')
         , ('SP-200001-delete-1', 'account_pid')
         , ('SP-200001-delete-2', 'octane_username')
         , ('SP-200001-delete-2', 'loan_dwid')
         , ('SP-200001-delete-2', 'account_pid')
         , ('SP-200001-delete-3', 'octane_username')
         , ('SP-200001-delete-3', 'loan_dwid')
         , ('SP-200001-delete-3', 'account_pid')
         , ('SP-200001-delete-4', 'octane_username')
         , ('SP-200001-delete-4', 'loan_dwid')
         , ('SP-200001-delete-4', 'account_pid')
         , ('SP-200001-delete-5', 'octane_username')
         , ('SP-200001-delete-5', 'loan_dwid')
         , ('SP-200001-delete-5', 'account_pid')
         , ('SP-200001-delete-6', 'octane_username')
         , ('SP-200001-delete-6', 'loan_dwid')
         , ('SP-200001-delete-6', 'account_pid')
         , ('SP-200001-delete-7', 'octane_username')
         , ('SP-200001-delete-7', 'loan_dwid')
         , ('SP-200001-delete-7', 'account_pid')
         , ('SP-200001-delete-8', 'octane_username')
         , ('SP-200001-delete-8', 'loan_dwid')
         , ('SP-200001-delete-8', 'account_pid')
         , ('SP-200001-delete-9', 'octane_username')
         , ('SP-200001-delete-9', 'loan_dwid')
         , ('SP-200001-delete-9', 'account_pid')
         , ('SP-200001-delete-10', 'octane_username')
         , ('SP-200001-delete-10', 'loan_dwid')
         , ('SP-200001-delete-10', 'account_pid')
         , ('SP-200001-delete-11', 'octane_username')
         , ('SP-200001-delete-11', 'loan_dwid')
         , ('SP-200001-delete-11', 'account_pid')
         , ('SP-200001-delete-12', 'octane_username')
         , ('SP-200001-delete-12', 'loan_dwid')
         , ('SP-200001-delete-12', 'account_pid')
         , ('SP-200001-delete-13', 'octane_username')
         , ('SP-200001-delete-13', 'loan_dwid')
         , ('SP-200001-delete-13', 'account_pid')
         , ('SP-200001-delete-14', 'octane_username')
         , ('SP-200001-delete-14', 'loan_dwid')
         , ('SP-200001-delete-14', 'account_pid')
         , ('SP-200001-delete-15', 'octane_username')
         , ('SP-200001-delete-15', 'loan_dwid')
         , ('SP-200001-delete-15', 'account_pid')
         , ('SP-200001-delete-16', 'octane_username')
         , ('SP-200001-delete-16', 'loan_dwid')
         , ('SP-200001-delete-16', 'account_pid')
         , ('SP-200001-delete-17', 'octane_username')
         , ('SP-200001-delete-17', 'loan_dwid')
         , ('SP-200001-delete-17', 'account_pid')
         , ('SP-200001-delete-18', 'octane_username')
         , ('SP-200001-delete-18', 'loan_dwid')
         , ('SP-200001-delete-18', 'account_pid')
         , ('SP-200001-delete-19', 'octane_username')
         , ('SP-200001-delete-19', 'loan_dwid')
         , ('SP-200001-delete-19', 'account_pid')
         , ('SP-200001-delete-20', 'octane_username')
         , ('SP-200001-delete-20', 'loan_dwid')
         , ('SP-200001-delete-20', 'account_pid')
         , ('SP-200001-delete-21', 'octane_username')
         , ('SP-200001-delete-21', 'loan_dwid')
         , ('SP-200001-delete-21', 'account_pid')
         , ('SP-200001-delete-22', 'octane_username')
         , ('SP-200001-delete-22', 'loan_dwid')
         , ('SP-200001-delete-22', 'account_pid')
         , ('SP-200001-delete-23', 'octane_username')
         , ('SP-200001-delete-23', 'loan_dwid')
         , ('SP-200001-delete-23', 'account_pid')
         , ('SP-200001-delete-24', 'octane_username')
         , ('SP-200001-delete-24', 'loan_dwid')
         , ('SP-200001-delete-24', 'account_pid')
         , ('SP-200001-delete-25', 'octane_username')
         , ('SP-200001-delete-25', 'loan_dwid')
         , ('SP-200001-delete-25', 'account_pid')
         , ('SP-200001-delete-26', 'octane_username')
         , ('SP-200001-delete-26', 'loan_dwid')
         , ('SP-200001-delete-26', 'account_pid')
         , ('SP-200001-delete-27', 'octane_username')
         , ('SP-200001-delete-27', 'loan_dwid')
         , ('SP-200001-delete-27', 'account_pid')
         , ('SP-200001-delete-28', 'octane_username')
         , ('SP-200001-delete-28', 'loan_dwid')
         , ('SP-200001-delete-28', 'account_pid')
         , ('SP-200001-delete-29', 'octane_username')
         , ('SP-200001-delete-29', 'loan_dwid')
         , ('SP-200001-delete-29', 'account_pid')
         , ('SP-200001-delete-30', 'octane_username')
         , ('SP-200001-delete-30', 'loan_dwid')
         , ('SP-200001-delete-30', 'account_pid')
         , ('SP-200001-delete-31', 'octane_username')
         , ('SP-200001-delete-31', 'loan_dwid')
         , ('SP-200001-delete-31', 'account_pid')
         , ('SP-200001-delete-32', 'octane_username')
         , ('SP-200001-delete-32', 'loan_dwid')
         , ('SP-200001-delete-32', 'account_pid')
         , ('SP-200001-delete-33', 'octane_username')
         , ('SP-200001-delete-33', 'loan_dwid')
         , ('SP-200001-delete-33', 'account_pid')
         , ('SP-200001-delete-34', 'octane_username')
         , ('SP-200001-delete-34', 'loan_dwid')
         , ('SP-200001-delete-34', 'account_pid')
         , ('SP-200001-delete-35', 'octane_username')
         , ('SP-200001-delete-35', 'loan_dwid')
         , ('SP-200001-delete-35', 'account_pid')
         , ('SP-200001-delete-36', 'octane_username')
         , ('SP-200001-delete-36', 'loan_dwid')
         , ('SP-200001-delete-36', 'account_pid')
         , ('SP-200001-delete-37', 'octane_username')
         , ('SP-200001-delete-37', 'loan_dwid')
         , ('SP-200001-delete-37', 'account_pid')
         , ('SP-200001-delete-38', 'octane_username')
         , ('SP-200001-delete-38', 'loan_dwid')
         , ('SP-200001-delete-38', 'account_pid')
         , ('SP-200001-delete-39', 'octane_username')
         , ('SP-200001-delete-39', 'loan_dwid')
         , ('SP-200001-delete-39', 'account_pid')
         , ('SP-200001-delete-40', 'octane_username')
         , ('SP-200001-delete-40', 'loan_dwid')
         , ('SP-200001-delete-40', 'account_pid')
         , ('SP-200001-delete-41', 'octane_username')
         , ('SP-200001-delete-41', 'loan_dwid')
         , ('SP-200001-delete-41', 'account_pid')
         , ('SP-200001-delete-42', 'octane_username')
         , ('SP-200001-delete-42', 'loan_dwid')
         , ('SP-200001-delete-42', 'account_pid')
         , ('SP-200001-delete-43', 'octane_username')
         , ('SP-200001-delete-43', 'loan_dwid')
         , ('SP-200001-delete-43', 'account_pid')
         , ('SP-200001-delete-44', 'octane_username')
         , ('SP-200001-delete-44', 'loan_dwid')
         , ('SP-200001-delete-44', 'account_pid')
         , ('SP-200001-delete-45', 'octane_username')
         , ('SP-200001-delete-45', 'loan_dwid')
         , ('SP-200001-delete-45', 'account_pid')
         , ('SP-200001-delete-46', 'octane_username')
         , ('SP-200001-delete-46', 'loan_dwid')
         , ('SP-200001-delete-46', 'account_pid')
         , ('SP-200001-delete-47', 'octane_username')
         , ('SP-200001-delete-47', 'loan_dwid')
         , ('SP-200001-delete-47', 'account_pid')
         , ('SP-200001-delete-48', 'octane_username')
         , ('SP-200001-delete-48', 'loan_dwid')
         , ('SP-200001-delete-48', 'account_pid')
         , ('SP-200001-delete-49', 'octane_username')
         , ('SP-200001-delete-49', 'loan_dwid')
         , ('SP-200001-delete-49', 'account_pid')
         , ('SP-200001-delete-50', 'octane_username')
         , ('SP-200001-delete-50', 'loan_dwid')
         , ('SP-200001-delete-50', 'account_pid')
         , ('SP-200001-delete-51', 'octane_username')
         , ('SP-200001-delete-51', 'loan_dwid')
         , ('SP-200001-delete-51', 'account_pid')
         , ('SP-200001-delete-52', 'octane_username')
         , ('SP-200001-delete-52', 'loan_dwid')
         , ('SP-200001-delete-52', 'account_pid')
         , ('SP-200001-delete-53', 'octane_username')
         , ('SP-200001-delete-53', 'loan_dwid')
         , ('SP-200001-delete-53', 'account_pid')
         , ('SP-200001-delete-54', 'octane_username')
         , ('SP-200001-delete-54', 'loan_dwid')
         , ('SP-200001-delete-54', 'account_pid')
         , ('SP-200001-delete-55', 'octane_username')
         , ('SP-200001-delete-55', 'loan_dwid')
         , ('SP-200001-delete-55', 'account_pid')
         , ('SP-200001-delete-56', 'octane_username')
         , ('SP-200001-delete-56', 'loan_dwid')
         , ('SP-200001-delete-56', 'account_pid')
         , ('SP-200001-delete-57', 'octane_username')
         , ('SP-200001-delete-57', 'loan_dwid')
         , ('SP-200001-delete-57', 'account_pid')
         , ('SP-200001-delete-58', 'octane_username')
         , ('SP-200001-delete-58', 'loan_dwid')
         , ('SP-200001-delete-58', 'account_pid')
         , ('SP-200001-delete-59', 'octane_username')
         , ('SP-200001-delete-59', 'loan_dwid')
         , ('SP-200001-delete-59', 'account_pid')
         , ('SP-200001-delete-60', 'octane_username')
         , ('SP-200001-delete-60', 'loan_dwid')
         , ('SP-200001-delete-60', 'account_pid')
         , ('SP-200001-delete-61', 'octane_username')
         , ('SP-200001-delete-61', 'loan_dwid')
         , ('SP-200001-delete-61', 'account_pid')
         , ('SP-200001-delete-62', 'octane_username')
         , ('SP-200001-delete-62', 'loan_dwid')
         , ('SP-200001-delete-62', 'account_pid')
         , ('SP-200001-delete-63', 'octane_username')
         , ('SP-200001-delete-63', 'loan_dwid')
         , ('SP-200001-delete-63', 'account_pid')
         , ('SP-200001-delete-64', 'octane_username')
         , ('SP-200001-delete-64', 'loan_dwid')
         , ('SP-200001-delete-64', 'account_pid')
         , ('SP-200001-delete-65', 'octane_username')
         , ('SP-200001-delete-65', 'loan_dwid')
         , ('SP-200001-delete-65', 'account_pid')
         , ('SP-200001-delete-66', 'octane_username')
         , ('SP-200001-delete-66', 'loan_dwid')
         , ('SP-200001-delete-66', 'account_pid')
         , ('SP-200001-delete-67', 'octane_username')
         , ('SP-200001-delete-67', 'loan_dwid')
         , ('SP-200001-delete-67', 'account_pid')
         , ('SP-200001-delete-68', 'octane_username')
         , ('SP-200001-delete-68', 'loan_dwid')
         , ('SP-200001-delete-68', 'account_pid')
         , ('SP-200001-delete-69', 'octane_username')
         , ('SP-200001-delete-69', 'loan_dwid')
         , ('SP-200001-delete-69', 'account_pid')
         , ('SP-200001-delete-70', 'octane_username')
         , ('SP-200001-delete-70', 'loan_dwid')
         , ('SP-200001-delete-70', 'account_pid')
         , ('SP-200001-delete-71', 'octane_username')
         , ('SP-200001-delete-71', 'loan_dwid')
         , ('SP-200001-delete-71', 'account_pid')
         , ('SP-200001-delete-72', 'octane_username')
         , ('SP-200001-delete-72', 'loan_dwid')
         , ('SP-200001-delete-72', 'account_pid')
         , ('SP-200001-delete-73', 'octane_username')
         , ('SP-200001-delete-73', 'loan_dwid')
         , ('SP-200001-delete-73', 'account_pid')
         , ('SP-200001-delete-74', 'octane_username')
         , ('SP-200001-delete-74', 'loan_dwid')
         , ('SP-200001-delete-74', 'account_pid')
         , ('SP-200001-delete-75', 'octane_username')
         , ('SP-200001-delete-75', 'loan_dwid')
         , ('SP-200001-delete-75', 'account_pid')
         , ('SP-200001-delete-76', 'octane_username')
         , ('SP-200001-delete-76', 'loan_dwid')
         , ('SP-200001-delete-76', 'account_pid')
         , ('SP-200001-delete-77', 'octane_username')
         , ('SP-200001-delete-77', 'loan_dwid')
         , ('SP-200001-delete-77', 'account_pid')
         , ('SP-200001-delete-78', 'octane_username')
         , ('SP-200001-delete-78', 'loan_dwid')
         , ('SP-200001-delete-78', 'account_pid')
         , ('SP-200001-delete-79', 'octane_username')
         , ('SP-200001-delete-79', 'loan_dwid')
         , ('SP-200001-delete-79', 'account_pid')
         , ('SP-200001-delete-80', 'octane_username')
         , ('SP-200001-delete-80', 'loan_dwid')
         , ('SP-200001-delete-80', 'account_pid')
         , ('SP-200001-delete-81', 'octane_username')
         , ('SP-200001-delete-81', 'loan_dwid')
         , ('SP-200001-delete-81', 'account_pid')
         , ('SP-200001-delete-82', 'octane_username')
         , ('SP-200001-delete-82', 'loan_dwid')
         , ('SP-200001-delete-82', 'account_pid')
         , ('SP-200001-delete-83', 'octane_username')
         , ('SP-200001-delete-83', 'loan_dwid')
         , ('SP-200001-delete-83', 'account_pid')
         , ('SP-200001-delete-84', 'octane_username')
         , ('SP-200001-delete-84', 'loan_dwid')
         , ('SP-200001-delete-84', 'account_pid')
         , ('SP-200001-delete-85', 'octane_username')
         , ('SP-200001-delete-85', 'loan_dwid')
         , ('SP-200001-delete-85', 'account_pid')
         , ('SP-200001-delete-86', 'octane_username')
         , ('SP-200001-delete-86', 'loan_dwid')
         , ('SP-200001-delete-86', 'account_pid')
         , ('SP-200001-delete-87', 'octane_username')
         , ('SP-200001-delete-87', 'loan_dwid')
         , ('SP-200001-delete-87', 'account_pid')
         , ('SP-200001-delete-88', 'octane_username')
         , ('SP-200001-delete-88', 'loan_dwid')
         , ('SP-200001-delete-88', 'account_pid')
         , ('SP-200001-delete-89', 'octane_username')
         , ('SP-200001-delete-89', 'loan_dwid')
         , ('SP-200001-delete-89', 'account_pid')
         , ('SP-200001-delete-90', 'octane_username')
         , ('SP-200001-delete-90', 'loan_dwid')
         , ('SP-200001-delete-90', 'account_pid')
         , ('SP-200001-delete-91', 'octane_username')
         , ('SP-200001-delete-91', 'loan_dwid')
         , ('SP-200001-delete-91', 'account_pid')
         , ('SP-200001-delete-92', 'octane_username')
         , ('SP-200001-delete-92', 'loan_dwid')
         , ('SP-200001-delete-92', 'account_pid')
         , ('SP-200001-delete-93', 'octane_username')
         , ('SP-200001-delete-93', 'loan_dwid')
         , ('SP-200001-delete-93', 'account_pid')
         , ('SP-200001-delete-94', 'octane_username')
         , ('SP-200001-delete-94', 'loan_dwid')
         , ('SP-200001-delete-94', 'account_pid')
         , ('SP-200001-delete-95', 'octane_username')
         , ('SP-200001-delete-95', 'loan_dwid')
         , ('SP-200001-delete-95', 'account_pid')
         , ('SP-200001-delete-96', 'octane_username')
         , ('SP-200001-delete-96', 'loan_dwid')
         , ('SP-200001-delete-96', 'account_pid')
         , ('SP-200001-delete-97', 'octane_username')
         , ('SP-200001-delete-97', 'loan_dwid')
         , ('SP-200001-delete-97', 'account_pid')
         , ('SP-200001-delete-98', 'octane_username')
         , ('SP-200001-delete-98', 'loan_dwid')
         , ('SP-200001-delete-98', 'account_pid')
         , ('SP-200001-delete-99', 'octane_username')
         , ('SP-200001-delete-99', 'loan_dwid')
         , ('SP-200001-delete-99', 'account_pid')
)
INSERT INTO mdi.delete_key (delete_step_dwid, table_name_field, stream_fieldname_1, stream_fieldname_2, comparator, is_sensitive)
SELECT delete_step.dwid, insert_rows.table_name_field, insert_rows.table_name_field, '', '=', FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.delete_step
     ON process.dwid = delete_step.process_dwid;

--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
    VALUES ('SP-200001-delete-0', 'dwid')
         , ('SP-200001-delete-1', 'dwid')
         , ('SP-200001-delete-2', 'dwid')
         , ('SP-200001-delete-3', 'dwid')
         , ('SP-200001-delete-4', 'dwid')
         , ('SP-200001-delete-5', 'dwid')
         , ('SP-200001-delete-6', 'dwid')
         , ('SP-200001-delete-7', 'dwid')
         , ('SP-200001-delete-8', 'dwid')
         , ('SP-200001-delete-9', 'dwid')
         , ('SP-200001-delete-10', 'dwid')
         , ('SP-200001-delete-11', 'dwid')
         , ('SP-200001-delete-12', 'dwid')
         , ('SP-200001-delete-13', 'dwid')
         , ('SP-200001-delete-14', 'dwid')
         , ('SP-200001-delete-15', 'dwid')
         , ('SP-200001-delete-16', 'dwid')
         , ('SP-200001-delete-17', 'dwid')
         , ('SP-200001-delete-18', 'dwid')
         , ('SP-200001-delete-19', 'dwid')
         , ('SP-200001-delete-20', 'dwid')
         , ('SP-200001-delete-21', 'dwid')
         , ('SP-200001-delete-22', 'dwid')
         , ('SP-200001-delete-23', 'dwid')
         , ('SP-200001-delete-24', 'dwid')
         , ('SP-200001-delete-25', 'dwid')
         , ('SP-200001-delete-26', 'dwid')
         , ('SP-200001-delete-27', 'dwid')
         , ('SP-200001-delete-28', 'dwid')
         , ('SP-200001-delete-29', 'dwid')
         , ('SP-200001-delete-30', 'dwid')
         , ('SP-200001-delete-31', 'dwid')
         , ('SP-200001-delete-32', 'dwid')
         , ('SP-200001-delete-33', 'dwid')
         , ('SP-200001-delete-34', 'dwid')
         , ('SP-200001-delete-35', 'dwid')
         , ('SP-200001-delete-36', 'dwid')
         , ('SP-200001-delete-37', 'dwid')
         , ('SP-200001-delete-38', 'dwid')
         , ('SP-200001-delete-39', 'dwid')
         , ('SP-200001-delete-40', 'dwid')
         , ('SP-200001-delete-41', 'dwid')
         , ('SP-200001-delete-42', 'dwid')
         , ('SP-200001-delete-43', 'dwid')
         , ('SP-200001-delete-44', 'dwid')
         , ('SP-200001-delete-45', 'dwid')
         , ('SP-200001-delete-46', 'dwid')
         , ('SP-200001-delete-47', 'dwid')
         , ('SP-200001-delete-48', 'dwid')
         , ('SP-200001-delete-49', 'dwid')
         , ('SP-200001-delete-50', 'dwid')
         , ('SP-200001-delete-51', 'dwid')
         , ('SP-200001-delete-52', 'dwid')
         , ('SP-200001-delete-53', 'dwid')
         , ('SP-200001-delete-54', 'dwid')
         , ('SP-200001-delete-55', 'dwid')
         , ('SP-200001-delete-56', 'dwid')
         , ('SP-200001-delete-57', 'dwid')
         , ('SP-200001-delete-58', 'dwid')
         , ('SP-200001-delete-59', 'dwid')
         , ('SP-200001-delete-60', 'dwid')
         , ('SP-200001-delete-61', 'dwid')
         , ('SP-200001-delete-62', 'dwid')
         , ('SP-200001-delete-63', 'dwid')
         , ('SP-200001-delete-64', 'dwid')
         , ('SP-200001-delete-65', 'dwid')
         , ('SP-200001-delete-66', 'dwid')
         , ('SP-200001-delete-67', 'dwid')
         , ('SP-200001-delete-68', 'dwid')
         , ('SP-200001-delete-69', 'dwid')
         , ('SP-200001-delete-70', 'dwid')
         , ('SP-200001-delete-71', 'dwid')
         , ('SP-200001-delete-72', 'dwid')
         , ('SP-200001-delete-73', 'dwid')
         , ('SP-200001-delete-74', 'dwid')
         , ('SP-200001-delete-75', 'dwid')
         , ('SP-200001-delete-76', 'dwid')
         , ('SP-200001-delete-77', 'dwid')
         , ('SP-200001-delete-78', 'dwid')
         , ('SP-200001-delete-79', 'dwid')
         , ('SP-200001-delete-80', 'dwid')
         , ('SP-200001-delete-81', 'dwid')
         , ('SP-200001-delete-82', 'dwid')
         , ('SP-200001-delete-83', 'dwid')
         , ('SP-200001-delete-84', 'dwid')
         , ('SP-200001-delete-85', 'dwid')
         , ('SP-200001-delete-86', 'dwid')
         , ('SP-200001-delete-87', 'dwid')
         , ('SP-200001-delete-88', 'dwid')
         , ('SP-200001-delete-89', 'dwid')
         , ('SP-200001-delete-90', 'dwid')
         , ('SP-200001-delete-91', 'dwid')
         , ('SP-200001-delete-92', 'dwid')
         , ('SP-200001-delete-93', 'dwid')
         , ('SP-200001-delete-94', 'dwid')
         , ('SP-200001-delete-95', 'dwid')
         , ('SP-200001-delete-96', 'dwid')
         , ('SP-200001-delete-97', 'dwid')
         , ('SP-200001-delete-98', 'dwid')
         , ('SP-200001-delete-99', 'dwid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-200001-delete-0', 'SP-200001-delete-0', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-1', 'SP-200001-delete-1', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-2', 'SP-200001-delete-2', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-3', 'SP-200001-delete-3', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-4', 'SP-200001-delete-4', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-5', 'SP-200001-delete-5', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-6', 'SP-200001-delete-6', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-7', 'SP-200001-delete-7', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-8', 'SP-200001-delete-8', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-9', 'SP-200001-delete-9', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-10', 'SP-200001-delete-10', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-11', 'SP-200001-delete-11', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-12', 'SP-200001-delete-12', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-13', 'SP-200001-delete-13', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-14', 'SP-200001-delete-14', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-15', 'SP-200001-delete-15', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-16', 'SP-200001-delete-16', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-17', 'SP-200001-delete-17', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-18', 'SP-200001-delete-18', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-19', 'SP-200001-delete-19', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-20', 'SP-200001-delete-20', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-21', 'SP-200001-delete-21', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-22', 'SP-200001-delete-22', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-23', 'SP-200001-delete-23', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-24', 'SP-200001-delete-24', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-25', 'SP-200001-delete-25', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-26', 'SP-200001-delete-26', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-27', 'SP-200001-delete-27', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-28', 'SP-200001-delete-28', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-29', 'SP-200001-delete-29', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-30', 'SP-200001-delete-30', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-31', 'SP-200001-delete-31', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-32', 'SP-200001-delete-32', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-33', 'SP-200001-delete-33', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-34', 'SP-200001-delete-34', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-35', 'SP-200001-delete-35', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-36', 'SP-200001-delete-36', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-37', 'SP-200001-delete-37', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-38', 'SP-200001-delete-38', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-39', 'SP-200001-delete-39', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-40', 'SP-200001-delete-40', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-41', 'SP-200001-delete-41', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-42', 'SP-200001-delete-42', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-43', 'SP-200001-delete-43', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-44', 'SP-200001-delete-44', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-45', 'SP-200001-delete-45', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-46', 'SP-200001-delete-46', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-47', 'SP-200001-delete-47', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-48', 'SP-200001-delete-48', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-49', 'SP-200001-delete-49', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-50', 'SP-200001-delete-50', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-51', 'SP-200001-delete-51', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-52', 'SP-200001-delete-52', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-53', 'SP-200001-delete-53', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-54', 'SP-200001-delete-54', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-55', 'SP-200001-delete-55', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-56', 'SP-200001-delete-56', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-57', 'SP-200001-delete-57', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-58', 'SP-200001-delete-58', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-59', 'SP-200001-delete-59', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-60', 'SP-200001-delete-60', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-61', 'SP-200001-delete-61', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-62', 'SP-200001-delete-62', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-63', 'SP-200001-delete-63', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-64', 'SP-200001-delete-64', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-65', 'SP-200001-delete-65', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-66', 'SP-200001-delete-66', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-67', 'SP-200001-delete-67', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-68', 'SP-200001-delete-68', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-69', 'SP-200001-delete-69', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-70', 'SP-200001-delete-70', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-71', 'SP-200001-delete-71', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-72', 'SP-200001-delete-72', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-73', 'SP-200001-delete-73', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-74', 'SP-200001-delete-74', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-75', 'SP-200001-delete-75', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-76', 'SP-200001-delete-76', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-77', 'SP-200001-delete-77', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-78', 'SP-200001-delete-78', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-79', 'SP-200001-delete-79', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-80', 'SP-200001-delete-80', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-81', 'SP-200001-delete-81', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-82', 'SP-200001-delete-82', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-83', 'SP-200001-delete-83', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-84', 'SP-200001-delete-84', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-85', 'SP-200001-delete-85', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-86', 'SP-200001-delete-86', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-87', 'SP-200001-delete-87', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-88', 'SP-200001-delete-88', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-89', 'SP-200001-delete-89', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-90', 'SP-200001-delete-90', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-91', 'SP-200001-delete-91', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-92', 'SP-200001-delete-92', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-93', 'SP-200001-delete-93', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-94', 'SP-200001-delete-94', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-95', 'SP-200001-delete-95', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-96', 'SP-200001-delete-96', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-97', 'SP-200001-delete-97', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-98', 'SP-200001-delete-98', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete-99', 'SP-200001-delete-99', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

/*
DELETIONS
*/

--state_machine_definition
WITH delete_keys (process_name) AS (
    VALUES ('SP-200001-delete')
)
DELETE
FROM mdi.state_machine_definition
    USING delete_keys, mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--json_output_field
WITH delete_keys (process_name) AS (
    VALUES ('SP-200001-delete')
)
DELETE
FROM mdi.json_output_field
    USING delete_keys, mdi.process
WHERE json_output_field.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--delete_key
WITH delete_keys (process_name) AS (
    VALUES ('SP-200001-delete', 'octane_username')
         , ('SP-200001-delete', 'loan_dwid')
         , ('SP-200001-delete', 'account_pid')
)
DELETE
FROM mdi.delete_key
    USING delete_keys, mdi.process, mdi.delete_step
WHERE delete_key.delete_step_dwid = delete_step.dwid  AND delete_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--delete_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-200001-delete')
)
DELETE
FROM mdi.delete_step
    USING delete_keys, mdi.process
WHERE delete_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_input_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-200001-delete')
)
DELETE
FROM mdi.table_input_step
    USING delete_keys, mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--process
WITH delete_keys (process_name) AS (
    VALUES ('SP-200001-delete')
)
DELETE
FROM mdi.process
    USING delete_keys
WHERE process.name = delete_keys.process_name;
