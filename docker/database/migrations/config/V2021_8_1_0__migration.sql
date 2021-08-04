--
-- EDW | update loan_lender_user_access to use the Octane Username instead of lender_user_pid
-- https://app.asana.com/0/0/1200638045967903
--

--update edw_field_definition
WITH temp_table_definition AS (
    SELECT edw_table_definition.dwid
    FROM mdi.edw_table_definition
    WHERE edw_table_definition.schema_name = 'star_loan'
      AND edw_table_definition.table_name = 'loan_lender_user_access'
)
   , insert_octane_username_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type, reporting_hidden, reporting_key_flag)
        SELECT temp_table_definition.dwid, 'octane_username', TRUE, 'TEXT', 'yes', FALSE
        FROM temp_table_definition
)
   , insert_account_pid_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type, reporting_hidden, reporting_key_flag)
        SELECT temp_table_definition.dwid, 'account_pid', TRUE, 'BIGINT', 'yes', FALSE
        FROM temp_table_definition
)
   , delete_lender_user_pid_field_definition AS (
    DELETE FROM mdi.edw_field_definition
        USING temp_table_definition
        WHERE edw_field_definition.edw_table_definition_dwid = temp_table_definition.dwid
            AND edw_field_definition.field_name = 'lender_user_pid'
)
SELECT 'Finished updating edw_field_definition';

--update table_output_field
WITH temp_table_output_step AS (
    SELECT *
    FROM mdi.table_output_step
    WHERE table_output_step.target_schema = 'star_loan'
      AND table_output_step.target_table = 'loan_lender_user_access'
)
   , insert_octane_username_output_field AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT temp_table_output_step.dwid, 'octane_username', 'octane_username', 8, FALSE
        FROM temp_table_output_step
)
   , insert_account_pid_output_field AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT temp_table_output_step.dwid, 'account_pid', 'account_pid', 10, FALSE
        FROM temp_table_output_step
)
   , delete_lender_user_pid_output_field AS (
    DELETE FROM mdi.table_output_field
        USING temp_table_output_step
        WHERE table_output_field.table_output_step_dwid = temp_table_output_step.dwid
            AND table_output_field.database_field_name = 'lender_user_pid'
)
SELECT 'Finished updating table_output_field';

--Trigger SP-200001 (insert into loan_lender_user_access) after SP-100090 (update history_octane.lender_user)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
VALUES ((SELECT dwid FROM mdi.process WHERE name = 'SP-100090'), (SELECT dwid FROM mdi.process WHERE name = 'SP-200001'));

--Trigger SP-200002 (delete from loan_lender_user_access) after SP-100090 (update history_octane.lender_user)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
VALUES ((SELECT dwid FROM mdi.process WHERE name = 'SP-100090'), (SELECT dwid FROM mdi.process WHERE name = 'SP-200002'));

--update SP-200001 (insert into loan_lender_user_access) table_input_step sql
UPDATE mdi.table_input_step
SET sql = 'SELECT NOW( ) AS edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , ''lu_account_pid~lu_username~dlu_lender_user_pid~d_pid~prp_pid~l_pid~data_source_dwid'' AS data_source_integration_columns
     , COALESCE( CAST( lender_user.lu_account_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
       COALESCE( CAST( lender_user.lu_username AS TEXT ), ''<NULL>'' ) || ''~'' ||
       COALESCE( CAST( deal_lender_user.dlu_lender_user_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
       COALESCE( CAST( deal.d_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
       COALESCE( CAST( proposal.prp_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
       COALESCE( CAST( loan.l_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
       ''1'' AS data_source_integration_id
     , deal_lender_user.data_source_updated_datetime AS data_source_modified_datetime
     , lender_user.lu_username AS octane_username
     , loan_fact.loan_dwid
     , lender_user.lu_account_pid AS account_pid
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
-- join to lender_user
JOIN (
    SELECT <<lender_user_partial_load_condition>> AS include_record
         , lender_user.*
    FROM history_octane.lender_user
    LEFT JOIN history_octane.lender_user history_records
              ON lender_user.lu_pid = history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
      AND lender_user.data_source_deleted_flag = FALSE
) AS lender_user
     ON lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
-- join to loan_lender_user_access to ensure no duplicate lender_user - loan pairings are inserted
LEFT JOIN star_loan.loan_lender_user_access
          ON loan_lender_user_access.octane_username = lender_user.lu_username
              AND loan_lender_user_access.account_pid = lender_user.lu_account_pid
              AND loan_lender_user_access.loan_dwid = loan_fact.loan_dwid
              AND loan_lender_user_access.data_source_dwid = 1
WHERE loan_lender_user_access.dwid IS NULL
  AND GREATEST( loan_fact.include_record, loan.include_record, proposal.include_record, deal.include_record,
                deal_lender_user.include_record, lender_user.include_record ) = TRUE;'
FROM mdi.process
WHERE process.dwid = table_input_step.process_dwid
  AND process.name = 'SP-200001';

--update SP-200002 (delete from loan_lender_user_access) table_input_step sql
UPDATE mdi.table_input_step
SET sql = 'SELECT loan_lender_user_access.dwid
     , distinct_username_deal_pairs.lu_username AS octane_username
     , loan_dim.dwid AS loan_dwid
     , distinct_username_deal_pairs.lu_account_pid AS account_pid
FROM star_loan.loan_dim
-- join to loan
JOIN (
    SELECT loan.*
    FROM history_octane.loan
    LEFT JOIN history_octane.loan history_records
              ON loan.l_pid = history_records.l_pid
                  AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
) AS loan
     ON loan.l_pid = loan_dim.loan_pid
         AND loan_dim.data_source_dwid = 1
-- join to proposal
JOIN (
    SELECT proposal.*
    FROM history_octane.proposal
    LEFT JOIN history_octane.proposal history_records
              ON proposal.prp_pid = history_records.prp_pid
                  AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_version IS NULL
      AND proposal.prp_proposal_type = ''ACTIVE''
) AS proposal
     ON proposal.prp_pid = loan.l_proposal_pid
-- join to deal
JOIN (
    SELECT deal.*
    FROM history_octane.deal
    LEFT JOIN history_octane.deal history_records
              ON deal.d_pid = history_records.d_pid
                  AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.d_pid IS NULL
) AS deal
     ON deal.d_pid = proposal.prp_deal_pid
-- join to deal_lender_user and lender_user to get unique username-deal_pid pairings
JOIN (
    /*
    Use of DISTINCT is needed because deal_lender_user is at a lower granularity than loan_lender_user_access,
    and this query needs to determine which *unique* sets of deal-username-account_pid have no active connections across
    deal_lender_user/lender_user so that they can be deleted from loan_lender_user_access.
     */
    SELECT DISTINCT deal_lender_user.dlu_deal_pid
                  , lender_user.lu_username
                  , lender_user.lu_account_pid
    FROM history_octane.deal_lender_user
    LEFT JOIN history_octane.deal_lender_user dlu_history_records
              ON deal_lender_user.dlu_pid = dlu_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < dlu_history_records.data_source_updated_datetime
        --join to ALL lender_user rows, not just most current, in order to include non-current usernames
    JOIN history_octane.lender_user
         ON lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    WHERE dlu_history_records.dlu_pid IS NULL
      AND GREATEST(<<deal_lender_user_partial_load_condition>>, <<lender_user_partial_load_condition>>) = TRUE
) AS distinct_username_deal_pairs
     ON distinct_username_deal_pairs.dlu_deal_pid = deal.d_pid
-- join again to deal_lender_user to filter to username-deal relationships that have been *completely* severed
LEFT JOIN (
    SELECT deal_lender_user.dlu_deal_pid
         , lender_user.lu_username
         , lender_user.lu_account_pid
    FROM history_octane.deal_lender_user
    LEFT JOIN history_octane.deal_lender_user dlu_history_records
              ON deal_lender_user.dlu_pid = dlu_history_records.dlu_pid
                  AND deal_lender_user.data_source_updated_datetime < dlu_history_records.data_source_updated_datetime
    JOIN history_octane.lender_user
         ON lender_user.lu_pid = deal_lender_user.dlu_lender_user_pid
    LEFT JOIN history_octane.lender_user lu_history_records
              ON lender_user.lu_pid = lu_history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < lu_history_records.data_source_updated_datetime
    WHERE dlu_history_records.dlu_pid IS NULL
      AND lu_history_records.lu_pid IS NULL
      AND deal_lender_user.data_source_deleted_flag = FALSE
) AS non_deletable_deal_lender_user
          ON distinct_username_deal_pairs.dlu_deal_pid = non_deletable_deal_lender_user.dlu_deal_pid
              AND distinct_username_deal_pairs.lu_username = non_deletable_deal_lender_user.lu_username
              AND distinct_username_deal_pairs.lu_account_pid = non_deletable_deal_lender_user.lu_account_pid
-- join to loan_lender_user_access to only try to delete rows that have already been added to the target table
JOIN star_loan.loan_lender_user_access
     ON loan_lender_user_access.loan_dwid = loan_dim.dwid
         AND loan_lender_user_access.octane_username = distinct_username_deal_pairs.lu_username
         AND loan_lender_user_access.account_pid = distinct_username_deal_pairs.lu_account_pid
         AND loan_lender_user_access.data_source_dwid = 1
WHERE non_deletable_deal_lender_user.dlu_deal_pid IS NULL;'
FROM mdi.process
WHERE process.dwid = table_input_step.process_dwid
  AND process.name = 'SP-200002';

-- replace existing delete key for SP-200002 with a multi-key that takes advantage of partitioning/indexes
DELETE
FROM mdi.delete_key
    USING mdi.delete_step, mdi.process
WHERE delete_step.dwid = delete_key.delete_step_dwid
  AND delete_step.process_dwid = process.dwid
  AND process.name = 'SP-200002';

WITH new_delete_key_data (field_name) AS (
    VALUES ('octane_username')
         , ('loan_dwid')
         , ('account_pid')
)
INSERT
INTO mdi.delete_key (delete_step_dwid, table_name_field, stream_fieldname_1, stream_fieldname_2, comparator, is_sensitive)
SELECT delete_step.dwid, new_delete_key_data.field_name, new_delete_key_data.field_name, '', '=', FALSE
FROM mdi.delete_step
JOIN mdi.process
     ON delete_step.process_dwid = process.dwid
JOIN new_delete_key_data
     ON TRUE --three-row constant values CTE defined above; process/delete step is the same for all three rows
WHERE process.name = 'SP-200002';
