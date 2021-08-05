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

--
-- EDW | Add missing tables and fields to mdi schema metadata tables, drop deprecated fields from star_loan schema
-- https://app.asana.com/0/0/1200689348642534
--

WITH new_staging_tables AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'account_id_sequence', NULL)
            , ('staging', 'staging_octane', 'deal_id_sequence', NULL)
            , ('staging', 'staging_octane', 'fault_tolerant_event_registration', NULL)
        RETURNING dwid, database_name, schema_name, table_name, primary_source_edw_table_definition_dwid
)

, new_history_tables AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        SELECT 'staging', 'history_octane', new_staging_tables.table_name, new_staging_tables.dwid
        FROM new_staging_tables
        UNION ALL
        -- manually enter cost_center as it has been removed from Octane and consequently staging_octane
        SELECT 'staging', 'history_octane', 'cost_center', NULL
        RETURNING dwid, database_name, schema_name, table_name, primary_source_edw_table_definition_dwid
)

, new_star_loan_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        SELECT 'staging', 'star_loan', 'loan_fact', NULL
        RETURNING dwid, database_name, schema_name, table_name, primary_source_edw_table_definition_dwid
)

, existing_tables_with_missing_columns AS (
    SELECT edw_table_definition.dwid
        , edw_table_definition.database_name
        , edw_table_definition.schema_name
        , edw_table_definition.table_name
        , edw_table_definition.primary_source_edw_table_definition_dwid
    FROM mdi.edw_table_definition
    WHERE (edw_table_definition.table_name = 'contractor'
        OR (edw_table_definition.schema_name = 'history_octane'
            AND edw_table_definition.table_name = 'borrower_user_deal'))
)

, all_tables_for_metadata_addition AS (
    SELECT new_staging_tables.dwid
        , new_staging_tables.database_name
        , new_staging_tables.schema_name
        , new_staging_tables.table_name
        , new_staging_tables.primary_source_edw_table_definition_dwid
    FROM new_staging_tables
    UNION ALL
    SELECT new_history_tables.dwid
        , new_history_tables.database_name
        , new_history_tables.schema_name
        , new_history_tables.table_name
        , new_history_tables.primary_source_edw_table_definition_dwid
    FROM new_history_tables
    UNION ALL
    SELECT new_star_loan_table.dwid
        , new_star_loan_table.database_name
        , new_star_loan_table.schema_name
        , new_star_loan_table.table_name
        , new_star_loan_table.primary_source_edw_table_definition_dwid
    FROM new_star_loan_table
    UNION ALL
    SELECT existing_tables_with_missing_columns.dwid
        , existing_tables_with_missing_columns.database_name
        , existing_tables_with_missing_columns.schema_name
        , existing_tables_with_missing_columns.table_name
        , existing_tables_with_missing_columns.primary_source_edw_table_definition_dwid
    FROM existing_tables_with_missing_columns
)

, new_fields_octane_metadata (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES
        -- staging_octane.contractor.ctr_has_employees
        ('staging_octane', 'contractor', 'ctr_has_employees', FALSE, NULL)
        -- staging_octane.account_id_sequence.*
        , ('staging_octane', 'account_id_sequence', 'ais_id', TRUE, NULL)
        -- staging_octane.deal_id_sequence.*
        , ('staging_octane', 'deal_id_sequence', 'dis_id', TRUE, NULL)
        -- staging_octane.fault_tolerant_event_registration.*
        , ('staging_octane', 'fault_tolerant_event_registration', 'fter_message_id', TRUE, NULL)
        , ('staging_octane', 'fault_tolerant_event_registration', 'fter_queue_name', FALSE, NULL)
        , ('staging_octane', 'fault_tolerant_event_registration', 'fter_event_type', FALSE, NULL)
        , ('staging_octane', 'fault_tolerant_event_registration', 'fter_create_datetime', FALSE, NULL)
        , ('staging_octane', 'fault_tolerant_event_registration', 'fter_processed_datetime', FALSE, NULL)
        -- history_octane.borrower_user_deal.bud_loan_key
        , ('history_octane', 'borrower_user_deal', 'bud_loan_key', FALSE, NULL)
        -- history_octane.contractor.ctr_has_employees
        , ('history_octane', 'contractor', 'ctr_has_employees', FALSE, 24)
        -- history_octane.account_id_sequence.*
        , ('history_octane', 'account_id_sequence', 'ais_id', TRUE, 0)
        , ('history_octane', 'account_id_sequence', 'data_source_updated_datetime', FALSE, 1)
        , ('history_octane', 'account_id_sequence', 'data_source_deleted_flag', FALSE, 2)
        -- history_octane.deal_id_sequence.*
        , ('history_octane', 'deal_id_sequence', 'dis_id', TRUE, 0)
        , ('history_octane', 'deal_id_sequence', 'data_source_updated_datetime', FALSE, 1)
        , ('history_octane', 'deal_id_sequence', 'data_source_deleted_flag', FALSE, 2)
        -- history_octane.fault_tolerant_event_registration.*
        , ('history_octane', 'fault_tolerant_event_registration', 'fter_message_id', TRUE, 0)
        , ('history_octane', 'fault_tolerant_event_registration', 'fter_queue_name', FALSE, 1)
        , ('history_octane', 'fault_tolerant_event_registration', 'fter_event_type', FALSE, 2)
        , ('history_octane', 'fault_tolerant_event_registration', 'fter_create_datetime', FALSE, 3)
        , ('history_octane', 'fault_tolerant_event_registration', 'fter_processed_datetime', FALSE, 4)
        , ('history_octane', 'fault_tolerant_event_registration', 'data_source_updated_datetime', FALSE, 5)
        , ('history_octane', 'fault_tolerant_event_registration', 'data_source_deleted_flag', FALSE, 6)
        -- history_octane.cost_center.*
        , ('history_octane', 'cost_center', 'cosc_pid', TRUE, NULL)
        , ('history_octane', 'cost_center', 'cosc_version', FALSE, NULL)
        , ('history_octane', 'cost_center', 'cosc_account_pid', FALSE, NULL)
        , ('history_octane', 'cost_center', 'cosc_amb_code', FALSE, NULL)
        , ('history_octane', 'cost_center', 'cosc_name', FALSE, NULL)
        , ('history_octane', 'cost_center', 'cosc_comments', FALSE, NULL)
        , ('history_octane', 'cost_center', 'cosc_active', FALSE, NULL)
        , ('history_octane', 'cost_center', 'data_source_updated_datetime', FALSE, NULL)
        , ('history_octane', 'cost_center', 'data_source_deleted_flag', FALSE, NULL)
)

, new_fields_loan_fact_metadata (schema_name, table_name, field_name, key_field_flag, data_type, reporting_label,
                                 reporting_description, reporting_hidden, reporting_key_flag) AS (
    VALUES ('star_loan', 'loan_fact', 'data_source_dwid', TRUE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'edw_created_datetime', FALSE, 'TIMESTAMPTZ', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'edw_modified_datetime', FALSE, 'TIMESTAMPTZ', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'etl_batch_id', FALSE, 'TEXT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'data_source_integration_columns', FALSE, 'TEXT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'data_source_integration_id', FALSE, 'TEXT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'data_source_modified_datetime', FALSE, 'TIMESTAMPTZ', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'loan_pid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'loan_dwid', TRUE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'loan_junk_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'product_choice_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'transaction_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'transaction_junk_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'current_loan_beneficiary_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'active_loan_funding_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b1_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b2_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b3_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b4_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b5_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'c1_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'c2_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'c3_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'c4_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'c5_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n1_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n2_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n3_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n4_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n5_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n6_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n7_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'n8_borrower_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b1_borrower_demographics_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'b1_borrower_lending_profile_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'primary_application_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'collateral_to_custodian_lender_user_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes',
           FALSE)
        , ('star_loan', 'loan_fact', 'interim_funder_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'product_terms_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'product_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'product_investor_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'hmda_purchaser_of_loan_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'apr', FALSE, 'NUMERIC(15,9)', 'APR', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'base_loan_amount', FALSE, 'NUMERIC(21,3)', 'Base Loan Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'financed_amount', FALSE, 'NUMERIC(21,3)', 'Financed Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'loan_amount', FALSE, 'NUMERIC(21,3)', 'Loan Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'ltv_ratio_percent', FALSE, 'NUMERIC(15,9)', 'LTV Ratio Percent', NULL, 'no',
           FALSE)
        , ('star_loan', 'loan_fact', 'note_rate_percent', FALSE, 'NUMERIC(15,9)', 'Note Rate Percent', NULL, 'no',
           FALSE)
        , ('star_loan', 'loan_fact', 'purchase_advice_amount', FALSE, 'NUMERIC(21,3)', 'Purchase Advice ' ||
           'Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'finance_charge_amount', FALSE, 'NUMERIC(21,3)', 'Finance Charge ' ||
           'Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'hoepa_fees_dollar_amount', FALSE, 'NUMERIC(21,3)', 'HOEPA Dollar Fees ' ||
           'Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'interest_rate_fee_change_amount', FALSE, 'NUMERIC(21,3)', 'Interest ' ||
           'Rate Fee Charge Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'principal_curtailment_amount', FALSE, 'NUMERIC(21,3)', 'Principal ' ||
           'Curtailment Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'qualifying_pi_amount', FALSE, 'NUMERIC(21,3)', 'Qualifying PI Amount',
           NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'target_cash_out_amount', FALSE, 'NUMERIC(21,3)', 'Target Cash Out ' ||
           'Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'heloc_maximum_balance_amount', FALSE, 'NUMERIC(21,3)', 'HELOC Maximum ' ||
           'Balance Amount', NULL, 'no', FALSE)
        , ('star_loan', 'loan_fact', 'agency_case_id_assigned_date_dwid', FALSE, 'BIGINT', NULL, NULL,
           'yes', FALSE)
        , ('star_loan', 'loan_fact', 'apor_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'application_signed_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'approved_with_conditions_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'beneficiary_from_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'beneficiary_through_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'collateral_sent_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'disbursement_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'early_funding_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'effective_funding_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'fha_endorsement_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'estimated_funding_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'intent_to_proceed_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'funding_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'funding_requested_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'loan_file_ship_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'mers_transfer_creation_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'pending_wire_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'rejected_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'return_confirmed_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'return_request_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'scheduled_release_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'usda_guarantee_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
        , ('star_loan', 'loan_fact', 'va_guaranty_date_dwid', FALSE, 'BIGINT', NULL, NULL, 'yes', FALSE)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT all_tables_for_metadata_addition.dwid
            , new_fields_octane_metadata.field_name
            , new_fields_octane_metadata.key_field_flag
        FROM new_fields_octane_metadata
            JOIN all_tables_for_metadata_addition ON new_fields_octane_metadata.schema_name = all_tables_for_metadata_addition.schema_name
                AND new_fields_octane_metadata.table_name = all_tables_for_metadata_addition.table_name
        WHERE new_fields_octane_metadata.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT all_tables_for_metadata_addition.dwid
            , new_fields_octane_metadata.field_name
            , new_fields_octane_metadata.key_field_flag
            , new_staging_field_definitions.dwid
        FROM new_fields_octane_metadata
            JOIN all_tables_for_metadata_addition ON new_fields_octane_metadata.schema_name = all_tables_for_metadata_addition.schema_name
                AND new_fields_octane_metadata.table_name = all_tables_for_metadata_addition.table_name
            LEFT JOIN new_staging_field_definitions ON all_tables_for_metadata_addition.primary_source_edw_table_definition_dwid =
                                                       new_staging_field_definitions.edw_table_definition_dwid
                AND new_fields_octane_metadata.field_name = new_staging_field_definitions.field_name
        WHERE new_fields_octane_metadata.schema_name = 'history_octane'
)

, new_loan_fact_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type,
                                          reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        SELECT all_tables_for_metadata_addition.dwid
            , new_fields_loan_fact_metadata.field_name
            , new_fields_loan_fact_metadata.key_field_flag
            , new_fields_loan_fact_metadata.data_type
            , new_fields_loan_fact_metadata.reporting_label
            , new_fields_loan_fact_metadata.reporting_description
            , new_fields_loan_fact_metadata.reporting_hidden::mdi.looker_yes_no
            , new_fields_loan_fact_metadata.reporting_key_flag
        FROM new_fields_loan_fact_metadata
            JOIN all_tables_for_metadata_addition ON new_fields_loan_fact_metadata.schema_name = all_tables_for_metadata_addition.schema_name
                AND new_fields_loan_fact_metadata.table_name = all_tables_for_metadata_addition.table_name
)

, new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100836', 'account_id_sequence', 'ais_id', 'SELECT staging_table.ais_id, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.account_id_sequence staging_table
LEFT JOIN history_octane.account_id_sequence history_table on staging_table.ais_id = history_table.ais_id
WHERE history_table.ais_id is NULL')
    , ('SP-100837', 'deal_id_sequence', 'dis_id', 'SELECT staging_table.dis_id, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.deal_id_sequence staging_table
         LEFT JOIN history_octane.deal_id_sequence history_table on staging_table.dis_id = history_table.dis_id
WHERE history_table.dis_id is NULL')
    , ('SP-100838', 'fault_tolerant_event_registration', 'fter_message_id', 'SELECT staging_table.fter_message_id, staging_table.fter_queue_name, staging_table.fter_event_type,
       staging_table.fter_create_datetime, staging_table.fter_processed_datetime, FALSE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM staging_octane.fault_tolerant_event_registration staging_table
         LEFT JOIN history_octane.fault_tolerant_event_registration history_table on staging_table.fter_message_id = history_table.fter_message_id
WHERE history_table.fter_message_id is NULL')
)

, new_process AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
            , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)

, new_table_input_step AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row,
                                      replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
        SELECT new_process.dwid
             , 0
             , new_process_variables.sql
             , 0
             , 'N'
             , 'N'
             , 'N'
             , 'N'
             , 'Staging DB Connection'
        FROM new_process
            JOIN new_process_variables ON new_process.name = new_process_variables.name
)

, new_table_output_step AS (
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                       auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                       return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                       specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT new_process.dwid
             , 'history_octane'
             , new_process_variables.target_table
             , 1000
             , NULL
             , NULL
             , NULL
             , NULL
             , 'N'
             , NULL
             , 'N'
             , 'Staging DB Connection'
             , 'N'
             , 'Y'
             , 'N'
             , 'N'
        FROM new_process
            JOIN new_process_variables ON new_process.name = new_process_variables.name
        RETURNING dwid, target_schema, target_table
)

, new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name,
                                        field_order, is_sensitive)
        SELECT new_table_output_step.dwid
            , new_fields_octane_metadata.field_name
            , new_fields_octane_metadata.field_name
            , new_fields_octane_metadata.field_order
            , FALSE
        FROM new_table_output_step
            JOIN new_fields_octane_metadata ON new_table_output_step.target_schema = new_fields_octane_metadata.schema_name
                AND new_table_output_step.target_table = new_fields_octane_metadata.table_name
                AND new_fields_octane_metadata.schema_name = 'history_octane'
)

, new_json_output_field AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_process.dwid, new_process_variables.json_output_field
        FROM new_process
            JOIN new_process_variables ON new_process.name = new_process_variables.name
)

, new_state_machine_definition AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_process.dwid, new_process.name, new_process.description
        FROM new_process
)

-- CTE for separately adding the missing contractor.ctr_has_employees field to the relevant MDI configuration
, new_contractor_table_output_field AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name,
                                        field_order, is_sensitive)
        SELECT table_output_step.dwid
            , new_fields_octane_metadata.field_name
            , new_fields_octane_metadata.field_name
            , new_fields_octane_metadata.field_order
            , FALSE
        FROM mdi.table_output_step
            JOIN new_fields_octane_metadata ON table_output_step.target_schema = new_fields_octane_metadata.schema_name
                AND new_fields_octane_metadata.field_name = 'ctr_has_employees'
        WHERE table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = 'contractor'
)

UPDATE mdi.table_input_step
    SET sql = '--finding records to insert into history_octane.contractor
SELECT staging_table.ctr_pid
, staging_table.ctr_version
, staging_table.ctr_account_pid
, staging_table.ctr_contractor_company_name
, staging_table.ctr_max_construction_credit_amount
, staging_table.ctr_taxpayer_identifier_type
, staging_table.ctr_first_name
, staging_table.ctr_last_name
, staging_table.ctr_work_phone
, staging_table.ctr_work_phone_extension
, staging_table.ctr_mobile_phone
, staging_table.ctr_fax
, staging_table.ctr_email
, staging_table.ctr_address_street1
, staging_table.ctr_address_street2
, staging_table.ctr_address_city
, staging_table.ctr_address_state
, staging_table.ctr_address_postal_code
, staging_table.ctr_address_country
, staging_table.ctr_notes
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
, staging_table.ctr_has_employees
FROM staging_octane.contractor staging_table
LEFT JOIN history_octane.contractor history_table on staging_table.ctr_pid = history_table.ctr_pid and staging_table.ctr_version = history_table.ctr_version
WHERE history_table.ctr_pid is NULL
UNION ALL
SELECT history_table.ctr_pid
, history_table.ctr_version+1
, history_table.ctr_account_pid
, history_table.ctr_contractor_company_name
, history_table.ctr_max_construction_credit_amount
, history_table.ctr_taxpayer_identifier_type
, history_table.ctr_first_name
, history_table.ctr_last_name
, history_table.ctr_work_phone
, history_table.ctr_work_phone_extension
, history_table.ctr_mobile_phone
, history_table.ctr_fax
, history_table.ctr_email
, history_table.ctr_address_street1
, history_table.ctr_address_street2
, history_table.ctr_address_city
, history_table.ctr_address_state
, history_table.ctr_address_postal_code
, history_table.ctr_address_country
, history_table.ctr_notes
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
, history_table.ctr_has_employees
FROM history_octane.contractor history_table
LEFT JOIN staging_octane.contractor staging_table on staging_table.ctr_pid = history_table.ctr_pid
WHERE staging_table.ctr_pid is NULL
    AND not exists (select 1 from history_octane.contractor deleted_records where deleted_records.ctr_pid = history_table.ctr_pid and deleted_records.data_source_deleted_flag = True)'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
                AND table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'contractor'
        );

/*
Adding records to edw_field_definition for history_octane data_source_updated_datetime, data_source_deleted_flag

One of the tables missing these metadata fields -- fre_ctp_closing_type -- was removed from Octane (and no longer has
an associated ETL), so we're unable to capture it in the first query that uses MDI configuration data to return the
tables without the metadata fields.
*/

INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
    SELECT edw_table_definition.dwid, table_output_field.database_field_name, FALSE
    FROM mdi.table_output_step
        JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
            AND table_output_field.database_field_name IN ('data_source_updated_datetime', 'data_source_deleted_flag')
        JOIN mdi.edw_table_definition ON table_output_step.target_schema = edw_table_definition.schema_name
            AND table_output_step.target_table = edw_table_definition.table_name
        LEFT JOIN (
            SELECT edw_table_definition.schema_name
                , edw_table_definition.table_name
                , edw_field_definition.field_name
            FROM mdi.edw_table_definition
                JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
            WHERE edw_table_definition.schema_name = 'history_octane'
        ) AS table_definitions_for_null_join ON table_output_step.target_schema = table_definitions_for_null_join.schema_name
            AND table_output_step.target_table = table_definitions_for_null_join.table_name
            AND table_output_field.database_field_name = table_definitions_for_null_join.field_name
    WHERE table_definitions_for_null_join.field_name IS NULL
UNION ALL
    SELECT edw_table_definition.dwid, 'data_source_updated_datetime', FALSE
    FROM mdi.edw_table_definition
    WHERE edw_table_definition.schema_name = 'history_octane'
        AND edw_table_definition.table_name = 'fre_ctp_closing_type'
UNION ALL
    SELECT edw_table_definition.dwid, 'data_source_deleted_flag', FALSE
    FROM mdi.edw_table_definition
    WHERE edw_table_definition.schema_name = 'history_octane'
      AND edw_table_definition.table_name = 'fre_ctp_closing_type';
