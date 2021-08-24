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
         , ('SP-100838', 'fault_tolerant_event_registration', 'fter_message_id', '--finding records to insert into history_octane.fault_tolerant_event_registration
SELECT staging_table.fter_message_id
, staging_table.fter_queue_name
, staging_table.fter_event_type
, staging_table.fter_create_datetime
, staging_table.fter_processed_datetime
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.fault_tolerant_event_registration staging_table
LEFT JOIN history_octane.fault_tolerant_event_registration history_table on staging_table.fter_message_id = history_table.fter_message_id
WHERE history_table.fter_message_id is NULL
UNION ALL
SELECT history_table.fter_message_id
, history_table.fter_queue_name
, history_table.fter_event_type
, history_table.fter_create_datetime
, history_table.fter_processed_datetime
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.fault_tolerant_event_registration history_table
LEFT JOIN staging_octane.fault_tolerant_event_registration staging_table on staging_table.fter_message_id = history_table.fter_message_id
WHERE staging_table.fter_message_id is NULL
    AND not exists (select 1 from history_octane.fault_tolerant_event_registration deleted_records where deleted_records.fter_message_id = history_table.fter_message_id and deleted_records.data_source_deleted_flag = True)')
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


--
-- EDW | Update calculated fields within loan_fact ETL joins to match source calculations
-- https://app.asana.com/0/0/1200847894143590
--

UPDATE mdi.table_input_step
    SET sql = 'SELECT
    COALESCE(loan_fact.edw_created_datetime, NOW()) AS edw_created_datetime
     , NOW() AS edw_modified_datetime
     , ''loan_pid~data_source_dwid'' AS data_source_integration_columns
     , loan_dim.loan_pid || ''~1'' AS data_source_integration_id
     , loan_dim.edw_modified_datetime AS data_source_modified_datetime
     , loan_dim.loan_pid AS loan_pid
     , loan_dim.dwid AS loan_dwid
     , COALESCE(loan_junk_dim.dwid, 0) AS loan_junk_dwid
     , COALESCE(product_choice_dim.dwid, 0) AS product_choice_dwid
     , COALESCE(transaction_dim.dwid, 0) AS transaction_dwid
     , COALESCE(transaction_junk_dim.dwid, 0) AS transaction_junk_dwid
     , COALESCE(loan_beneficiary_dim.dwid, 0) AS current_loan_beneficiary_dwid
     , COALESCE(loan_funding_dim.dwid, 0) AS active_loan_funding_dwid
     , COALESCE(borrower_b1_dim.dwid, 0) AS b1_borrower_dwid
     , COALESCE(borrower_b2_dim.dwid, 0) AS b2_borrower_dwid
     , COALESCE(borrower_b3_dim.dwid, 0) AS b3_borrower_dwid
     , COALESCE(borrower_b4_dim.dwid, 0) AS b4_borrower_dwid
     , COALESCE(borrower_b5_dim.dwid, 0) AS b5_borrower_dwid
     , COALESCE(borrower_c1_dim.dwid, 0) AS c1_borrower_dwid
     , COALESCE(borrower_c2_dim.dwid, 0) AS c2_borrower_dwid
     , COALESCE(borrower_c3_dim.dwid, 0) AS c3_borrower_dwid
     , COALESCE(borrower_c4_dim.dwid, 0) AS c4_borrower_dwid
     , COALESCE(borrower_c5_dim.dwid, 0) AS c5_borrower_dwid
     , COALESCE(borrower_n1_dim.dwid, 0) AS n1_borrower_dwid
     , COALESCE(borrower_n2_dim.dwid, 0) AS n2_borrower_dwid
     , COALESCE(borrower_n3_dim.dwid, 0) AS n3_borrower_dwid
     , COALESCE(borrower_n4_dim.dwid, 0) AS n4_borrower_dwid
     , COALESCE(borrower_n5_dim.dwid, 0) AS n5_borrower_dwid
     , COALESCE(borrower_n6_dim.dwid, 0) AS n6_borrower_dwid
     , COALESCE(borrower_n7_dim.dwid, 0) AS n7_borrower_dwid
     , COALESCE(borrower_n8_dim.dwid, 0) AS n8_borrower_dwid
     , COALESCE(borrower_demographics_dim.dwid, 0) AS b1_borrower_demographics_dwid
     , COALESCE(borrower_lending_profile_dim.dwid, 0) AS b1_borrower_lending_profile_dwid
     , COALESCE(application_dim.dwid, 0) AS primary_application_dwid
     , COALESCE(lender_user_dim.dwid, 0) AS collateral_to_custodian_lender_user_dwid
     , COALESCE(interim_funder_dim.dwid, 0) AS interim_funder_dwid
     , COALESCE(product_terms_dim.dwid, 0) AS product_terms_dwid
     , COALESCE(product_dim.dwid, 0) AS product_dwid
     , COALESCE(investor_dim.dwid, 0) AS product_investor_dwid
     , COALESCE(hmda_purchaser_of_loan_dim.dwid, 0) AS hmda_purchaser_of_loan_dwid
     , loan.l_apr AS apr
     , loan.l_base_loan_amount AS base_loan_amount
     , loan.l_financed_amount AS financed_amount
     , loan.l_loan_amount AS loan_amount
     , loan.l_ltv_ratio_percent AS ltv_ratio_percent
     , loan.l_note_rate_percent AS note_rate_percent
     , current_loan_beneficiary.lb_purchase_advice_amount AS purchase_advice_amount
     , loan.l_finance_charge_amount AS finance_charge_amount
     , loan.l_hoepa_fees_dollar_amount AS hoepa_fees_dollar_amount
     , loan.l_interest_rate_fee_change_amount AS interest_rate_fee_change_amount
     , loan.l_principal_curtailment_amount AS principal_curtailment_amount
     , loan.l_qualifying_pi_amount AS qualifying_pi_amount
     , loan.l_target_cash_out_amount AS target_cash_out_amount
     , loan.l_heloc_maximum_balance_amount AS heloc_maximum_balance_amount
     , COALESCE(agency_case_id_assigned_date_dim.dwid, 0) AS agency_case_id_assigned_date_dwid
     , COALESCE(apor_date_dim.dwid, 0) AS apor_date_dwid
     , COALESCE(application_signed_date_dim.dwid,0) AS application_signed_date_dwid
     , COALESCE(approved_with_conditions_date_dim.dwid,0) AS approved_with_conditions_date_dwid
     , COALESCE(beneficiary_from_date_dim.dwid,0) AS beneficiary_from_date_dwid
     , COALESCE(beneficiary_through_date_dim.dwid,0) AS beneficiary_through_date_dwid
     , COALESCE(collateral_sent_date_dim.dwid, 0) AS collateral_sent_date_dwid
     , COALESCE(disbursement_date_dim.dwid, 0) AS disbursement_date_dwid
     , COALESCE(early_funding_date_dim.dwid, 0) AS early_funding_date_dwid
     , COALESCE(effective_funding_date_dim.dwid,0) AS effective_funding_date_dwid
     , COALESCE(fha_endorsement_date_dim.dwid,0) AS fha_endorsement_date_dwid
     , COALESCE(estimated_funding_date_dim.dwid, 0) AS estimated_funding_date_dwid
     , COALESCE(intent_to_proceed_date_dim.dwid, 0) AS intent_to_proceed_date_dwid
     , COALESCE(funding_date_dim.dwid, 0) AS funding_date_dwid
     , COALESCE(funding_requested_date_dim.dwid, 0) AS funding_requested_date_dwid
     , COALESCE(loan_file_ship_date_dim.dwid, 0) AS loan_file_ship_date_dwid
     , COALESCE(mers_transfer_creation_date_dim.dwid, 0) AS mers_transfer_creation_date_dwid
     , COALESCE(pending_wire_date_dim.dwid, 0) AS pending_wire_date_dwid
     , COALESCE(rejected_date_dim.dwid, 0) AS rejected_date_dwid
     , COALESCE(return_confirmed_date_dim.dwid, 0) AS return_confirmed_date_dwid
     , COALESCE(return_request_date_dim.dwid, 0) AS return_request_date_dwid
     , COALESCE(scheduled_release_date_dim.dwid, 0) AS scheduled_release_date_dwid
     , COALESCE(usda_guarantee_date_dim.dwid, 0) AS usda_guarantee_date_dwid
     , COALESCE(va_guaranty_date_dim.dwid, 0) AS va_guaranty_date_dwid
FROM
    -- history_octane deal
    (
    SELECT deal.*
        , <<deal_partial_load_condition>> AS include_record
    FROM history_octane.deal
        LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
            AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE deal.data_source_deleted_flag IS FALSE
            AND deal.d_test_loan IS FALSE
            AND history_records.d_pid IS NULL) AS deal
    -- history_octane proposal
    JOIN (
        SELECT proposal.*
            , <<proposal_partial_load_condition>> AS include_record
        FROM history_octane.proposal
            LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
                AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE proposal.data_source_deleted_flag IS FALSE
            AND history_records.prp_pid IS NULL) AS proposal ON deal.d_active_proposal_pid = proposal.prp_pid
    -- history_octane (primary) application
    JOIN (
        SELECT application.*
            , <<application_partial_load_condition>> AS include_record
        FROM history_octane.application
            LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE application.data_source_deleted_flag IS FALSE
            AND history_records.apl_pid IS NULL) AS primary_application ON proposal.prp_pid = primary_application.apl_proposal_pid
            AND primary_application.apl_primary_application IS TRUE
    -- history_octane loan
    JOIN (
        SELECT loan.*
            , <<loan_partial_load_condition>> AS include_record
        FROM history_octane.loan
            LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
                AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE loan.data_source_deleted_flag IS FALSE
            AND history_records.l_pid IS NULL) AS loan ON proposal.prp_pid = loan.l_proposal_pid
    -- history_octane deal_key_roles
    JOIN (
        SELECT deal_key_roles.*
            , <<deal_key_roles_partial_load_condition>> AS include_record
        FROM history_octane.deal_key_roles
            LEFT JOIN history_octane.deal_key_roles AS history_records ON deal_key_roles.dkrs_pid = history_records.dkrs_pid
                AND deal_key_roles.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE deal_key_roles.data_source_deleted_flag IS FALSE
            AND history_records.dkrs_pid IS NULL) AS deal_key_roles ON deal.d_pid = deal_key_roles.dkrs_deal_pid
    -- history_octane.borrower B1
    JOIN (
        SELECT * FROM (
            SELECT borrower.*
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_b1 ON proposal.prp_pid = borrower_b1.apl_proposal_pid
        AND borrower_b1.b_borrower_tiny_id_type = ''B1''
    -- history_octane.borrower B2
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_b2 ON proposal.prp_pid = borrower_b2.apl_proposal_pid
        AND borrower_b2.b_borrower_tiny_id_type = ''B2''
    -- history_octane.borrower B3
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_b3 ON proposal.prp_pid = borrower_b3.apl_proposal_pid
        AND borrower_b2.b_borrower_tiny_id_type = ''B3''
    -- history_octane.borrower B4
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_b4 ON proposal.prp_pid = borrower_b4.apl_proposal_pid
        AND borrower_b4.b_borrower_tiny_id_type = ''B4''
    -- history_octane.borrower B5
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_b5 ON proposal.prp_pid = borrower_b5.apl_proposal_pid
        AND borrower_b5.b_borrower_tiny_id_type = ''B5''
    -- history_octane.borrower C1
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_c1 ON proposal.prp_pid = borrower_c1.apl_proposal_pid
        AND borrower_c1.b_borrower_tiny_id_type = ''C1''
    -- history_octane.borrower C2
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_c2 ON proposal.prp_pid = borrower_c2.apl_proposal_pid
        AND borrower_c2.b_borrower_tiny_id_type = ''C2''
    -- history_octane.borrower C3
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_c3 ON proposal.prp_pid = borrower_c3.apl_proposal_pid
        AND borrower_c3.b_borrower_tiny_id_type = ''C3''
    -- history_octane.borrower C4
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_c4 ON proposal.prp_pid = borrower_c4.apl_proposal_pid
        AND borrower_c4.b_borrower_tiny_id_type = ''C4''
    -- history_octane.borrower C5
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_c5 ON proposal.prp_pid = borrower_c5.apl_proposal_pid
        AND borrower_c5.b_borrower_tiny_id_type = ''C5''
    -- history_octane.borrower N1
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n1 ON proposal.prp_pid = borrower_n1.apl_proposal_pid
        AND borrower_n1.b_borrower_tiny_id_type = ''N1''
    -- history_octane.borrower N2
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n2 ON proposal.prp_pid = borrower_n2.apl_proposal_pid
        AND borrower_n2.b_borrower_tiny_id_type = ''N2''
    -- history_octane.borrower N3
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n3 ON proposal.prp_pid = borrower_n3.apl_proposal_pid
        AND borrower_n3.b_borrower_tiny_id_type = ''N3''
    -- history_octane.borrower N4
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n4 ON proposal.prp_pid = borrower_n4.apl_proposal_pid
        AND borrower_n4.b_borrower_tiny_id_type = ''N4''
    -- history_octane.borrower N5
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n5 ON proposal.prp_pid = borrower_n5.apl_proposal_pid
        AND borrower_n5.b_borrower_tiny_id_type = ''N5''
    -- history_octane.borrower N6
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n6 ON proposal.prp_pid = borrower_n6.apl_proposal_pid
        AND borrower_n6.b_borrower_tiny_id_type = ''N6''
    -- history_octane.borrower N7
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n7 ON proposal.prp_pid = borrower_n7.apl_proposal_pid
        AND borrower_n7.b_borrower_tiny_id_type = ''N7''
    -- history_octane.borrower N8
    LEFT JOIN (
        SELECT * FROM (
            SELECT borrower.b_pid
                , borrower.b_application_pid
                , borrower.b_borrower_tiny_id_type
                , <<borrower_partial_load_condition>> AS include_record
            FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
                    AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE borrower.data_source_deleted_flag IS FALSE
                AND history_records.b_pid IS NULL
        ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                    , application.apl_pid
                FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                    AND history_records.apl_pid IS NULL
            ) AS application ON borrower.b_application_pid = application.apl_pid
    ) AS borrower_n8 ON proposal.prp_pid = borrower_n8.apl_proposal_pid
        AND borrower_n8.b_borrower_tiny_id_type = ''N8''
    -- history_octane.loan_beneficiary
    LEFT JOIN (
        SELECT loan_beneficiary.*
            , <<loan_beneficiary_partial_load_condition>> AS include_record
        FROM history_octane.loan_beneficiary
            LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid =
                                                                            history_records.lb_pid
                AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
            AND history_records.lb_pid IS NULL
    ) AS current_loan_beneficiary ON loan.l_pid = current_loan_beneficiary.lb_loan_pid
        AND current_loan_beneficiary.lb_current IS TRUE
    -- history_octane.loan_funding
    LEFT JOIN (
        SELECT loan_funding.*
            , <<loan_funding_partial_load_condition>> AS include_record
        FROM history_octane.loan_funding
            LEFT JOIN history_octane.loan_funding AS history_records ON loan_funding.lf_pid = history_records.lf_pid
                AND loan_funding.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE loan_funding.data_source_deleted_flag IS FALSE
            AND history_records.lf_pid IS NULL
    ) AS active_loan_funding ON loan.l_pid = active_loan_funding.lf_loan_pid
        AND active_loan_funding.lf_return_confirmed_date IS NULL
    -- history_octane.interim_funder
    LEFT JOIN (
        SELECT interim_funder.*
            , <<interim_funder_partial_load_condition>> AS include_record
        FROM history_octane.interim_funder
            LEFT JOIN history_octane.interim_funder AS history_records ON interim_funder.if_pid = history_records.if_pid
                AND interim_funder.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE interim_funder.data_source_deleted_flag IS FALSE
            AND history_records.if_pid IS NULL
    ) AS interim_funder ON active_loan_funding.lf_interim_funder_pid = interim_funder.if_pid
    -- history_octane.product_terms
    LEFT JOIN (
        SELECT product_terms.*
            , <<product_terms_partial_load_condition>> AS include_record
        FROM history_octane.product_terms
            LEFT JOIN history_octane.product_terms AS history_records ON product_terms.pt_pid = history_records.pt_pid
                AND product_terms.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE product_terms.data_source_deleted_flag IS FALSE
            AND history_records.pt_pid IS NULL
    ) AS product_terms ON loan.l_product_terms_pid = product_terms.pt_pid
    -- history_octane.product
    LEFT JOIN (
        SELECT product.*
            , <<product_partial_load_condition>> AS include_record
        FROM history_octane.product
            LEFT JOIN history_octane.product AS history_records ON product.p_pid = history_records.p_pid
                AND product.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE product.data_source_deleted_flag IS FALSE
            AND history_records.p_pid IS NULL
    ) AS product ON product_terms.pt_product_pid = product.p_pid
    -- history_octane.investor
    LEFT JOIN (
        SELECT investor.*
             , <<investor_partial_load_condition>> AS include_record
        FROM history_octane.investor
            LEFT JOIN history_octane.investor AS history_records ON investor.i_pid = history_records.i_pid
                AND investor.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE investor.data_source_deleted_flag IS FALSE
            AND history_records.i_pid IS NULL
    ) AS product_investor ON product.p_investor_pid = product_investor.i_pid
    -- history_octane.hmda_purchaser_of_loan_2017_type
    LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type ON loan.l_hmda_purchaser_of_loan_2017_type =
                                                              hmda_purchaser_of_loan_2017_type.code
        AND hmda_purchaser_of_loan_2017_type.data_source_deleted_flag IS FALSE
    -- history_octane.hmda_purchaser_of_loan_2018_type
    LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type ON loan.l_hmda_purchaser_of_loan_2018_type =
                                                              hmda_purchaser_of_loan_2018_type.code
        AND hmda_purchaser_of_loan_2018_type.data_source_deleted_flag IS FALSE
    -- star_loan.loan_dim
    JOIN (
        SELECT loan_dim.*
            , <<loan_dim_partial_load_condition>> AS include_record
        FROM star_loan.loan_dim
    ) AS loan_dim ON loan.l_pid = loan_dim.loan_pid
        AND loan_dim.data_source_dwid = 1
    -- star_loan.loan_fact
    LEFT JOIN star_loan.loan_fact ON loan_dim.dwid = loan_fact.loan_dwid
        AND loan_fact.data_source_dwid = 1
    -- star_loan.application_dim
    LEFT JOIN (
        SELECT application_dim.*
            , <<application_dim_partial_load_condition>> AS include_record
        FROM star_loan.application_dim
    ) AS application_dim ON primary_application.apl_pid = application_dim.application_pid
        AND application_dim.data_source_dwid = 1
    -- star_loan.loan_junk_dim
    LEFT JOIN star_loan.loan_junk_dim ON loan.l_buydown_contributor_type = loan_junk_dim.buydown_contributor_code
        AND loan.l_fha_program_code_type = loan_junk_dim.fha_program_code
        AND loan.l_hmda_hoepa_status_type = loan_junk_dim.hmda_hoepa_status_code
        AND loan.l_durp_eligibility_opt_out = loan_junk_dim.durp_eligibility_opt_out_flag
        AND loan.l_fha_principal_write_down = loan_junk_dim.fha_principal_write_down_flag
        AND loan.l_hpml = loan_junk_dim.hpml_flag
        AND loan.l_lender_concession_candidate = loan_junk_dim.lender_concession_candidate_flag
        AND proposal.prp_mi_required = loan_junk_dim.mi_required_flag
        AND (CASE WHEN (loan.l_lien_priority_type IS NULL OR proposal.prp_structure_type IS NULL) THEN NULL
              WHEN (loan.l_lien_priority_type = ''FIRST'' OR proposal.prp_structure_type = ''STANDALONE_2ND'') THEN FALSE
            ELSE TRUE END) = loan_junk_dim.piggyback_flag
        AND loan.l_qm_eligible = loan_junk_dim.qm_eligible_flag
        AND loan.l_qualified_mortgage = loan_junk_dim.qualified_mortgage_flag
        AND loan.l_secondary_clear_to_commit = loan_junk_dim.secondary_clear_to_commit_flag
        AND loan.l_student_loan_cash_out_refinance = loan_junk_dim.student_loan_cash_out_refinance_flag
        AND loan.l_lien_priority_type = loan_junk_dim.lien_priority_code
        AND loan.l_lqa_purchase_eligibility_type = loan_junk_dim.lqa_purchase_eligibility_code
        AND loan.l_qualified_mortgage_status_type = loan_junk_dim.qualified_mortgage_status_code
        AND loan.l_qualifying_rate_type = loan_junk_dim.qualifying_rate_code
        AND loan.l_texas_equity_auto = loan_junk_dim.texas_equity_auto_code
        AND loan.l_texas_equity = loan_junk_dim.texas_equity_code
        AND loan_junk_dim.data_source_dwid = 1
        -- star_loan.product_choice_dim
    LEFT JOIN star_loan.product_choice_dim ON loan.l_aus_type = product_choice_dim.aus_code
        AND loan.l_buydown_schedule_type = product_choice_dim.buydown_schedule_code
        AND loan.l_interest_only_type = product_choice_dim.interest_only_code
        AND loan.l_mortgage_type = product_choice_dim.mortgage_type_code
        AND loan.l_prepay_penalty_schedule_type = product_choice_dim.prepay_penatly_schedule_code
        AND product_choice_dim.data_source_dwid = 1
        -- star_loan.transaction_junk_dim
    LEFT JOIN star_loan.transaction_junk_dim ON (CASE WHEN proposal.prp_structure_type = ''COMBO'' THEN TRUE ELSE FALSE
        END) = transaction_junk_dim.piggyback_flag
        AND proposal.prp_mi_required = transaction_junk_dim.mi_required_flag
        AND deal.d_test_loan = transaction_junk_dim.is_test_loan_flag
        AND proposal.prp_structure_type = transaction_junk_dim.structure_code
        AND proposal.prp_loan_purpose_type = transaction_junk_dim.loan_purpose_code
        AND transaction_junk_dim.data_source_dwid = 1
    -- star_loan.transaction_dim
    LEFT JOIN (
        SELECT transaction_dim.*
            , <<transaction_dim_partial_load_condition>> AS include_record
        FROM star_loan.transaction_dim
    ) AS transaction_dim ON deal.d_pid = transaction_dim.deal_pid
        AND deal.d_active_proposal_pid = transaction_dim.active_proposal_pid
        AND transaction_dim.data_source_dwid = 1
    -- star_loan.loan_beneficiary_dim
    LEFT JOIN (
        SELECT loan_beneficiary_dim.*
            , <<loan_beneficiary_dim_partial_load_condition>> AS include_record
        FROM star_loan.loan_beneficiary_dim
    ) AS loan_beneficiary_dim ON current_loan_beneficiary.lb_pid = loan_beneficiary_dim.loan_beneficiary_pid
        AND loan_beneficiary_dim.data_source_dwid = 1
    -- star_loan.loan_funding_dim
    LEFT JOIN (
        SELECT loan_funding_dim.*
            , <<loan_funding_dim_partial_load_condition>> AS include_record
        FROM star_loan.loan_funding_dim
    ) AS loan_funding_dim ON active_loan_funding.lf_pid = loan_funding_dim.loan_funding_pid
        AND loan_funding_dim.data_source_dwid = 1
    -- star_loan.borrower B1
    LEFT JOIN (
        SELECT borrower_dim.*
            , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_b1_dim ON borrower_b1.b_pid = borrower_b1_dim.borrower_pid
        AND borrower_b1_dim.data_source_dwid = 1
    -- star_loan.borrower B2
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_b2_dim ON borrower_b2.b_pid = borrower_b2_dim.borrower_pid
        AND borrower_b2_dim.data_source_dwid = 1
    -- star_loan.borrower B3
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_b3_dim ON borrower_b3.b_pid = borrower_b3_dim.borrower_pid
        AND borrower_b3_dim.data_source_dwid = 1
    -- star_loan.borrower B4
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_b4_dim ON borrower_b4.b_pid = borrower_b4_dim.borrower_pid
        AND borrower_b4_dim.data_source_dwid = 1
    -- star_loan.borrower B5
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_b5_dim ON borrower_b5.b_pid = borrower_b5_dim.borrower_pid
        AND borrower_b5_dim.data_source_dwid = 1
    -- star_loan.borrower C1
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_c1_dim ON borrower_c1.b_pid = borrower_c1_dim.borrower_pid
        AND borrower_c1_dim.data_source_dwid = 1
    -- star_loan.borrower C2
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_c2_dim ON borrower_c2.b_pid = borrower_c2_dim.borrower_pid
        AND borrower_c2_dim.data_source_dwid = 1
    -- star_loan.borrower C3
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_c3_dim ON borrower_c3.b_pid = borrower_c3_dim.borrower_pid
        AND borrower_c3_dim.data_source_dwid = 1
    -- star_loan.borrower C4
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_c4_dim ON borrower_c4.b_pid = borrower_c4_dim.borrower_pid
        AND borrower_c4_dim.data_source_dwid = 1
    -- star_loan.borrower C5
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_c5_dim ON borrower_c5.b_pid = borrower_c5_dim.borrower_pid
        AND borrower_c5_dim.data_source_dwid = 1
    -- star_loan.borrower N1
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n1_dim ON borrower_n1.b_pid = borrower_n1_dim.borrower_pid
        AND borrower_n1_dim.data_source_dwid = 1
    -- star_loan.borrower N2
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n2_dim ON borrower_n2.b_pid = borrower_n2_dim.borrower_pid
        AND borrower_n2_dim.data_source_dwid = 1
    -- star_loan.borrower N3
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n3_dim ON borrower_n3.b_pid = borrower_n3_dim.borrower_pid
        AND borrower_n3_dim.data_source_dwid = 1
    -- star_loan.borrower N4
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n4_dim ON borrower_n4.b_pid = borrower_n4_dim.borrower_pid
        AND borrower_n4_dim.data_source_dwid = 1
    -- star_loan.borrower N5
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n5_dim ON borrower_n5.b_pid = borrower_n5_dim.borrower_pid
        AND borrower_n5_dim.data_source_dwid = 1
    -- star_loan.borrower N6
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n6_dim ON borrower_n6.b_pid = borrower_n6_dim.borrower_pid
        AND borrower_n6_dim.data_source_dwid = 1
    -- star_loan.borrower N7
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n7_dim ON borrower_n7.b_pid = borrower_n7_dim.borrower_pid
        AND borrower_n7_dim.data_source_dwid = 1
    -- star_loan.borrower N8
    LEFT JOIN (
        SELECT borrower_dim.*
             , <<borrower_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_dim
    ) AS borrower_n8_dim ON borrower_n8.b_pid = borrower_n8_dim.borrower_pid
        AND borrower_n8_dim.data_source_dwid = 1
    -- star_loan.borrower_demographics_dim
    LEFT JOIN star_loan.borrower_demographics_dim ON borrower_b1.b_ethnicity_collected_visual_or_surname =
                                                  borrower_demographics_dim.ethnicity_collected_visual_or_surname_code
        AND borrower_b1.b_ethnicity_refused = borrower_demographics_dim.ethnicity_refused_code
        AND (CASE WHEN borrower_b1.b_ethnicity_other_hispanic_or_latino_description <> ''''
            AND borrower_b1.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_demographics_dim.ethnicity_other_hispanic_or_latino_description_flag
        AND (CASE WHEN borrower_b1.b_other_race_national_origin_description <> ''''
            AND borrower_b1.b_other_race_national_origin_description IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_demographics_dim.other_race_national_origin_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_american_indian_or_alaska_native_description <> ''''
            AND borrower_b1.b_race_other_american_indian_or_alaska_native_description IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_demographics_dim.race_other_american_indian_or_alaska_native_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_asian_description <> ''''
            AND borrower_b1.b_race_other_asian_description IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_demographics_dim.race_other_asian_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_pacific_islander_description <> ''''
            AND borrower_b1.b_race_other_pacific_islander_description IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_demographics_dim.race_other_pacific_islander_description_flag
        AND borrower_b1.b_ethnicity_cuban = borrower_demographics_dim.ethnicity_cuban_flag
        AND borrower_b1.b_ethnicity_hispanic_or_latino = borrower_demographics_dim.ethnicity_hispanic_or_latino_flag
        AND borrower_b1.b_ethnicity_mexican = borrower_demographics_dim.ethnicity_mexican_flag
        AND borrower_b1.b_ethnicity_not_hispanic_or_latino = borrower_demographics_dim.ethnicity_not_hispanic_or_latino_flag
        AND borrower_b1.b_ethnicity_not_obtainable = borrower_demographics_dim.ethnicity_not_obtainable_flag
        AND borrower_b1.b_ethnicity_other_hispanic_or_latino = borrower_demographics_dim.ethnicity_other_hispanic_or_latino_flag
        AND borrower_b1.b_ethnicity_puerto_rican = borrower_demographics_dim.ethnicity_puerto_rican_flag
        AND borrower_b1.b_race_american_indian_or_alaska_native = borrower_demographics_dim.race_american_indian_or_alaska_native_flag
        AND borrower_b1.b_race_asian = borrower_demographics_dim.race_asian_flag
        AND borrower_b1.b_race_asian_indian = borrower_demographics_dim.race_asian_indian_flag
        AND borrower_b1.b_race_black_or_african_american = borrower_demographics_dim.race_black_or_african_american_flag
        AND borrower_b1.b_race_chinese = borrower_demographics_dim.race_chinese_flag
        AND borrower_b1.b_race_filipino = borrower_demographics_dim.race_filipino_flag
        AND borrower_b1.b_race_guamanian_or_chamorro = borrower_demographics_dim.race_guamanian_or_chamorro_flag
        AND borrower_b1.b_race_information_not_provided = borrower_demographics_dim.race_information_not_provided_flag
        AND borrower_b1.b_race_japanese = borrower_demographics_dim.race_japanese_flag
        AND borrower_b1.b_race_korean = borrower_demographics_dim.race_korean_flag
        AND borrower_b1.b_race_national_origin_refusal = borrower_demographics_dim.race_national_origin_refusal_flag
        AND borrower_b1.b_race_native_hawaiian = borrower_demographics_dim.race_native_hawaiian_flag
        AND borrower_b1.b_race_native_hawaiian_or_other_pacific_islander = borrower_demographics_dim.race_native_hawaiian_or_other_pacific_islander_flag
        AND borrower_b1.b_race_not_applicable = borrower_demographics_dim.race_not_applicable_flag
        AND borrower_b1.b_race_not_obtainable = borrower_demographics_dim.race_not_obtainable_flag
        AND borrower_b1.b_race_other_asian = borrower_demographics_dim.race_other_asian_flag
        AND borrower_b1.b_race_other_pacific_islander = borrower_demographics_dim.race_other_pacific_islander_flag
        AND borrower_b1.b_race_samoan = borrower_demographics_dim.race_samoan_flag
        AND borrower_b1.b_race_vietnamese = borrower_demographics_dim.race_vietnamese_flag
        AND borrower_b1.b_race_white = borrower_demographics_dim.race_white_flag
        AND borrower_b1.b_sex_female = borrower_demographics_dim.sex_female_flag
        AND borrower_b1.b_sex_male = borrower_demographics_dim.sex_male_flag
        AND borrower_b1.b_sex_not_obtainable = borrower_demographics_dim.sex_not_obtainable_flag
        AND borrower_b1.b_marital_status_type = borrower_demographics_dim.marital_status_code
        AND borrower_b1.b_race_collected_visual_or_surname = borrower_demographics_dim.race_collected_visual_or_surname_code
        AND borrower_b1.b_race_refused = borrower_demographics_dim.race_refused_code
        AND borrower_b1.b_schooling_years = borrower_demographics_dim.schooling_years
        AND borrower_b1.b_sex_collected_visual_or_surname = borrower_demographics_dim.sex_collected_visual_or_surname_code
        AND borrower_b1.b_sex_refused = borrower_demographics_dim.sex_refused_code
        AND borrower_demographics_dim.data_source_dwid = 1
    -- star_loan.borrower_lending_profile_dim
    LEFT JOIN star_loan.borrower_lending_profile_dim ON borrower_b1.b_alimony_child_support =
                                                        borrower_lending_profile_dim.alimony_child_support_code
        AND borrower_b1.b_bankruptcy = borrower_lending_profile_dim.bankruptcy_code
        AND borrower_b1.b_borrowed_down_payment = borrower_lending_profile_dim.borrowed_down_payment_code
        AND borrower_b1.b_citizenship_residency_type = borrower_lending_profile_dim.citizenship_residency_code
        AND borrower_b1.b_disabled = borrower_lending_profile_dim.disabled_code
        AND borrower_b1.b_domestic_relationship_state_type = borrower_lending_profile_dim.domestic_relationship_state_code
        AND (CASE WHEN borrower_b1.b_alimony_child_support_explanation <> ''''
            AND borrower_b1.b_alimony_child_support_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.alimony_child_support_explanation_flag
        AND (CASE WHEN borrower_b1.b_bankruptcy_explanation <> ''''
            AND borrower_b1.b_bankruptcy_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.bankruptcy_explanation_flag
        AND (CASE WHEN borrower_b1.b_borrowed_down_payment_explanation <> ''''
            AND borrower_b1.b_borrowed_down_payment_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.borrowed_down_payment_explanation_flag
        AND borrower_b1.b_has_dependents = borrower_lending_profile_dim.dependents_code
        AND (CASE WHEN borrower_b1.b_note_endorser_explanation <> ''''
            AND borrower_b1.b_note_endorser_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.note_endorser_explanation_flag
        AND (CASE WHEN borrower_b1.b_obligated_loan_foreclosure_explanation <> ''''
            AND borrower_b1.b_obligated_loan_foreclosure_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.obligated_loan_foreclosure_explanation_flag
        AND (CASE WHEN borrower_b1.b_outstanding_judgments_explanation <> ''''
            AND borrower_b1.b_outstanding_judgments_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.outstanding_judgments_explanation_flag
        AND (CASE WHEN borrower_b1.b_party_to_lawsuit_explanation <> ''''
            AND borrower_b1.b_party_to_lawsuit_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.party_to_lawsuit_explanation_flag
        AND (CASE WHEN borrower_b1.b_presently_delinquent_explanation <> ''''
            AND borrower_b1.b_presently_delinquent_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.presently_delinquent_explanation_flag
        AND (CASE WHEN borrower_b1.b_property_foreclosure_explanation <> ''''
            AND borrower_b1.b_property_foreclosure_explanation IS NOT NULL THEN TRUE ELSE FALSE END) =
            borrower_lending_profile_dim.property_foreclosure_explanation_flag
        AND borrower_b1.b_homeowner_past_three_years = borrower_lending_profile_dim.homeowner_past_three_years_code
        AND borrower_b1.b_homeownership_education_agency_type = borrower_lending_profile_dim
            .homeownership_education_agency_code
        AND borrower_b1.b_homeownership_education_type = borrower_lending_profile_dim.homeownership_education_code
        AND (borrower_b1.b_homeownership_education_complete_date = borrower_lending_profile_dim
            .homeownership_education_complete_date OR (borrower_b1.b_homeownership_education_complete_date IS NULL
            AND borrower_lending_profile_dim.homeownership_education_complete_date IS NULL))
        AND borrower_b1.b_intend_to_occupy = borrower_lending_profile_dim.intend_to_occupy_code
        AND borrower_b1.b_first_time_homebuyer = borrower_lending_profile_dim.first_time_homebuyer_flag
        AND borrower_b1.b_first_time_home_buyer_auto_compute = borrower_lending_profile_dim.first_time_homebuyer_auto_compute_flag
        AND borrower_b1.b_hud_employee = borrower_lending_profile_dim.hud_employee_flag
        AND borrower_b1.b_lender_employee_status_confirmed = borrower_lending_profile_dim.lender_employee_status_confirmed_flag
        AND borrower_b1.b_lender_employee = borrower_lending_profile_dim.lender_employee_code
        AND borrower_b1.b_note_endorser = borrower_lending_profile_dim.note_endorser_code
        AND borrower_b1.b_obligated_loan_foreclosure = borrower_lending_profile_dim.obligated_loan_foreclosure_code
        AND borrower_b1.b_on_gsa_list = borrower_lending_profile_dim.on_gsa_list_code
        AND borrower_b1.b_on_ldp_list = borrower_lending_profile_dim.on_ldp_list_code
        AND borrower_b1.b_outstanding_judgements = borrower_lending_profile_dim.outstanding_judgements_code
        AND borrower_b1.b_party_to_lawsuit = borrower_lending_profile_dim.party_to_lawsuit_code
        AND borrower_b1.b_presently_delinquent = borrower_lending_profile_dim.presently_delinquent_code
        AND borrower_b1.b_property_foreclosure = borrower_lending_profile_dim.property_foreclosure_code
        AND borrower_b1.b_spousal_homestead = borrower_lending_profile_dim.spousal_homestead_code
        AND borrower_b1.b_titleholder = borrower_lending_profile_dim.titleholder_code
        AND borrower_lending_profile_dim.data_source_dwid = 1
    -- star_loan.lender_user_dim
    LEFT JOIN (
        SELECT lender_user_dim.*
            , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS lender_user_dim ON deal_key_roles.dkrs_collateral_to_custodian_lender_user_pid = lender_user_dim.lender_user_pid
        AND lender_user_dim.data_source_dwid = 1
    -- star_loan.interim_funder_dim
    LEFT JOIN (
        SELECT interim_funder_dim.*
            , <<interim_funder_dim_partial_load_condition>> AS include_record
        FROM star_loan.interim_funder_dim
    ) AS interim_funder_dim ON interim_funder.if_pid = interim_funder_dim.interim_funder_pid
        AND interim_funder_dim.data_source_dwid = 1
    -- star_loan.product_terms_dim
    LEFT JOIN (
        SELECT product_terms_dim.*
            , <<product_terms_dim_partial_load_condition>> AS include_record
        FROM star_loan.product_terms_dim
    ) AS product_terms_dim ON product_terms.pt_pid = product_terms_dim.product_terms_pid
        AND product_terms_dim.data_source_dwid = 1
    -- star_loan.product_dim
    LEFT JOIN (
        SELECT product_dim.*
            , <<product_dim_partial_load_condition>> AS include_record
        FROM star_loan.product_dim
    ) AS product_dim ON product.p_pid = product_terms_dim.product_pid
        AND product_dim.data_source_dwid = 1
    -- star_loan.investor_dim
    LEFT JOIN (
        SELECT investor_dim.*
            , <<investor_dim_partial_load_condition>> AS include_record
        FROM star_loan.investor_dim
    ) AS investor_dim ON product_investor.i_pid = investor_dim.investor_pid
        AND investor_dim.data_source_dwid = 1
    -- star_loan.hmda_purchaser_of_loan_dim
    LEFT JOIN (
        SELECT hmda_purchaser_of_loan_dim.*
            , <<hmda_purchaser_of_loan_dim_partial_load_condition>> AS include_record
        FROM star_loan.hmda_purchaser_of_loan_dim
    ) AS hmda_purchaser_of_loan_dim ON hmda_purchaser_of_loan_2017_type.code = hmda_purchaser_of_loan_dim.code_2017
        AND hmda_purchaser_of_loan_2018_type.code = hmda_purchaser_of_loan_dim.code_2018
        AND hmda_purchaser_of_loan_dim.data_source_dwid = 1
    -- star_loan.date_dim joins for date dwids
    LEFT JOIN star_common.date_dim agency_case_id_assigned_date_dim ON loan.l_agency_case_id_assigned_date =
        agency_case_id_assigned_date_dim.value
    LEFT JOIN star_common.date_dim apor_date_dim ON loan.l_apor_date = apor_date_dim.value
    LEFT JOIN star_common.date_dim application_signed_date_dim ON borrower_b1.b_application_signed_date =
        application_signed_date_dim.value
    LEFT JOIN star_common.date_dim approved_with_conditions_date_dim ON
        current_loan_beneficiary.lb_approved_with_conditions_date = approved_with_conditions_date_dim.value
    LEFT JOIN star_common.date_dim beneficiary_from_date_dim ON current_loan_beneficiary.lb_from_date
        = beneficiary_from_date_dim.value
    LEFT JOIN star_common.date_dim beneficiary_through_date_dim ON current_loan_beneficiary.lb_through_date =
        beneficiary_through_date_dim.value
    LEFT JOIN star_common.date_dim collateral_sent_date_dim ON active_loan_funding.lf_collateral_sent_date =
        collateral_sent_date_dim.value
    LEFT JOIN star_common.date_dim disbursement_date_dim ON active_loan_funding.lf_disbursement_date =
        disbursement_date_dim.value
    LEFT JOIN star_common.date_dim early_funding_date_dim ON current_loan_beneficiary.lb_early_funding_date =
        early_funding_date_dim.value
    LEFT JOIN star_common.date_dim effective_funding_date_dim ON proposal.prp_effective_funding_date =
        effective_funding_date_dim.value
    LEFT JOIN star_common.date_dim fha_endorsement_date_dim ON loan.l_fha_endorsement_date =
        fha_endorsement_date_dim.value
    LEFT JOIN star_common.date_dim estimated_funding_date_dim ON proposal.prp_estimated_funding_date =
        estimated_funding_date_dim.value
    LEFT JOIN star_common.date_dim intent_to_proceed_date_dim ON proposal.prp_intent_to_proceed_date =
        intent_to_proceed_date_dim.value
    LEFT JOIN star_common.date_dim funding_date_dim ON active_loan_funding.lf_funding_date = funding_date_dim.value
    LEFT JOIN star_common.date_dim funding_requested_date_dim ON active_loan_funding.lf_requested_date =
        funding_requested_date_dim.value
    LEFT JOIN star_common.date_dim loan_file_ship_date_dim ON current_loan_beneficiary.lb_loan_file_ship_date =
        loan_file_ship_date_dim.value
    LEFT JOIN star_common.date_dim mers_transfer_creation_date_dim ON current_loan_beneficiary.lb_mers_transfer_creation_date =
        mers_transfer_creation_date_dim.value
    LEFT JOIN star_common.date_dim pending_wire_date_dim ON current_loan_beneficiary.lb_pending_wire_date =
        pending_wire_date_dim.value
    LEFT JOIN star_common.date_dim rejected_date_dim ON current_loan_beneficiary.lb_rejected_date =
        rejected_date_dim.value
    LEFT JOIN star_common.date_dim return_confirmed_date_dim ON active_loan_funding.lf_return_confirmed_date =
    return_confirmed_date_dim.value
    LEFT JOIN star_common.date_dim return_request_date_dim ON active_loan_funding.lf_return_request_date =
        return_request_date_dim.value
    LEFT JOIN star_common.date_dim scheduled_release_date_dim ON active_loan_funding.lf_scheduled_release_date =
        scheduled_release_date_dim.value
    LEFT JOIN star_common.date_dim usda_guarantee_date_dim ON loan.l_usda_guarantee_date = usda_guarantee_date_dim.value
    LEFT JOIN star_common.date_dim va_guaranty_date_dim ON loan.l_va_guaranty_date = va_guaranty_date_dim.value
WHERE GREATEST(deal.include_record, proposal.include_record, primary_application.include_record, loan.include_record,
    deal_key_roles.include_record, borrower_b1.include_record, borrower_b2.include_record, borrower_b3.include_record,
    borrower_b4.include_record, borrower_b5.include_record, borrower_c1.include_record, borrower_c2.include_record,
    borrower_c3.include_record, borrower_c4.include_record, borrower_c5.include_record, borrower_n1.include_record,
    borrower_n2.include_record, borrower_n3.include_record, borrower_n4.include_record, borrower_n5.include_record,
    borrower_n6.include_record, borrower_n7.include_record, borrower_n8.include_record, current_loan_beneficiary.include_record,
    active_loan_funding.include_record, interim_funder.include_record, product_terms.include_record,
    product.include_record, product_investor.include_record, application_dim.include_record,
    borrower_b1_dim.include_record, borrower_b2_dim.include_record, borrower_b3_dim.include_record,
    borrower_b3_dim.include_record, borrower_b4_dim.include_record, borrower_b5_dim.include_record,
    borrower_c1_dim.include_record, borrower_c2_dim.include_record, borrower_c3_dim.include_record,
    borrower_c4_dim.include_record, borrower_c5_dim.include_record, borrower_n1_dim.include_record,
    borrower_n2_dim.include_record, borrower_n3_dim.include_record, borrower_n4_dim.include_record,
    borrower_n5_dim.include_record, borrower_n6_dim.include_record, borrower_n7_dim.include_record,
    borrower_n8_dim.include_record, hmda_purchaser_of_loan_dim.include_record, interim_funder_dim.include_record,
    investor_dim.include_record, lender_user_dim.include_record, loan_beneficiary_dim.include_record,
    loan_dim.include_record, loan_funding_dim.include_record, product_dim.include_record,
    product_terms_dim.include_record, transaction_dim.include_record) IS TRUE
;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'loan_fact'
        );
