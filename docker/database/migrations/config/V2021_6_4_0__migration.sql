--
-- EDW | State machine creator - Allow multiple processes to be triggered from the same 'previous' process (parallel)
-- https://app.asana.com/0/0/1200341798516191
--

--going forward, we will only store processes in state_machine_step that *have* a next process
DELETE
FROM mdi.state_machine_step
WHERE state_machine_step.next_process_dwid IS NULL;

--add new metadata column and initial data for Terraform's scheduling configuration
ALTER TABLE mdi.state_machine_definition
    ADD COLUMN cron_schedule TEXT;

UPDATE mdi.state_machine_definition
SET cron_schedule = '0/15 * * * ? *'
WHERE cron_schedule IS NULL;

--
-- EDW | Build star_loan.loan_fact ETL
-- (https://app.asana.com/0/0/1200254151885104)
--

DO $$
-- Variables to store next in sequence dwids corresponding process, table_input_step, and insert_update_step
-- tables for SP-300001
    DECLARE sp_300001_process_dwid BIGINT;
        DECLARE sp_300001_json_output_field_dwid BIGINT;
        DECLARE sp_300001_table_input_step_dwid BIGINT;
        DECLARE sp_300001_insert_update_step_dwid BIGINT;

        -- Assigning dwid sequence next values to variables
    BEGIN
        sp_300001_process_dwid = (SELECT nextval('mdi."process_dwid_seq"'));
        sp_300001_json_output_field_dwid = (SELECT nextval('mdi."json_output_field_dwid_seq"'));
        sp_300001_table_input_step_dwid = (SELECT nextval('mdi."table_input_step_dwid_seq"'));
        sp_300001_insert_update_step_dwid = (SELECT nextval('mdi."insert_update_step_dwid_seq"'));

        -- process record insert
        INSERT INTO mdi.process (dwid, name, description)
        VALUES (sp_300001_process_dwid, 'SP-300001', 'ETL to maintain loan_fact');

        -- json_output_field record insert
        INSERT INTO mdi.json_output_field (dwid, process_dwid, field_name)
        VALUES (sp_300001_json_output_field_dwid, sp_300001_process_dwid, 'data_source_integration_id');

        -- table_input_step record insert
        INSERT INTO mdi.table_input_step (dwid
                                         , process_dwid, data_source_dwid
                                         , sql
                                         , limit_size, connectionname)
        VALUES (sp_300001_table_input_step_dwid
               , sp_300001_process_dwid
               , 1
               , 'SELECT
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
        AND (CASE WHEN proposal.prp_structure_type = ''COMBO'' AND loan.l_lien_priority_type = ''SECOND'' THEN TRUE
                  ELSE FALSE END) = loan_junk_dim.piggyback_flag
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
        AND (CASE WHEN borrower_b1.b_ethnicity_other_hispanic_or_latino_description = '''' THEN FALSE ELSE TRUE END)
                                                                  = borrower_demographics_dim.ethnicity_other_hispanic_or_latino_description_flag
        AND (CASE WHEN borrower_b1.b_other_race_national_origin_description = '''' THEN FALSE ELSE TRUE END) =
            borrower_demographics_dim.other_race_national_origin_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_american_indian_or_alaska_native_description = '''' THEN FALSE ELSE
            TRUE END) = borrower_demographics_dim.race_other_american_indian_or_alaska_native_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_asian_description = '''' THEN FALSE ELSE TRUE END) =
            borrower_demographics_dim.race_other_asian_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_pacific_islander_description = '''' THEN FALSE ELSE TRUE END) =
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
        AND borrower_b1.b_domestic_relationship_state_type = borrower_lending_profile_dim
            .domestic_relationship_state_code
        AND (CASE WHEN borrower_b1.b_alimony_child_support_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.alimony_child_support_explanation_flag
        AND (CASE WHEN borrower_b1.b_bankruptcy_explanation = '''' THEN FALSE ELSE TRUE END) = borrower_lending_profile_dim
            .bankruptcy_explanation_flag
        AND (CASE WHEN borrower_b1.b_borrowed_down_payment_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.borrowed_down_payment_explanation_flag
        AND borrower_b1.b_has_dependents = borrower_lending_profile_dim.dependents_code
        AND (CASE WHEN borrower_b1.b_note_endorser_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.note_endorser_explanation_flag
        AND (CASE WHEN borrower_b1.b_obligated_loan_foreclosure_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.obligated_loan_foreclosure_explanation_flag
        AND (CASE WHEN borrower_b1.b_outstanding_judgments_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.outstanding_judgments_explanation_flag
        AND (CASE WHEN borrower_b1.b_party_to_lawsuit_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.party_to_lawsuit_explanation_flag
        AND (CASE WHEN borrower_b1.b_presently_delinquent_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.presently_delinquent_explanation_flag
        AND (CASE WHEN borrower_b1.b_property_foreclosure_explanation = '''' THEN FALSE ELSE TRUE END) =
            borrower_lending_profile_dim.property_foreclosure_explanation_flag
        AND borrower_b1.b_homeowner_past_three_years = borrower_lending_profile_dim.homeowner_past_three_years_code
        AND borrower_b1.b_homeownership_education_agency_type = borrower_lending_profile_dim
            .homeownership_education_agency_code
        AND borrower_b1.b_homeownership_education_type = borrower_lending_profile_dim.homeownership_education_code
        AND (borrower_b1.b_homeownership_education_complete_date = borrower_lending_profile_dim
            .homeownership_education_complete_date OR (borrower_b1.b_homeownership_education_complete_date IS NULL
            AND borrower_lending_profile_dim
                                                           .homeownership_education_complete_date IS NULL))
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
;
'
               , 0
               , 'Staging DB Connection');

        -- insert_update_step record insert
        INSERT INTO mdi.insert_update_step (dwid, process_dwid, connectionname, schema_name, table_name, commit_size,
                                            do_not)
        VALUES (sp_300001_insert_update_step_dwid, sp_300001_process_dwid, 'Staging DB Connection', 'star_loan', 'loan_fact'
               , 1000, 'N');

        -- insert_update_key record insert
        INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)
        VALUES (sp_300001_insert_update_step_dwid, 'loan_pid', 'loan_pid', NULL, '=')
             , (sp_300001_insert_update_step_dwid, 'data_source_dwid', 'data_source_dwid', NULL, '=');

        -- insert_update_field record inserts
        INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
        VALUES (sp_300001_insert_update_step_dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', FALSE)
             , (sp_300001_insert_update_step_dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'data_source_integration_columns', 'data_source_integration_columns',
                'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'Y',
                FALSE)
             , (sp_300001_insert_update_step_dwid, 'loan_pid', 'loan_pid', 'N', FALSE)
             , (sp_300001_insert_update_step_dwid, 'loan_dwid', 'loan_dwid', 'N', FALSE)
             , (sp_300001_insert_update_step_dwid, 'loan_junk_dwid', 'loan_junk_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'product_choice_dwid', 'product_choice_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'transaction_dwid', 'transaction_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'transaction_junk_dwid', 'transaction_junk_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'current_loan_beneficiary_dwid', 'current_loan_beneficiary_dwid',
                'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'active_loan_funding_dwid', 'active_loan_funding_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'b1_borrower_dwid', 'b1_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'b2_borrower_dwid', 'b2_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'b3_borrower_dwid', 'b3_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'b4_borrower_dwid', 'b4_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'b5_borrower_dwid', 'b5_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'c1_borrower_dwid', 'c1_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'c2_borrower_dwid', 'c2_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'c3_borrower_dwid', 'c3_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'c4_borrower_dwid', 'c4_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'c5_borrower_dwid', 'c5_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n1_borrower_dwid', 'n1_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n2_borrower_dwid', 'n2_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n3_borrower_dwid', 'n3_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n4_borrower_dwid', 'n4_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n5_borrower_dwid', 'n5_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n6_borrower_dwid', 'n6_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n7_borrower_dwid', 'n7_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'n8_borrower_dwid', 'n8_borrower_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'b1_borrower_demographics_dwid', 'b1_borrower_demographics_dwid', 'Y',
                FALSE)
             , (sp_300001_insert_update_step_dwid, 'b1_borrower_lending_profile_dwid', 'b1_borrower_lending_profile_dwid',
                'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'primary_application_dwid', 'primary_application_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'collateral_to_custodian_lender_user_dwid',
                'collateral_to_custodian_lender_user_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'interim_funder_dwid', 'interim_funder_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'product_terms_dwid', 'product_terms_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'product_dwid', 'product_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'product_investor_dwid', 'product_investor_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'hmda_purchaser_of_loan_dwid', 'hmda_purchaser_of_loan_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'apr', 'apr', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'base_loan_amount', 'base_loan_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'financed_amount', 'financed_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'loan_amount', 'loan_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'ltv_ratio_percent', 'ltv_ratio_percent', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'note_rate_percent', 'note_rate_percent', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'purchase_advice_amount', 'purchase_advice_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'finance_charge_amount', 'finance_charge_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'hoepa_fees_dollar_amount', 'hoepa_fees_dollar_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'interest_rate_fee_change_amount', 'interest_rate_fee_change_amount',
                'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'principal_curtailment_amount', 'principal_curtailment_amount', 'Y',
                FALSE)
             , (sp_300001_insert_update_step_dwid, 'qualifying_pi_amount', 'qualifying_pi_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'target_cash_out_amount', 'target_cash_out_amount', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'heloc_maximum_balance_amount', 'heloc_maximum_balance_amount', 'Y',
                FALSE)
             , (sp_300001_insert_update_step_dwid, 'agency_case_id_assigned_date_dwid',
                'agency_case_id_assigned_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'apor_date_dwid', 'apor_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'application_signed_date_dwid', 'application_signed_date_dwid', 'Y',
                FALSE)
             , (sp_300001_insert_update_step_dwid, 'approved_with_conditions_date_dwid',
                'approved_with_conditions_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'beneficiary_from_date_dwid', 'beneficiary_from_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'beneficiary_through_date_dwid', 'beneficiary_through_date_dwid', 'Y',
                FALSE)
             , (sp_300001_insert_update_step_dwid,'collateral_sent_date_dwid', 'collateral_sent_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'disbursement_date_dwid', 'disbursement_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'early_funding_date_dwid', 'early_funding_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'effective_funding_date_dwid', 'effective_funding_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'fha_endorsement_date_dwid', 'fha_endorsement_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'estimated_funding_date_dwid', 'estimated_funding_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'intent_to_proceed_date_dwid', 'intent_to_proceed_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'funding_date_dwid', 'funding_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'funding_requested_date_dwid', 'funding_requested_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'loan_file_ship_date_dwid', 'loan_file_ship_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'mers_transfer_creation_date_dwid', 'mers_transfer_creation_date_dwid',
                'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'pending_wire_date_dwid', 'pending_wire_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'rejected_date_dwid', 'rejected_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'return_confirmed_date_dwid', 'return_confirmed_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'return_request_date_dwid', 'return_request_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'scheduled_release_date_dwid', 'scheduled_release_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'usda_guarantee_date_dwid', 'usda_guarantee_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'va_guaranty_date_dwid', 'va_guaranty_date_dwid', 'Y', FALSE)
             , (sp_300001_insert_update_step_dwid, 'data_source_dwid', 'data_source_dwid', 'N', FALSE)
             , (sp_300001_insert_update_step_dwid, 'etl_batch_id', 'etl_batch_id', 'Y', FALSE);

        -- state_machine_step record updates
        INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)
        SELECT process.dwid AS process_dwid
             , (SELECT process.dwid
                FROM mdi.process
                         JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                    AND insert_update_step.table_name = 'loan_fact') AS next_process_dwid
        FROM mdi.process
                 JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
        WHERE table_output_step.target_schema = 'history_octane'
          AND table_output_step.target_table = 'deal_key_roles'
        UNION ALL
        SELECT process.dwid AS process_dwid
             , (SELECT process.dwid
                FROM mdi.process
                         JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                    AND insert_update_step.table_name = 'loan_fact') AS next_process_dwid
        FROM mdi.process
                 JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
            AND insert_update_step.schema_name = 'star_loan'
            AND insert_update_step.table_name IN ('loan_dim', 'loan_junk_dim', 'product_choice_dim', 'transaction_junk_dim',
                                                  'hmda_purchaser_of_loan_dim', 'borrower_dim', 'borrower_demographics_dim',
                                                  'borrower_lending_profile_dim', 'interim_funder_dim', 'investor_dim',
                                                  'lender_user_dim', 'loan_beneficiary_dim', 'loan_funding_dim',
                                                  'mortgage_insurance_dim', 'product_dim', 'product_terms_dim',
                                                  'application_dim', 'transaction_dim');

    END $$;

--
-- EDW | Build MDI-2 delete configuration for star_loan.loan_fact
-- https://app.asana.com/0/0/1200416935542091
--

-- process record insert
WITH process_insert AS (
    INSERT INTO mdi.process (name, description)
        VALUES ('SP-300002', 'ETL to remove records that are no longer valid from loan_fact')
        RETURNING dwid
)
-- json_output_field record insert
   , json_output_field_insert AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT process_insert.dwid, 'loan_dwid'
        FROM process_insert
)
-- table_input_step insert
   , table_input_step_insert AS (
    INSERT INTO mdi.table_input_step (process_dwid
        , data_source_dwid
        , sql
        , limit_size
        , connectionname)
        SELECT process_insert.dwid
             , 0
             ,   '/*
                    First half of UNION ALL query returns the following:
                        -  Records marked as deleted in the following history_octane tables:
                            - deal
                            - proposal
                            - loan
                        - history_octane.deal records where d_test_loan IS TRUE
                    */
                    SELECT loan_fact.loan_dwid
                    FROM (
                        SELECT deal.*
                            , <<deal_partial_load_condition>> AS include_record
                        FROM history_octane.deal
                            LEFT JOIN history_octane.deal AS history_records on deal.d_pid = history_records.d_pid
                                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
                        WHERE history_records.d_pid IS NULL
                        ) AS deal
                            JOIN (
                                SELECT proposal.*
                                    , <<proposal_partial_load_condition>> AS include_record
                                FROM history_octane.proposal
                                    LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
                                        AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                                WHERE history_records.prp_pid IS NULL
                            ) AS proposal ON deal.d_active_proposal_pid = proposal.prp_pid
                        JOIN (
                            SELECT loan.*
                                , <<loan_partial_load_condition>> AS include_record
                            FROM history_octane.loan
                                LEFT JOIN history_octane.loan history_records ON loan.l_pid = history_records.l_pid
                                    AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
                            WHERE history_records.l_pid IS NULL
                            ) AS loan ON proposal.prp_pid = loan.l_proposal_pid
                        JOIN star_loan.loan_fact ON loan.l_pid = loan_fact.loan_pid
                            AND loan_fact.data_source_dwid = 1
                    WHERE NOT (deal.d_test_loan IS FALSE
                            AND deal.data_source_deleted_flag IS FALSE
                            AND proposal.data_source_deleted_flag IS FALSE
                            AND loan.data_source_deleted_flag IS FALSE
                        )
                        AND GREATEST(deal.include_record, proposal.include_record, loan.include_record) IS TRUE
                    UNION ALL
                    -- Second half of UNION ALL query returns proposal records that are not a deal''s active proposal
                    SELECT loan_fact.loan_dwid
                    FROM (
                        SELECT deal.*
                            , <<deal_partial_load_condition>> AS include_record
                        FROM history_octane.deal
                            LEFT JOIN history_octane.deal AS history_records on deal.d_pid = history_records.d_pid
                                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
                        WHERE deal.data_source_deleted_flag IS FALSE
                            AND history_records.d_pid IS NULL
                        ) AS deal
                            JOIN (
                                SELECT proposal.*
                                    , <<proposal_partial_load_condition>> AS include_record
                                FROM history_octane.proposal
                                    LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
                                        AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
                                WHERE proposal.data_source_deleted_flag IS FALSE
                                    AND history_records.prp_pid IS NULL
                            ) AS proposal ON deal.d_pid = proposal.prp_deal_pid
                                AND deal.d_active_proposal_pid <> proposal.prp_pid
                        JOIN (
                            SELECT loan.*
                                , <<loan_partial_load_condition>> AS include_record
                            FROM history_octane.loan
                                LEFT JOIN history_octane.loan history_records ON loan.l_pid = history_records.l_pid
                                    AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
                            WHERE loan.data_source_deleted_flag IS FALSE
                                AND history_records.l_pid IS NULL
                            ) AS loan ON proposal.prp_pid = loan.l_proposal_pid
                        JOIN star_loan.loan_fact ON loan.l_pid = loan_fact.loan_pid
                            AND loan_fact.data_source_dwid = 1
                    WHERE GREATEST(deal.include_record, proposal.include_record, loan.include_record) IS TRUE;'
             , 0
             , 'Staging DB Connection'
        FROM process_insert
)

-- delete_step insert
   , delete_step_insert AS (
    INSERT INTO mdi.delete_step (process_dwid, connectionname, schema_name, table_name, commit_size)
        SELECT process_insert.dwid, 'Staging DB Connection', 'star_loan',
               'loan_fact', 1000
        FROM process_insert
        RETURNING dwid
)
-- delete_key insert
   , delete_key_insert AS (
    INSERT INTO mdi.delete_key (delete_step_dwid, table_name_field, stream_fieldname_1, stream_fieldname_2,
                                comparator, is_sensitive)
        SELECT delete_step_insert.dwid, 'loan_dwid', 'loan_dwid', '',
               '=', FALSE
        FROM delete_step_insert
)

-- state_machine_step inserts
INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid AS process_dwid
     , (SELECT process_insert.dwid FROM process_insert) AS next_process_dwid
FROM mdi.process
         JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
WHERE table_output_step.target_schema = 'history_octane'
  AND table_output_step.target_table IN ('deal', 'proposal', 'loan');


--
-- EDW | Add MDI configs to populate dimension tables that currently exist in star_loan (https://app.asana.com/0/0/1200245179995890 )
--

-- The following statement adds an ETL configuration to populate star_loan.application_dim (SP-200003)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200003', 'Dimension ETL to populate application_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''application_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.apl_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        primary_table.apl_pid as application_pid,
        primary_table.apl_proposal_pid as proposal_pid
 FROM (
    SELECT
        <<application_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.application current_record
        LEFT JOIN history_octane.application AS history_records ON current_record.apl_pid = history_records.apl_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.apl_pid IS NULL
    ) AS primary_table
  WHERE
    GREATEST(primary_table.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'application_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'application_pid', 'application_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'proposal_pid', 'proposal_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'application'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'application') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.application_dim (SP-200003)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.borrower_demographics_dim (SP-200004)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200004', 'Dimension ETL to populate borrower_demographics_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''sex_refused_code'' || ''~'' || ''sex_collected_visual_or_surname_code'' || ''~'' || ''sex_male_flag'' || ''~'' || ''sex_female_flag'' || ''~'' || ''sex_not_obtainable_flag'' || ''~'' || ''ethnicity_refused_code'' || ''~'' || ''ethnicity_collected_visual_or_surname_code'' || ''~'' || ''ethnicity_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_mexican_flag'' || ''~'' || ''ethnicity_puerto_rican_flag'' || ''~'' || ''ethnicity_cuban_flag'' || ''~'' || ''ethnicity_other_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_not_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_not_obtainable_flag'' || ''~'' || ''marital_status_code'' || ''~'' || ''race_refused_code'' || ''~'' || ''race_collected_visual_or_surname_code'' || ''~'' || ''race_american_indian_or_alaska_native_flag'' || ''~'' || ''race_asian_flag'' || ''~'' || ''race_asian_indian_flag'' || ''~'' || ''race_chinese_flag'' || ''~'' || ''race_filipino_flag'' || ''~'' || ''race_japanese_flag'' || ''~'' || ''race_korean_flag'' || ''~'' || ''race_vietnamese_flag'' || ''~'' || ''race_other_asian_flag'' || ''~'' || ''race_black_or_african_american_flag'' || ''~'' || ''race_information_not_provided_flag'' || ''~'' || ''race_national_origin_refusal_flag'' || ''~'' || ''race_native_hawaiian_or_other_pacific_islander_flag'' || ''~'' || ''race_native_hawaiian_flag'' || ''~'' || ''race_guamanian_or_chamorro_flag'' || ''~'' || ''race_samoan_flag'' || ''~'' || ''race_other_pacific_islander_flag'' || ''~'' || ''race_not_obtainable_flag'' || ''~'' || ''race_not_applicable_flag'' || ''~'' || ''race_white_flag'' || ''~'' || ''schooling_years'' || ''~'' || ''marital_status'' || ''~'' || ''ethnicity_collected_visual_or_surname'' || ''~'' || ''sex_collected_visual_or_surname'' || ''~'' || ''sex_refused'' || ''~'' || ''race_refused'' || ''~'' || ''ethnicity_refused'' || ''~'' || ''race_collected_visual_or_surname'' || ''~'' || ''race_other_pacific_islander_description_flag'' || ''~'' || ''data_source_dwid'' || ''~'' || ''ethnicity_other_hispanic_or_latino_description_flag'' || ''~'' || ''other_race_national_origin_description_flag'' || ''~'' || ''race_other_american_indian_or_alaska_native_description_flag'' || ''~'' || ''race_other_asian_description_flag'' as data_source_integration_columns,
        CAST(primary_table.b_sex_refused as text)  || ''~'' || CAST(primary_table.b_sex_collected_visual_or_surname as text)  || ''~'' || CAST(primary_table.b_sex_male as text)  || ''~'' || CAST(primary_table.b_sex_female as text)  || ''~'' || CAST(primary_table.b_sex_not_obtainable as text)  || ''~'' || CAST(primary_table.b_ethnicity_refused as text)  || ''~'' || CAST(primary_table.b_ethnicity_collected_visual_or_surname as text)  || ''~'' || CAST(primary_table.b_ethnicity_hispanic_or_latino as text)  || ''~'' || CAST(primary_table.b_ethnicity_mexican as text)  || ''~'' || CAST(primary_table.b_ethnicity_puerto_rican as text)  || ''~'' || CAST(primary_table.b_ethnicity_cuban as text)  || ''~'' || CAST(primary_table.b_ethnicity_other_hispanic_or_latino as text)  || ''~'' || CAST(primary_table.b_ethnicity_not_hispanic_or_latino as text)  || ''~'' || CAST(primary_table.b_ethnicity_not_obtainable as text)  || ''~'' || CAST(primary_table.b_marital_status_type as text)  || ''~'' || CAST(primary_table.b_race_refused as text)  || ''~'' || CAST(primary_table.b_race_collected_visual_or_surname as text)  || ''~'' || CAST(primary_table.b_race_american_indian_or_alaska_native as text)  || ''~'' || CAST(primary_table.b_race_asian as text)  || ''~'' || CAST(primary_table.b_race_asian_indian as text)  || ''~'' || CAST(primary_table.b_race_chinese as text)  || ''~'' || CAST(primary_table.b_race_filipino as text)  || ''~'' || CAST(primary_table.b_race_japanese as text)  || ''~'' || CAST(primary_table.b_race_korean as text)  || ''~'' || CAST(primary_table.b_race_vietnamese as text)  || ''~'' || CAST(primary_table.b_race_other_asian as text)  || ''~'' || CAST(primary_table.b_race_black_or_african_american as text)  || ''~'' || CAST(primary_table.b_race_information_not_provided as text)  || ''~'' || CAST(primary_table.b_race_national_origin_refusal as text)  || ''~'' || CAST(primary_table.b_race_native_hawaiian_or_other_pacific_islander as text)  || ''~'' || CAST(primary_table.b_race_native_hawaiian as text)  || ''~'' || CAST(primary_table.b_race_guamanian_or_chamorro as text)  || ''~'' || CAST(primary_table.b_race_samoan as text)  || ''~'' || CAST(primary_table.b_race_other_pacific_islander as text)  || ''~'' || CAST(primary_table.b_race_not_obtainable as text)  || ''~'' || CAST(primary_table.b_race_not_applicable as text)  || ''~'' || CAST(primary_table.b_race_white as text)  || ''~'' || CAST(primary_table.b_schooling_years as text)  || ''~'' || CAST(t134.value as text)  || ''~'' || CAST(t123.value as text)  || ''~'' || CAST(t151.value as text)  || ''~'' || CAST(t152.value as text)  || ''~'' || CAST(t148.value as text)  || ''~'' || CAST(t124.value as text)  || ''~'' || CAST(t147.value as text)  || ''~'' || CAST(primary_table.b_race_other_pacific_islander_description <> '''' as text) || ''~'' || CAST(1 as text)  || ''~'' || CAST(primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' as text) || ''~'' || CAST(primary_table.b_other_race_national_origin_description <> '''' as text) || ''~'' || CAST(primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' as text) || ''~'' || CAST(primary_table.b_race_other_asian_description <> '''' as text) as data_source_integration_id,
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
        primary_table.b_race_other_pacific_islander_description <> '''' as race_other_pacific_islander_description_flag,
        primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' as ethnicity_other_hispanic_or_latino_description_flag,
        primary_table.b_other_race_national_origin_description <> '''' as other_race_national_origin_description_flag,
        primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' as race_other_american_indian_or_alaska_native_description_flag,
        primary_table.b_race_other_asian_description <> '''' as race_other_asian_description_flag
 FROM (
    SELECT
        <<borrower_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.borrower current_record
        LEFT JOIN history_octane.borrower AS history_records ON current_record.b_pid = history_records.b_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<marital_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.marital_status_type current_record
                LEFT JOIN history_octane.marital_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t134 ON primary_table.b_marital_status_type = t134.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t123 ON primary_table.b_ethnicity_collected_visual_or_surname = t123.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t151 ON primary_table.b_sex_collected_visual_or_surname = t151.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t152 ON primary_table.b_sex_refused = t152.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t148 ON primary_table.b_race_refused = t148.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t124 ON primary_table.b_ethnicity_refused = t124.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t147 ON primary_table.b_race_collected_visual_or_surname = t147.code
 WHERE
    GREATEST(primary_table.include_record, t134.include_record, t123.include_record, t151.include_record, t152.include_record, t148.include_record, t124.include_record, t147.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'borrower_demographics_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_refused_code', 'sex_refused_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_collected_visual_or_surname_code', 'sex_collected_visual_or_surname_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_male_flag', 'sex_male_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_female_flag', 'sex_female_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_not_obtainable_flag', 'sex_not_obtainable_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_refused_code', 'ethnicity_refused_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_collected_visual_or_surname_code', 'ethnicity_collected_visual_or_surname_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_hispanic_or_latino_flag', 'ethnicity_hispanic_or_latino_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_mexican_flag', 'ethnicity_mexican_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_puerto_rican_flag', 'ethnicity_puerto_rican_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_cuban_flag', 'ethnicity_cuban_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_other_hispanic_or_latino_flag', 'ethnicity_other_hispanic_or_latino_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_not_hispanic_or_latino_flag', 'ethnicity_not_hispanic_or_latino_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_not_obtainable_flag', 'ethnicity_not_obtainable_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'marital_status_code', 'marital_status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_refused_code', 'race_refused_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_collected_visual_or_surname_code', 'race_collected_visual_or_surname_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_american_indian_or_alaska_native_flag', 'race_american_indian_or_alaska_native_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_asian_flag', 'race_asian_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_asian_indian_flag', 'race_asian_indian_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_chinese_flag', 'race_chinese_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_filipino_flag', 'race_filipino_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_japanese_flag', 'race_japanese_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_korean_flag', 'race_korean_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_vietnamese_flag', 'race_vietnamese_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_other_asian_flag', 'race_other_asian_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_black_or_african_american_flag', 'race_black_or_african_american_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_information_not_provided_flag', 'race_information_not_provided_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_national_origin_refusal_flag', 'race_national_origin_refusal_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_native_hawaiian_or_other_pacific_islander_flag', 'race_native_hawaiian_or_other_pacific_islander_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_native_hawaiian_flag', 'race_native_hawaiian_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_guamanian_or_chamorro_flag', 'race_guamanian_or_chamorro_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_samoan_flag', 'race_samoan_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_other_pacific_islander_flag', 'race_other_pacific_islander_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_not_obtainable_flag', 'race_not_obtainable_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_not_applicable_flag', 'race_not_applicable_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_white_flag', 'race_white_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'schooling_years', 'schooling_years', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'marital_status', 'marital_status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_collected_visual_or_surname', 'ethnicity_collected_visual_or_surname', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_collected_visual_or_surname', 'sex_collected_visual_or_surname', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sex_refused', 'sex_refused', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_50 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_refused', 'race_refused', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_51 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_refused', 'ethnicity_refused', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_52 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_collected_visual_or_surname', 'race_collected_visual_or_surname', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'borrower'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'borrower') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_39 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'marital_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'marital_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_40 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_unknown_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_unknown_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.borrower_demographics_dim (SP-200004)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.borrower_dim (SP-200005)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200005', 'Dimension ETL to populate borrower_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''borrower_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.b_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.borrower current_record
        LEFT JOIN history_octane.borrower AS history_records ON current_record.b_pid = history_records.b_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<applicant_role_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.applicant_role_type current_record
                LEFT JOIN history_octane.applicant_role_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t114 ON primary_table.b_applicant_role_type = t114.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<application_taken_method_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.application_taken_method_type current_record
                LEFT JOIN history_octane.application_taken_method_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t115 ON primary_table.b_application_taken_method_type = t115.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_relationship_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.borrower_relationship_type current_record
                LEFT JOIN history_octane.borrower_relationship_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t149 ON primary_table.b_relationship_to_primary_borrower_type = t149.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_relationship_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.borrower_relationship_type current_record
                LEFT JOIN history_octane.borrower_relationship_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t150 ON primary_table.b_relationship_to_seller_type = t150.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_tiny_id_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.borrower_tiny_id_type current_record
                LEFT JOIN history_octane.borrower_tiny_id_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t118 ON primary_table.b_borrower_tiny_id_type = t118.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t142 ON primary_table.b_power_of_attorney_country = t142.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_authorization_method_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.credit_authorization_method_type current_record
                LEFT JOIN history_octane.credit_authorization_method_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t120 ON primary_table.b_credit_report_authorization_method = t120.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_agency_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.housing_counseling_agency_type current_record
                LEFT JOIN history_octane.housing_counseling_agency_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t129 ON primary_table.b_housing_counseling_agency_type = t129.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.housing_counseling_type current_record
                LEFT JOIN history_octane.housing_counseling_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t130 ON primary_table.b_housing_counseling_type = t130.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<legal_entity_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.legal_entity_type current_record
                LEFT JOIN history_octane.legal_entity_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t132 ON primary_table.b_legal_entity_type = t132.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prior_property_title_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.prior_property_title_type current_record
                LEFT JOIN history_octane.prior_property_title_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t144 ON primary_table.b_prior_property_title_type = t144.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<property_usage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.property_usage_type current_record
                LEFT JOIN history_octane.property_usage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t145 ON primary_table.b_prior_property_usage_type = t145.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t141 ON primary_table.b_power_of_attorney = t141.code
 WHERE
    GREATEST(primary_table.include_record, t114.include_record, t115.include_record, t149.include_record, t150.include_record, t118.include_record, t142.include_record, t120.include_record, t129.include_record, t130.include_record, t132.include_record, t144.include_record, t145.include_record, t141.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'borrower_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'applicant_role', 'applicant_role', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'application_taken_method', 'application_taken_method', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'borrower_pid', 'borrower_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'alimony_child_support_explanation', 'alimony_child_support_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'application_taken_method_code', 'application_taken_method_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'bankruptcy_explanation', 'bankruptcy_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'birth_date', 'birth_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'borrowed_down_payment_explanation', 'borrowed_down_payment_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'applicant_role_code', 'applicant_role_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'required_to_sign_flag', 'required_to_sign_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'has_no_ssn_flag', 'has_no_ssn_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_report_identifier', 'credit_report_identifier', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_report_authorization_flag', 'credit_report_authorization_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'dependent_count', 'dependent_count', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'dependents_age_years', 'dependents_age_years', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'email', 'email', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fax', 'fax', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'first_name', 'first_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'nickname', 'nickname', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ethnicity_other_hispanic_or_latino_description', 'ethnicity_other_hispanic_or_latino_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'home_phone', 'home_phone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'last_name', 'last_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'middle_name', 'middle_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'name_suffix', 'name_suffix', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'note_endorser_explanation', 'note_endorser_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'obligated_loan_foreclosure_explanation', 'obligated_loan_foreclosure_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone', 'office_phone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone_extension', 'office_phone_extension', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'other_race_national_origin_description', 'other_race_national_origin_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'outstanding_judgments_explanation', 'outstanding_judgments_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'party_to_lawsuit_explanation', 'party_to_lawsuit_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_code', 'power_of_attorney_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_signing_capacity', 'power_of_attorney_signing_capacity', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_first_name', 'power_of_attorney_first_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_last_name', 'power_of_attorney_last_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_middle_name', 'power_of_attorney_middle_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_name_suffix', 'power_of_attorney_name_suffix', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_company_name', 'power_of_attorney_company_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_title', 'power_of_attorney_title', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_office_phone', 'power_of_attorney_office_phone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_office_phone_extension', 'power_of_attorney_office_phone_extension', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_mobile_phone', 'power_of_attorney_mobile_phone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_50 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_email', 'power_of_attorney_email', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_51 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_fax', 'power_of_attorney_fax', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_52 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_city', 'power_of_attorney_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_53 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_country_code', 'power_of_attorney_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_54 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_postal_code', 'power_of_attorney_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_55 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_state', 'power_of_attorney_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_56 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_street1', 'power_of_attorney_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_57 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_street2', 'power_of_attorney_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_58 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'presently_delinquent_explanation', 'presently_delinquent_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_59 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prior_property_title_code', 'prior_property_title_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_60 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prior_property_usage_code', 'prior_property_usage_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_61 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'property_foreclosure_explanation', 'property_foreclosure_explanation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_62 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_other_american_indian_or_alaska_native_description', 'race_other_american_indian_or_alaska_native_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_63 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_other_asian_description', 'race_other_asian_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_64 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'race_other_pacific_islander_description', 'race_other_pacific_islander_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_65 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'experian_credit_score', 'experian_credit_score', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_66 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'equifax_credit_score', 'equifax_credit_score', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_67 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'trans_union_credit_score', 'trans_union_credit_score', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_68 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'decision_credit_score', 'decision_credit_score', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_69 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'tiny_id_code', 'tiny_id_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_70 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'first_time_homebuyer_explain', 'first_time_homebuyer_explain', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_71 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'caivrs_id', 'caivrs_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_72 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'caivrs_messages', 'caivrs_messages', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_73 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_federal_tax_amount', 'monthly_job_federal_tax_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_74 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_state_tax_amount', 'monthly_job_state_tax_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_75 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_retirement_tax_amount', 'monthly_job_retirement_tax_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_76 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_medicare_tax_amount', 'monthly_job_medicare_tax_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_77 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_state_disability_insurance_amount', 'monthly_job_state_disability_insurance_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_78 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_other_tax_1_amount', 'monthly_job_other_tax_1_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_79 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_other_tax_1_description', 'monthly_job_other_tax_1_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_80 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_other_tax_2_amount', 'monthly_job_other_tax_2_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_81 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_other_tax_2_description', 'monthly_job_other_tax_2_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_82 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_other_tax_3_amount', 'monthly_job_other_tax_3_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_83 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_other_tax_3_description', 'monthly_job_other_tax_3_description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_84 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'monthly_job_total_tax_amount', 'monthly_job_total_tax_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_85 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education_id', 'homeownership_education_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_86 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education_name', 'homeownership_education_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_87 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling_code', 'housing_counseling_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_88 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling_agency_code', 'housing_counseling_agency_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_89 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling_id', 'housing_counseling_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_90 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling_name', 'housing_counseling_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_91 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling_complete_date', 'housing_counseling_complete_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_92 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'legal_entity_code', 'legal_entity_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_93 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_report_authorization_datetime', 'credit_report_authorization_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_94 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_report_authorization_method_code', 'credit_report_authorization_method_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_95 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_report_authorization_obtained_by_unparsed_name', 'credit_report_authorization_obtained_by_unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_96 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'usda_annual_child_care_expenses', 'usda_annual_child_care_expenses', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_97 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'usda_disability_expenses', 'usda_disability_expenses', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_98 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'usda_medical_expenses', 'usda_medical_expenses', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_99 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'usda_income_from_assets', 'usda_income_from_assets', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_100 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'usda_moderate_income_limit', 'usda_moderate_income_limit', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_101 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'relationship_to_primary_borrower_code', 'relationship_to_primary_borrower_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_102 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'relationship_to_seller_code', 'relationship_to_seller_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_103 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'preferred_first_name', 'preferred_first_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_104 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'application_pid', 'application_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_105 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'relationship_to_primary_borrower', 'relationship_to_primary_borrower', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_106 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'relationship_to_seller', 'relationship_to_seller', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_107 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'tiny_id', 'tiny_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_108 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney_country', 'power_of_attorney_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_109 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_report_authorization_method', 'credit_report_authorization_method', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_110 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling_agency', 'housing_counseling_agency', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_111 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'housing_counseling', 'housing_counseling', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_112 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'legal_entity', 'legal_entity', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_113 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prior_property_title', 'prior_property_title', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_114 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prior_property_usage', 'prior_property_usage', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_115 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'power_of_attorney', 'power_of_attorney', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'applicant_role_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'applicant_role_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'application_taken_method_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'application_taken_method_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'borrower'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'borrower') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_98 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'borrower_relationship_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'borrower_relationship_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_100 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'borrower_tiny_id_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'borrower_tiny_id_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_101 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'country_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'country_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_102 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'credit_authorization_method_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'credit_authorization_method_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_103 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'housing_counseling_agency_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'housing_counseling_agency_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_104 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'housing_counseling_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'housing_counseling_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_105 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'legal_entity_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'legal_entity_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_106 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'prior_property_title_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'prior_property_title_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_107 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'property_usage_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'property_usage_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_108 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_unknown_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_unknown_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.borrower_dim (SP-200005)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.borrower_lending_profile_dim (SP-200006)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200006', 'Dimension ETL to populate borrower_lending_profile_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''alimony_child_support_code'' || ''~'' || ''bankruptcy_code'' || ''~'' || ''borrowed_down_payment_code'' || ''~'' || ''spousal_homestead_code'' || ''~'' || ''citizenship_residency_code'' || ''~'' || ''dependents_code'' || ''~'' || ''first_time_homebuyer_flag'' || ''~'' || ''lender_employee_code'' || ''~'' || ''lender_employee_status_confirmed_flag'' || ''~'' || ''homeowner_past_three_years_code'' || ''~'' || ''intend_to_occupy_code'' || ''~'' || ''note_endorser_code'' || ''~'' || ''obligated_loan_foreclosure_code'' || ''~'' || ''outstanding_judgements_code'' || ''~'' || ''party_to_lawsuit_code'' || ''~'' || ''presently_delinquent_code'' || ''~'' || ''property_foreclosure_code'' || ''~'' || ''titleholder_code'' || ''~'' || ''first_time_homebuyer_auto_compute_flag'' || ''~'' || ''on_ldp_list_code'' || ''~'' || ''on_gsa_list_code'' || ''~'' || ''homeownership_education_code'' || ''~'' || ''homeownership_education_agency_code'' || ''~'' || ''homeownership_education_complete_date'' || ''~'' || ''disabled_code'' || ''~'' || ''hud_employee_flag'' || ''~'' || ''domestic_relationship_state_code'' || ''~'' || ''citizenship_residency'' || ''~'' || ''homeownership_education'' || ''~'' || ''homeownership_education_agency'' || ''~'' || ''domestic_relationship_state'' || ''~'' || ''alimony_child_support'' || ''~'' || ''bankruptcy'' || ''~'' || ''borrowed_down_payment'' || ''~'' || ''disabled'' || ''~'' || ''dependents'' || ''~'' || ''homeowner_past_three_years'' || ''~'' || ''intend_to_occupy'' || ''~'' || ''lender_employee'' || ''~'' || ''note_endorser'' || ''~'' || ''obligated_loan_foreclosure'' || ''~'' || ''on_gsa_list'' || ''~'' || ''on_ldp_list'' || ''~'' || ''outstanding_judgements'' || ''~'' || ''party_to_lawsuit'' || ''~'' || ''presently_delinquent'' || ''~'' || ''property_foreclosure'' || ''~'' || ''spousal_homestead'' || ''~'' || ''titleholder'' || ''~'' || ''data_source_dwid'' || ''~'' || ''property_foreclosure_explanation_flag'' || ''~'' || ''presently_delinquent_explanation_flag'' || ''~'' || ''party_to_lawsuit_explanation_flag'' || ''~'' || ''outstanding_judgments_explanation_flag'' || ''~'' || ''obligated_loan_foreclosure_explanation_flag'' || ''~'' || ''note_endorser_explanation_flag'' || ''~'' || ''borrowed_down_payment_explanation_flag'' || ''~'' || ''bankruptcy_explanation_flag'' || ''~'' || ''alimony_child_support_explanation_flag'' as data_source_integration_columns,
        CAST(primary_table.b_alimony_child_support as text)  || ''~'' || CAST(primary_table.b_bankruptcy as text)  || ''~'' || CAST(primary_table.b_borrowed_down_payment as text)  || ''~'' || CAST(primary_table.b_spousal_homestead as text)  || ''~'' || CAST(primary_table.b_citizenship_residency_type as text)  || ''~'' || CAST(primary_table.b_has_dependents as text)  || ''~'' || CAST(primary_table.b_first_time_homebuyer as text)  || ''~'' || CAST(primary_table.b_lender_employee as text)  || ''~'' || CAST(primary_table.b_lender_employee_status_confirmed as text)  || ''~'' || CAST(primary_table.b_homeowner_past_three_years as text)  || ''~'' || CAST(primary_table.b_intend_to_occupy as text)  || ''~'' || CAST(primary_table.b_note_endorser as text)  || ''~'' || CAST(primary_table.b_obligated_loan_foreclosure as text)  || ''~'' || CAST(primary_table.b_outstanding_judgements as text)  || ''~'' || CAST(primary_table.b_party_to_lawsuit as text)  || ''~'' || CAST(primary_table.b_presently_delinquent as text)  || ''~'' || CAST(primary_table.b_property_foreclosure as text)  || ''~'' || CAST(primary_table.b_titleholder as text)  || ''~'' || CAST(primary_table.b_first_time_home_buyer_auto_compute as text)  || ''~'' || CAST(primary_table.b_on_ldp_list as text)  || ''~'' || CAST(primary_table.b_on_gsa_list as text)  || ''~'' || CAST(primary_table.b_homeownership_education_type as text)  || ''~'' || CAST(primary_table.b_homeownership_education_agency_type as text)  || ''~'' || CAST(primary_table.b_homeownership_education_complete_date as text)  || ''~'' || CAST(primary_table.b_disabled as text)  || ''~'' || CAST(primary_table.b_hud_employee as text)  || ''~'' || CAST(primary_table.b_domestic_relationship_state_type as text)  || ''~'' || CAST(t119.value as text)  || ''~'' || CAST(t127.value as text)  || ''~'' || CAST(t126.value as text)  || ''~'' || CAST(t122.value as text)  || ''~'' || CAST(t113.value as text)  || ''~'' || CAST(t116.value as text)  || ''~'' || CAST(t117.value as text)  || ''~'' || CAST(t121.value as text)  || ''~'' || CAST(t125.value as text)  || ''~'' || CAST(t128.value as text)  || ''~'' || CAST(t131.value as text)  || ''~'' || CAST(t133.value as text)  || ''~'' || CAST(t135.value as text)  || ''~'' || CAST(t136.value as text)  || ''~'' || CAST(t137.value as text)  || ''~'' || CAST(t138.value as text)  || ''~'' || CAST(t139.value as text)  || ''~'' || CAST(t140.value as text)  || ''~'' || CAST(t143.value as text)  || ''~'' || CAST(t146.value as text)  || ''~'' || CAST(t153.value as text)  || ''~'' || CAST(t154.value as text)  || ''~'' || CAST(1 as text)  || ''~'' || CAST(primary_table.b_property_foreclosure_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_presently_delinquent_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_party_to_lawsuit_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_outstanding_judgments_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_obligated_loan_foreclosure_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_note_endorser_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_borrowed_down_payment_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_bankruptcy_explanation <> '''' as text) || ''~'' || CAST(primary_table.b_alimony_child_support_explanation <> '''' as text) as data_source_integration_id,
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
        primary_table.b_property_foreclosure_explanation <> '''' as property_foreclosure_explanation_flag,
        primary_table.b_presently_delinquent_explanation <> '''' as presently_delinquent_explanation_flag,
        primary_table.b_party_to_lawsuit_explanation <> '''' as party_to_lawsuit_explanation_flag,
        primary_table.b_outstanding_judgments_explanation <> '''' as outstanding_judgments_explanation_flag,
        primary_table.b_obligated_loan_foreclosure_explanation <> '''' as obligated_loan_foreclosure_explanation_flag,
        primary_table.b_note_endorser_explanation <> '''' as note_endorser_explanation_flag,
        primary_table.b_borrowed_down_payment_explanation <> '''' as borrowed_down_payment_explanation_flag,
        primary_table.b_bankruptcy_explanation <> '''' as bankruptcy_explanation_flag,
        primary_table.b_alimony_child_support_explanation <> '''' as alimony_child_support_explanation_flag
 FROM (
    SELECT
        <<borrower_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.borrower current_record
        LEFT JOIN history_octane.borrower AS history_records ON current_record.b_pid = history_records.b_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<citizenship_residency_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.citizenship_residency_type current_record
                LEFT JOIN history_octane.citizenship_residency_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t119 ON primary_table.b_citizenship_residency_type = t119.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<homeownership_education_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.homeownership_education_type current_record
                LEFT JOIN history_octane.homeownership_education_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t127 ON primary_table.b_homeownership_education_type = t127.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_agency_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.housing_counseling_agency_type current_record
                LEFT JOIN history_octane.housing_counseling_agency_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t126 ON primary_table.b_homeownership_education_agency_type = t126.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<state_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.state_type current_record
                LEFT JOIN history_octane.state_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t122 ON primary_table.b_domestic_relationship_state_type = t122.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t113 ON primary_table.b_alimony_child_support = t113.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t116 ON primary_table.b_bankruptcy = t116.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t117 ON primary_table.b_borrowed_down_payment = t117.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t121 ON primary_table.b_disabled = t121.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t125 ON primary_table.b_has_dependents = t125.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t128 ON primary_table.b_homeowner_past_three_years = t128.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t131 ON primary_table.b_intend_to_occupy = t131.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t133 ON primary_table.b_lender_employee = t133.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t135 ON primary_table.b_note_endorser = t135.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t136 ON primary_table.b_obligated_loan_foreclosure = t136.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t137 ON primary_table.b_on_gsa_list = t137.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t138 ON primary_table.b_on_ldp_list = t138.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t139 ON primary_table.b_outstanding_judgements = t139.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t140 ON primary_table.b_party_to_lawsuit = t140.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t143 ON primary_table.b_presently_delinquent = t143.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t146 ON primary_table.b_property_foreclosure = t146.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t153 ON primary_table.b_spousal_homestead = t153.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t154 ON primary_table.b_titleholder = t154.code
 WHERE
    GREATEST(primary_table.include_record, t119.include_record, t127.include_record, t126.include_record, t122.include_record, t113.include_record, t116.include_record, t117.include_record, t121.include_record, t125.include_record, t128.include_record, t131.include_record, t133.include_record, t135.include_record, t136.include_record, t137.include_record, t138.include_record, t139.include_record, t140.include_record, t143.include_record, t146.include_record, t153.include_record, t154.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'borrower_lending_profile_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'alimony_child_support_code', 'alimony_child_support_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'bankruptcy_code', 'bankruptcy_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'borrowed_down_payment_code', 'borrowed_down_payment_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'spousal_homestead_code', 'spousal_homestead_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'citizenship_residency_code', 'citizenship_residency_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'dependents_code', 'dependents_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'first_time_homebuyer_flag', 'first_time_homebuyer_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_employee_code', 'lender_employee_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_employee_status_confirmed_flag', 'lender_employee_status_confirmed_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeowner_past_three_years_code', 'homeowner_past_three_years_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'intend_to_occupy_code', 'intend_to_occupy_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'note_endorser_code', 'note_endorser_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'obligated_loan_foreclosure_code', 'obligated_loan_foreclosure_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'outstanding_judgements_code', 'outstanding_judgements_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'party_to_lawsuit_code', 'party_to_lawsuit_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'presently_delinquent_code', 'presently_delinquent_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'property_foreclosure_code', 'property_foreclosure_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'titleholder_code', 'titleholder_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'first_time_homebuyer_auto_compute_flag', 'first_time_homebuyer_auto_compute_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'on_ldp_list_code', 'on_ldp_list_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'on_gsa_list_code', 'on_gsa_list_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education_code', 'homeownership_education_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education_agency_code', 'homeownership_education_agency_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education_complete_date', 'homeownership_education_complete_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'disabled_code', 'disabled_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hud_employee_flag', 'hud_employee_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'domestic_relationship_state_code', 'domestic_relationship_state_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'citizenship_residency', 'citizenship_residency', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education', 'homeownership_education', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeownership_education_agency', 'homeownership_education_agency', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'domestic_relationship_state', 'domestic_relationship_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'alimony_child_support', 'alimony_child_support', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'bankruptcy', 'bankruptcy', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'borrowed_down_payment', 'borrowed_down_payment', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'disabled', 'disabled', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'dependents', 'dependents', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'homeowner_past_three_years', 'homeowner_past_three_years', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'intend_to_occupy', 'intend_to_occupy', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_employee', 'lender_employee', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'note_endorser', 'note_endorser', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'obligated_loan_foreclosure', 'obligated_loan_foreclosure', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'on_gsa_list', 'on_gsa_list', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_50 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'on_ldp_list', 'on_ldp_list', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_51 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'outstanding_judgements', 'outstanding_judgements', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_52 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'party_to_lawsuit', 'party_to_lawsuit', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_53 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'presently_delinquent', 'presently_delinquent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_54 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'property_foreclosure', 'property_foreclosure', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_55 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'spousal_homestead', 'spousal_homestead', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_56 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'titleholder', 'titleholder', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'borrower'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'borrower') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_28 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'citizenship_residency_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'citizenship_residency_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_29 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'homeownership_education_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'homeownership_education_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_30 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'housing_counseling_agency_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'housing_counseling_agency_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_31 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'state_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'state_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_32 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_unknown_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_unknown_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.borrower_lending_profile_dim (SP-200006)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.hmda_purchaser_of_loan_dim (SP-200007)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200007', 'Dimension ETL to populate hmda_purchaser_of_loan_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''value_2017'' || ''~'' || ''code_2017'' || ''~'' || ''code_2018'' || ''~'' || ''value_2018'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(t465.value as text)  || ''~'' || CAST(t465.code as text)  || ''~'' || CAST(t464.code as text)  || ''~'' || CAST(t464.value as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.loan current_record
        LEFT JOIN history_octane.loan AS history_records ON current_record.l_pid = history_records.l_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<hmda_purchaser_of_loan_2017_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.hmda_purchaser_of_loan_2017_type current_record
                LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t465 ON primary_table.l_hmda_purchaser_of_loan_2017_type = t465.code
        -- ignoring this because the table alias t465 has already been added: INNER JOIN history_octane.hmda_purchaser_of_loan_2017_type t465 ON primary_table.l_hmda_purchaser_of_loan_2017_type = t465.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<hmda_purchaser_of_loan_2018_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.hmda_purchaser_of_loan_2018_type current_record
                LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t464 ON primary_table.l_hmda_purchaser_of_loan_2018_type = t464.code
        -- ignoring this because the table alias t464 has already been added: INNER JOIN history_octane.hmda_purchaser_of_loan_2018_type t464 ON primary_table.l_hmda_purchaser_of_loan_2018_type = t464.code
 WHERE
    GREATEST(primary_table.include_record, t465.include_record, t464.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'hmda_purchaser_of_loan_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'value_2017', 'value_2017', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'code_2017', 'code_2017', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'code_2018', 'code_2018', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'value_2018', 'value_2018', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'hmda_purchaser_of_loan_2017_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'hmda_purchaser_of_loan_2017_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'hmda_purchaser_of_loan_2018_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'hmda_purchaser_of_loan_2018_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.hmda_purchaser_of_loan_dim (SP-200007)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.interim_funder_dim (SP-200008)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200008', 'Dimension ETL to populate interim_funder_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''interim_funder_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.if_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.interim_funder current_record
        LEFT JOIN history_octane.interim_funder AS history_records ON current_record.if_pid = history_records.if_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.if_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t309 ON primary_table.if_company_address_country = t309.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<interim_funder_mers_registration_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.interim_funder_mers_registration_type current_record
                LEFT JOIN history_octane.interim_funder_mers_registration_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t310 ON primary_table.if_interim_funder_mers_registration_type = t310.code
 WHERE
    GREATEST(primary_table.include_record, t309.include_record, t310.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'interim_funder_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_country', 'address_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'interim_funder_pid', 'interim_funder_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'name', 'name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'contact_unparsed_name', 'contact_unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_street1', 'address_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_street2', 'address_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_city', 'address_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_state', 'address_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_postal_code', 'address_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_country_code', 'address_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone', 'office_phone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone_extension', 'office_phone_extension', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'email', 'email', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fax', 'fax', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_org_id', 'mers_org_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'remarks', 'remarks', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'from_date', 'from_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'through_date', 'through_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'remibursement_wire_credit_to_name', 'remibursement_wire_credit_to_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'reimbursement_wire_attention_unparsed_name', 'reimbursement_wire_attention_unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'reimbursement_wire_authorized_signer_unparsed_name', 'reimbursement_wire_authorized_signer_unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'return_wire_credit_to_name', 'return_wire_credit_to_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'return_wire_authorized_signer_unparsed_name', 'return_wire_authorized_signer_unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_payee_id', 'fnm_payee_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_registration_code', 'mers_registration_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_warehouse_lender_id', 'fnm_warehouse_lender_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fre_warehouse_lender_id', 'fre_warehouse_lender_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'id', 'id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'return_wire_attention_unparsed_name', 'return_wire_attention_unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_registration', 'mers_registration', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'country_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'country_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'interim_funder'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'interim_funder') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_30 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'interim_funder_mers_registration_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'interim_funder_mers_registration_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.interim_funder_dim (SP-200008)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.investor_dim (SP-200009)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200009', 'Dimension ETL to populate investor_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''investor_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.i_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.investor current_record
        LEFT JOIN history_octane.investor AS history_records ON current_record.i_pid = history_records.i_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.i_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t318 ON primary_table.i_beneficiary_country = t318.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t319 ON primary_table.i_file_delivery_address_country = t319.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t323 ON primary_table.i_investor_country = t323.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t326 ON primary_table.i_loss_payee_country = t326.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t330 ON primary_table.i_servicer_address_country = t330.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t331 ON primary_table.i_sub_servicer_address_country = t331.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t332 ON primary_table.i_when_recorded_mail_to_country = t332.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_investor_remittance_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fnm_investor_remittance_type current_record
                LEFT JOIN history_octane.fnm_investor_remittance_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t320 ON primary_table.i_fnm_investor_remittance_type = t320.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_mbs_loan_default_loss_party_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fnm_mbs_loan_default_loss_party_type current_record
                LEFT JOIN history_octane.fnm_mbs_loan_default_loss_party_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t321 ON primary_table.i_fnm_mbs_loan_default_loss_party_type = t321.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_mbs_reo_marketing_party_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fnm_mbs_reo_marketing_party_type current_record
                LEFT JOIN history_octane.fnm_mbs_reo_marketing_party_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t322 ON primary_table.i_fnm_mbs_reo_marketing_party_type = t322.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<gift_funds_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.gift_funds_type current_record
                LEFT JOIN history_octane.gift_funds_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t329 ON primary_table.i_secondary_financing_source_type = t329.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<investor_hmda_purchaser_of_loan_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.investor_hmda_purchaser_of_loan_type current_record
                LEFT JOIN history_octane.investor_hmda_purchaser_of_loan_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t324 ON primary_table.i_investor_hmda_purchaser_of_loan_type = t324.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<loan_file_delivery_method_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.loan_file_delivery_method_type current_record
                LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t325 ON primary_table.i_loan_file_delivery_method_type = t325.code
 WHERE
    GREATEST(primary_table.include_record, t318.include_record, t319.include_record, t323.include_record, t326.include_record, t330.include_record, t331.include_record, t332.include_record, t320.include_record, t321.include_record, t322.include_record, t329.include_record, t324.include_record, t325.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'investor_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_country', 'beneficiary_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_country', 'file_delivery_address_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_country', 'investor_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_country', 'loss_payee_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_country', 'servicer_address_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_country', 'sub_servicer_address_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_country', 'when_recorded_mail_to_country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_investor_remittance', 'fnm_investor_remittance', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_mbs_loan_default_loss_party', 'fnm_mbs_loan_default_loss_party', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_mbs_reo_marketing_party', 'fnm_mbs_reo_marketing_party', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'secondary_financing_source', 'secondary_financing_source', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_country_code', 'investor_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_postal_code', 'investor_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_state', 'investor_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_street1', 'investor_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_street2', 'investor_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'secondary_financing_source_code', 'secondary_financing_source_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ein', 'ein', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_state', 'loss_payee_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_postal_code', 'loss_payee_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_country_code', 'when_recorded_mail_to_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_postal_code', 'when_recorded_mail_to_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_state', 'when_recorded_mail_to_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_street1', 'when_recorded_mail_to_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_street2', 'when_recorded_mail_to_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_name', 'servicer_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_street1', 'servicer_address_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_street2', 'servicer_address_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_city', 'servicer_address_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_state', 'servicer_address_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_postal_code', 'servicer_address_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicer_address_country_code', 'servicer_address_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_name', 'sub_servicer_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_street1', 'sub_servicer_address_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_street2', 'sub_servicer_address_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_city', 'sub_servicer_address_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_state', 'sub_servicer_address_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_postal_code', 'sub_servicer_address_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_address_country_code', 'sub_servicer_address_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'sub_servicer_mers_org_id', 'sub_servicer_mers_org_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_name', 'file_delivery_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_street1', 'file_delivery_address_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_50 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_street2', 'file_delivery_address_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_51 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_city', 'file_delivery_address_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_52 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_state', 'file_delivery_address_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_53 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_postal_code', 'file_delivery_address_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_54 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'file_delivery_address_country_code', 'file_delivery_address_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_55 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'initial_beneficiary_candidate_flag', 'initial_beneficiary_candidate_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_56 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'initial_servicer_candidate_flag', 'initial_servicer_candidate_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_57 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_org_member', 'mers_org_member', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_58 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_org_id', 'mers_org_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_59 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'allonge_transfer_to_name', 'allonge_transfer_to_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_60 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lock_expiration_delivery_subtrahend_days', 'lock_expiration_delivery_subtrahend_days', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_61 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_country_code', 'loss_payee_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_62 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_city', 'loss_payee_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_63 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_name', 'loss_payee_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_64 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_pid', 'investor_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_65 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_id', 'investor_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_66 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'website_url', 'website_url', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_67 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_name', 'investor_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_68 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_city', 'investor_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_69 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_city', 'when_recorded_mail_to_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_70 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'maximum_lock_extensions_allowed', 'maximum_lock_extensions_allowed', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_71 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'maximum_lock_extension_days_allowed', 'maximum_lock_extension_days_allowed', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_72 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mortech_investor_id', 'mortech_investor_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_73 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnma_servicer_id', 'fnma_servicer_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_74 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_file_delivery_method_code', 'loan_file_delivery_method_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_75 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mbs_investor_flag', 'mbs_investor_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_76 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_hmda_purchaser_of_loan_code', 'investor_hmda_purchaser_of_loan_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_77 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_lock_disable_time', 'investor_lock_disable_time', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_78 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'allows_weekend_holiday_locks_flag', 'allows_weekend_holiday_locks_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_79 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'nmls_id', 'nmls_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_80 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'nmls_id_applicable', 'nmls_id_applicable', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_81 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_investor_remittance_code', 'fnm_investor_remittance_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_82 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_mbs_investor_remittance_day_of_month', 'fnm_mbs_investor_remittance_day_of_month', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_83 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_mbs_loan_default_loss_party_code', 'fnm_mbs_loan_default_loss_party_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_84 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_mbs_reo_marketing_party_code', 'fnm_mbs_reo_marketing_party_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_85 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'offers_secondary_financing_flag', 'offers_secondary_financing_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_86 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_street2', 'beneficiary_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_87 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_street1', 'beneficiary_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_88 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_state', 'beneficiary_state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_89 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_postal_code', 'beneficiary_postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_90 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_country_code', 'beneficiary_country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_91 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_city', 'beneficiary_city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_92 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_street1', 'loss_payee_street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_93 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_street2', 'loss_payee_street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_94 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'beneficiary_name', 'beneficiary_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_95 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loss_payee_assignee_name', 'loss_payee_assignee_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_96 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'when_recorded_mail_to_name', 'when_recorded_mail_to_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_97 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_hmda_purchaser_of_loan', 'investor_hmda_purchaser_of_loan', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_98 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_file_delivery_method', 'loan_file_delivery_method', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'country_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'country_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_8 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fnm_investor_remittance_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fnm_investor_remittance_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_9 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fnm_mbs_loan_default_loss_party_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fnm_mbs_loan_default_loss_party_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_10 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fnm_mbs_reo_marketing_party_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fnm_mbs_reo_marketing_party_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_11 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'gift_funds_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'gift_funds_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_12 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'investor'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'investor') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_90 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'investor_hmda_purchaser_of_loan_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'investor_hmda_purchaser_of_loan_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_91 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_file_delivery_method_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_file_delivery_method_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.investor_dim (SP-200009)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.lender_user_dim (SP-200010)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200010', 'Dimension ETL to populate lender_user_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''lender_user_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.lu_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.lender_user current_record
        LEFT JOIN history_octane.lender_user AS history_records ON current_record.lu_pid = history_records.lu_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.country_type current_record
                LEFT JOIN history_octane.country_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t454 ON primary_table.lu_country = t454.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_bureau_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.credit_bureau_type current_record
                LEFT JOIN history_octane.credit_bureau_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t455 ON primary_table.lu_default_credit_bureau_type = t455.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.lender_user_status_type current_record
                LEFT JOIN history_octane.lender_user_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t456 ON primary_table.lu_lender_user_status_type = t456.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.lender_user_type current_record
                LEFT JOIN history_octane.lender_user_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t457 ON primary_table.lu_lender_user_type = t457.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<time_zone_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.time_zone_type current_record
                LEFT JOIN history_octane.time_zone_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t458 ON primary_table.lu_time_zone = t458.code
 WHERE
    GREATEST(primary_table.include_record, t454.include_record, t455.include_record, t456.include_record, t457.include_record, t458.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'lender_user_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'country', 'country', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'default_credit_bureau', 'default_credit_bureau', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'username', 'username', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'nmls_loan_originator_id', 'nmls_loan_originator_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_chums_id', 'fha_chums_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'va_agent_id', 'va_agent_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'search_text', 'search_text', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'company_user_id', 'company_user_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'force_password_change_flag', 'force_password_change_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'last_password_change_datetime', 'last_password_change_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'allow_external_ip_flag', 'allow_external_ip_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'total_workload_cap', 'total_workload_cap', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'schedule_once_booking_page_id', 'schedule_once_booking_page_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'esign_only_flag', 'esign_only_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'work_step_start_notices_enabled_flag', 'work_step_start_notices_enabled_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'smart_app_enabled_flag', 'smart_app_enabled_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'default_credit_bureau_code', 'default_credit_bureau_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'originator_id', 'originator_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'name_qualifier', 'name_qualifier', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'training_mode_flag', 'training_mode_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'about_me', 'about_me', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'type_code', 'type_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hire_date', 'hire_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'nickname', 'nickname', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'preferred_first_name', 'preferred_first_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hub_directory_flag', 'hub_directory_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_user_pid', 'lender_user_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'account_owner_flag', 'account_owner_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'create_date', 'create_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'first_name', 'first_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'last_name', 'last_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'middle_name', 'middle_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'name_suffix', 'name_suffix', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'company_name', 'company_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'title', 'title', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone', 'office_phone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone_extension', 'office_phone_extension', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'email', 'email', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fax', 'fax', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'city', 'city', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'country_code', 'country_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'postal_code', 'postal_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_50 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'state', 'state', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_51 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'street1', 'street1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_52 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'street2', 'street2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_53 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'office_phone_use_branch_flag', 'office_phone_use_branch_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_54 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fax_use_branch_flag', 'fax_use_branch_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_55 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'address_use_branch_flag', 'address_use_branch_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_56 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'start_date', 'start_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_57 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'through_date', 'through_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_58 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'time_zone_code', 'time_zone_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_59 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'unparsed_name', 'unparsed_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_60 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'status_code', 'status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_61 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'status', 'status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_62 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'type', 'type', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_63 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'time_zone', 'time_zone', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'country_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'country_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'credit_bureau_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'credit_bureau_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'lender_user'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'lender_user') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_54 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'lender_user_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'lender_user_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_55 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'lender_user_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'lender_user_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_56 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'time_zone_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'time_zone_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.lender_user_dim (SP-200010)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.loan_beneficiary_dim (SP-200011)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200011', 'Dimension ETL to populate loan_beneficiary_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''loan_beneficiary_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.lb_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.loan_beneficiary current_record
        LEFT JOIN history_octane.loan_beneficiary AS history_records ON current_record.lb_pid = history_records.lb_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lb_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<courier_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.courier_type current_record
                LEFT JOIN history_octane.courier_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t347 ON primary_table.lb_collateral_courier_type = t347.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<courier_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.courier_type current_record
                LEFT JOIN history_octane.courier_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t351 ON primary_table.lb_loan_file_courier_type = t351.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<delivery_aus_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.delivery_aus_type current_record
                LEFT JOIN history_octane.delivery_aus_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t348 ON primary_table.lb_delivery_aus_type = t348.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<loan_benef_transfer_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.loan_benef_transfer_status_type current_record
                LEFT JOIN history_octane.loan_benef_transfer_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t350 ON primary_table.lb_loan_benef_transfer_status_type = t350.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<loan_file_delivery_method_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.loan_file_delivery_method_type current_record
                LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t352 ON primary_table.lb_loan_file_delivery_method_type = t352.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mers_transfer_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mers_transfer_status_type current_record
                LEFT JOIN history_octane.mers_transfer_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t353 ON primary_table.lb_mers_transfer_status_type = t353.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t349 ON primary_table.lb_early_funding = t349.code
 WHERE
    GREATEST(primary_table.include_record, t347.include_record, t351.include_record, t348.include_record, t350.include_record, t352.include_record, t353.include_record, t349.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'loan_beneficiary_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'collateral_courier', 'collateral_courier', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_file_courier', 'loan_file_courier', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'delivery_aus', 'delivery_aus', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_mom_flag', 'mers_mom_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_beneficiary_pid', 'loan_beneficiary_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_transfer_status_code', 'mers_transfer_status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_transfer_override_flag', 'mers_transfer_override_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_file_courier_code', 'loan_file_courier_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'collateral_courier_code', 'collateral_courier_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_pid', 'loan_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'delivery_aus_code', 'delivery_aus_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'early_funding_code', 'early_funding_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'pool_id', 'pool_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_file_delivery_method_code', 'loan_file_delivery_method_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'transfer_status_code', 'transfer_status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'initial_flag', 'initial_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'current_flag', 'current_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_loan_id', 'investor_loan_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'transfer_status', 'transfer_status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_file_delivery_method', 'loan_file_delivery_method', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mers_transfer_status', 'mers_transfer_status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'early_funding', 'early_funding', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'courier_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'courier_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'delivery_aus_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'delivery_aus_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_4 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_beneficiary'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_beneficiary') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_19 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_benef_transfer_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_benef_transfer_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_20 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_file_delivery_method_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_file_delivery_method_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_21 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mers_transfer_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mers_transfer_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_22 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_unknown_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_unknown_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.loan_beneficiary_dim (SP-200011)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.loan_dim (SP-200012)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200012', 'Dimension ETL to populate loan_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''loan_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.l_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        CASE WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN t1317.d_los_loan_id_main ELSE t1317.d_los_loan_id_piggyback END as los_loan_number
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.loan current_record
        LEFT JOIN history_octane.loan AS history_records ON current_record.l_pid = history_records.l_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT
            current_record.*
            FROM history_octane.proposal current_record
                LEFT JOIN history_octane.proposal AS history_records ON current_record.prp_pid = history_records.prp_pid
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.prp_pid IS NULL
        ) as primary_table

                -- child join start
                INNER JOIN
                (
                    SELECT
                    <<deal_partial_load_condition>> as include_record,
                        current_record.*
                    FROM
                        history_octane.deal current_record
                            LEFT JOIN history_octane.deal AS history_records ON current_record.d_pid = history_records.d_pid
                                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
                    WHERE
                        history_records.d_pid IS NULL
                ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
                -- child join end

    ) AS t1317 ON primary_table.l_proposal_pid = t1317.prp_pid
 WHERE
    GREATEST(primary_table.include_record, t1317.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'loan_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'last_unprocessed_changes_datetime', 'last_unprocessed_changes_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'locked_price_change_percent', 'locked_price_change_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_requirement_ltv_ratio_percent', 'mi_requirement_ltv_ratio_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'base_loan_amount_ltv_ratio_percent', 'base_loan_amount_ltv_ratio_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_index_current_value_percent', 'arm_index_current_value_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_index_datetime', 'arm_index_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_terms_pid', 'product_terms_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'proposal_pid', 'proposal_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_pid', 'loan_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fhac_case_assignment_messages', 'fhac_case_assignment_messages', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_choice_datetime', 'product_choice_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_mbs_investor_contract_id', 'fnm_mbs_investor_contract_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'base_guaranty_fee_percent', 'base_guaranty_fee_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'guaranty_fee_percent', 'guaranty_fee_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'guaranty_fee_after_alternate_payment_method_percent', 'guaranty_fee_after_alternate_payment_method_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_investor_product_plan_id', 'fnm_investor_product_plan_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'uldd_loan_comment', 'uldd_loan_comment', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hmda_rate_spread_percent', 'hmda_rate_spread_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hoepa_apr', 'hoepa_apr', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hoepa_rate_spread', 'hoepa_rate_spread', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'rate_sheet_undiscounted_rate_percent', 'rate_sheet_undiscounted_rate_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'effective_undiscounted_rate_percent', 'effective_undiscounted_rate_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_31 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'proposal'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'proposal') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.loan_dim (SP-200012)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.loan_funding_dim (SP-200013)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200013', 'Dimension ETL to populate loan_funding_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''loan_funding_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.lf_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        primary_table.lf_funds_authorization_code as funds_authorization_code
 FROM (
    SELECT
        <<loan_funding_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.loan_funding current_record
        LEFT JOIN history_octane.loan_funding AS history_records ON current_record.lf_pid = history_records.lf_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lf_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<courier_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.courier_type current_record
                LEFT JOIN history_octane.courier_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t380 ON primary_table.lf_collateral_courier_type = t380.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<funding_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.funding_status_type current_record
                LEFT JOIN history_octane.funding_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t381 ON primary_table.lf_funding_status_type = t381.code
 WHERE
    GREATEST(primary_table.include_record, t380.include_record, t381.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'loan_funding_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'collateral_courier', 'collateral_courier', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'funding_status', 'funding_status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'release_wire_federal_reference_number', 'release_wire_federal_reference_number', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'interim_funder_fee_amount', 'interim_funder_fee_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'wire_amount', 'wire_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'funding_confirmed_release_datetime', 'funding_confirmed_release_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'funding_status_code', 'funding_status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'interim_funder_loan_id', 'interim_funder_loan_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_funding_pid', 'loan_funding_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_pid', 'loan_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'interim_funder_pid', 'interim_funder_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'early_wire_request_flag', 'early_wire_request_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'scheduled_release_date_auto_compute_flag', 'scheduled_release_date_auto_compute_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'early_wire_total_charge_amount', 'early_wire_total_charge_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'early_wire_daily_charge_amount', 'early_wire_daily_charge_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'early_wire_charge_day_count', 'early_wire_charge_day_count', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'net_wire_amount', 'net_wire_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'post_wire_adjustment_amount', 'post_wire_adjustment_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'collateral_courier_code', 'collateral_courier_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'funds_authorized_datetime', 'funds_authorized_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'funds_authorization_code', 'funds_authorization_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'courier_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'courier_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'funding_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'funding_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_funding'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_funding') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.loan_funding_dim (SP-200013)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.loan_junk_dim (SP-200014)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200014', 'Dimension ETL to populate loan_junk_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''buydown_contributor'' || ''~'' || ''fha_program'' || ''~'' || ''hmda_hoepa_status'' || ''~'' || ''lien_priority'' || ''~'' || ''lender_concession_candidate_flag'' || ''~'' || ''durp_eligibility_opt_out_flag'' || ''~'' || ''qualified_mortgage_status_code'' || ''~'' || ''qualified_mortgage_flag'' || ''~'' || ''lqa_purchase_eligibility_code'' || ''~'' || ''student_loan_cash_out_refinance_flag'' || ''~'' || ''secondary_clear_to_commit_flag'' || ''~'' || ''qm_eligible_flag'' || ''~'' || ''hpml_flag'' || ''~'' || ''lien_priority_code'' || ''~'' || ''buydown_contributor_code'' || ''~'' || ''qualifying_rate_code'' || ''~'' || ''fha_program_code'' || ''~'' || ''fha_principal_write_down_flag'' || ''~'' || ''texas_equity_code'' || ''~'' || ''texas_equity_auto_code'' || ''~'' || ''hmda_hoepa_status_code'' || ''~'' || ''lqa_purchase_eligibility'' || ''~'' || ''mi_required_flag'' || ''~'' || ''qualified_mortgage_status'' || ''~'' || ''qualifying_rate'' || ''~'' || ''texas_equity_auto'' || ''~'' || ''texas_equity'' || ''~'' || ''piggyback_flag'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(t460.value as text)  || ''~'' || CAST(t462.value as text)  || ''~'' || CAST(t463.value as text)  || ''~'' || CAST(t467.value as text)  || ''~'' || CAST(primary_table.l_lender_concession_candidate as text)  || ''~'' || CAST(primary_table.l_durp_eligibility_opt_out as text)  || ''~'' || CAST(primary_table.l_qualified_mortgage_status_type as text)  || ''~'' || CAST(primary_table.l_qualified_mortgage as text)  || ''~'' || CAST(primary_table.l_lqa_purchase_eligibility_type as text)  || ''~'' || CAST(primary_table.l_student_loan_cash_out_refinance as text)  || ''~'' || CAST(primary_table.l_secondary_clear_to_commit as text)  || ''~'' || CAST(primary_table.l_qm_eligible as text)  || ''~'' || CAST(primary_table.l_hpml as text)  || ''~'' || CAST(primary_table.l_lien_priority_type as text)  || ''~'' || CAST(primary_table.l_buydown_contributor_type as text)  || ''~'' || CAST(primary_table.l_qualifying_rate_type as text)  || ''~'' || CAST(primary_table.l_fha_program_code_type as text)  || ''~'' || CAST(primary_table.l_fha_principal_write_down as text)  || ''~'' || CAST(primary_table.l_texas_equity as text)  || ''~'' || CAST(primary_table.l_texas_equity_auto as text)  || ''~'' || CAST(primary_table.l_hmda_hoepa_status_type as text)  || ''~'' || CAST(t469.value as text)  || ''~'' || CAST(t1317.prp_mi_required as text)  || ''~'' || CAST(t481.value as text)  || ''~'' || CAST(t482.value as text)  || ''~'' || CAST(t484.value as text)  || ''~'' || CAST(t483.value as text)  || ''~'' || CAST(CASE WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE ELSE TRUE END as text) || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        CASE WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE ELSE TRUE END as piggyback_flag
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.loan current_record
        LEFT JOIN history_octane.loan AS history_records ON current_record.l_pid = history_records.l_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<buydown_contributor_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.buydown_contributor_type current_record
                LEFT JOIN history_octane.buydown_contributor_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t460 ON primary_table.l_buydown_contributor_type = t460.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fha_program_code_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fha_program_code_type current_record
                LEFT JOIN history_octane.fha_program_code_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t462 ON primary_table.l_fha_program_code_type = t462.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<hmda_hoepa_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.hmda_hoepa_status_type current_record
                LEFT JOIN history_octane.hmda_hoepa_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t463 ON primary_table.l_hmda_hoepa_status_type = t463.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lien_priority_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.lien_priority_type current_record
                LEFT JOIN history_octane.lien_priority_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t467 ON primary_table.l_lien_priority_type = t467.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lqa_purchase_eligibility_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.lqa_purchase_eligibility_type current_record
                LEFT JOIN history_octane.lqa_purchase_eligibility_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t469 ON primary_table.l_lqa_purchase_eligibility_type = t469.code

    INNER JOIN (
        SELECT * FROM (
            SELECT
            current_record.*
            FROM history_octane.proposal current_record
                LEFT JOIN history_octane.proposal AS history_records ON current_record.prp_pid = history_records.prp_pid
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.prp_pid IS NULL
        ) as primary_table

                -- child join start
                INNER JOIN
                (
                    SELECT
                    <<deal_partial_load_condition>> as include_record,
                        current_record.*
                    FROM
                        history_octane.deal current_record
                            LEFT JOIN history_octane.deal AS history_records ON current_record.d_pid = history_records.d_pid
                                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
                    WHERE
                        history_records.d_pid IS NULL
                ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
                -- child join end

    ) AS t1317 ON primary_table.l_proposal_pid = t1317.prp_pid

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<qualified_mortgage_status_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.qualified_mortgage_status_type current_record
                LEFT JOIN history_octane.qualified_mortgage_status_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t481 ON primary_table.l_qualified_mortgage_status_type = t481.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<qualifying_rate_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.qualifying_rate_type current_record
                LEFT JOIN history_octane.qualifying_rate_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t482 ON primary_table.l_qualifying_rate_type = t482.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_na_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_na_type current_record
                LEFT JOIN history_octane.yes_no_na_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t484 ON primary_table.l_texas_equity_auto = t484.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t483 ON primary_table.l_texas_equity = t483.code
        -- ignoring this because the table alias t1317 has already been added: INNER JOIN history_octane.proposal t1317 ON primary_table.l_proposal_pid = t1317.prp_pid
 WHERE
    GREATEST(primary_table.include_record, t460.include_record, t462.include_record, t463.include_record, t467.include_record, t469.include_record, t1317.include_record, t481.include_record, t482.include_record, t484.include_record, t483.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'loan_junk_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_contributor', 'buydown_contributor', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_program', 'fha_program', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hmda_hoepa_status', 'hmda_hoepa_status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lien_priority', 'lien_priority', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_concession_candidate_flag', 'lender_concession_candidate_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'durp_eligibility_opt_out_flag', 'durp_eligibility_opt_out_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualified_mortgage_status_code', 'qualified_mortgage_status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualified_mortgage_flag', 'qualified_mortgage_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lqa_purchase_eligibility_code', 'lqa_purchase_eligibility_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'student_loan_cash_out_refinance_flag', 'student_loan_cash_out_refinance_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'secondary_clear_to_commit_flag', 'secondary_clear_to_commit_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qm_eligible_flag', 'qm_eligible_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hpml_flag', 'hpml_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lien_priority_code', 'lien_priority_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_contributor_code', 'buydown_contributor_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_rate_code', 'qualifying_rate_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_program_code', 'fha_program_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_principal_write_down_flag', 'fha_principal_write_down_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'texas_equity_code', 'texas_equity_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'texas_equity_auto_code', 'texas_equity_auto_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'hmda_hoepa_status_code', 'hmda_hoepa_status_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lqa_purchase_eligibility', 'lqa_purchase_eligibility', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_required_flag', 'mi_required_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualified_mortgage_status', 'qualified_mortgage_status', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_rate', 'qualifying_rate', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'texas_equity_auto', 'texas_equity_auto', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'texas_equity', 'texas_equity', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'buydown_contributor_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'buydown_contributor_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fha_program_code_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fha_program_code_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'hmda_hoepa_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'hmda_hoepa_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_4 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'lien_priority_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'lien_priority_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_5 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_22 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'lqa_purchase_eligibility_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'lqa_purchase_eligibility_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_23 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'proposal'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'proposal') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_24 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'qualified_mortgage_status_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'qualified_mortgage_status_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_25 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'qualifying_rate_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'qualifying_rate_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_26 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_na_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_na_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_27 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_unknown_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_unknown_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.loan_junk_dim (SP-200014)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.mortgage_insurance_dim (SP-200015)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200015', 'Dimension ETL to populate mortgage_insurance_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''loan_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.l_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.loan current_record
        LEFT JOIN history_octane.loan AS history_records ON current_record.l_pid = history_records.l_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_calculated_rate_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_calculated_rate_type current_record
                LEFT JOIN history_octane.mi_calculated_rate_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t471 ON primary_table.l_mi_initial_calculated_rate_type = t471.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_calculated_rate_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_calculated_rate_type current_record
                LEFT JOIN history_octane.mi_calculated_rate_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t477 ON primary_table.l_mi_renewal_calculated_rate_type = t477.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_company_name_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_company_name_type current_record
                LEFT JOIN history_octane.mi_company_name_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t470 ON primary_table.l_mi_company_name_type = t470.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_initial_calculation_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_initial_calculation_type current_record
                LEFT JOIN history_octane.mi_initial_calculation_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t472 ON primary_table.l_mi_initial_calculation_type = t472.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_input_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_input_type current_record
                LEFT JOIN history_octane.mi_input_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t473 ON primary_table.l_mi_input_type = t473.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_payer_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_payer_type current_record
                LEFT JOIN history_octane.mi_payer_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t474 ON primary_table.l_mi_payer_type = t474.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_payment_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_payment_type current_record
                LEFT JOIN history_octane.mi_payment_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t475 ON primary_table.l_mi_payment_type = t475.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_premium_refundable_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_premium_refundable_type current_record
                LEFT JOIN history_octane.mi_premium_refundable_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t476 ON primary_table.l_mi_premium_refundable_type = t476.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_renewal_calculation_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mi_renewal_calculation_type current_record
                LEFT JOIN history_octane.mi_renewal_calculation_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
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
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'mortgage_insurance_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_rate_quote_id', 'mi_rate_quote_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_base_upfront_payment_amount', 'mi_base_upfront_payment_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_base_monthly_payment_amount', 'mi_base_monthly_payment_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_base_upfront_percent', 'mi_base_upfront_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_base_monthly_payment_annual_percent', 'mi_base_monthly_payment_annual_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_base_rate_label', 'mi_base_rate_label', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_renewal_calculated_rate_code', 'mi_renewal_calculated_rate_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_calculated_rate_code', 'mi_initial_calculated_rate_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_monthly_payment_annual_percent', 'mi_initial_monthly_payment_annual_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_duration_months', 'mi_initial_duration_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_renewal_monthly_payment_amount', 'mi_renewal_monthly_payment_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_renewal_monthly_payment_annual_percent', 'mi_renewal_monthly_payment_annual_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_monthly_payment_amount', 'mi_initial_monthly_payment_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_upront_percent', 'mi_upront_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_upfront_amount', 'mi_upfront_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_payment_code', 'mi_payment_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_actual_monthly_payment_count', 'mi_actual_monthly_payment_count', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_required_monthly_payment_count', 'mi_required_monthly_payment_count', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_midpoint_cutoff_required_flag', 'mi_midpoint_cutoff_required_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_ltv_cutoff_percent', 'mi_ltv_cutoff_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_coverage_percent', 'mi_coverage_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_payer_code', 'mi_payer_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_renewal_calculation_code', 'mi_renewal_calculation_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_calculation_code', 'mi_initial_calculation_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_premium_refundable_code', 'mi_premium_refundable_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_certificate_id', 'mi_certificate_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_company_code', 'mi_company_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_input_code', 'mi_input_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'no_mi_product_flag', 'no_mi_product_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_auto_compute_flag', 'mi_auto_compute_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_pid', 'loan_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_lender_paid_rate_adjustment_percent', 'mi_lender_paid_rate_adjustment_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_calculated_rate', 'mi_initial_calculated_rate', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_renewal_calcuated_rate', 'mi_renewal_calcuated_rate', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_company', 'mi_company', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_initial_calculation', 'mi_initial_calculation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_input', 'mi_input', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_payer', 'mi_payer', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_payment', 'mi_payment', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_premium_refundable', 'mi_premium_refundable', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_renewal_calculation', 'mi_renewal_calculation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_dwid', 'loan_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_33 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_calculated_rate_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_calculated_rate_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_35 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_company_name_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_company_name_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_36 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_initial_calculation_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_initial_calculation_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_37 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_input_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_input_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_38 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_payer_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_payer_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_39 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_payment_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_payment_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_40 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_premium_refundable_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_premium_refundable_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_41 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mi_renewal_calculation_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mi_renewal_calculation_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_42 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'star_loan'
                AND table_output_step.target_table = 'loan_dim'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'star_loan'
                AND insert_update_step.table_name = 'loan_dim') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.mortgage_insurance_dim (SP-200015)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.product_choice_dim (SP-200016)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200016', 'Dimension ETL to populate product_choice_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''aus'' || ''~'' || ''buydown_schedule'' || ''~'' || ''interest_only'' || ''~'' || ''aus_code'' || ''~'' || ''prepay_penatly_schedule_code'' || ''~'' || ''buydown_schedule_code'' || ''~'' || ''interest_only_code'' || ''~'' || ''mortgage_type_code'' || ''~'' || ''mortgage_type'' || ''~'' || ''prepay_penalty_schedule'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(t459.value as text)  || ''~'' || CAST(t461.value as text)  || ''~'' || CAST(t466.value as text)  || ''~'' || CAST(primary_table.l_aus_type as text)  || ''~'' || CAST(primary_table.l_prepay_penalty_schedule_type as text)  || ''~'' || CAST(primary_table.l_buydown_schedule_type as text)  || ''~'' || CAST(primary_table.l_interest_only_type as text)  || ''~'' || CAST(primary_table.l_mortgage_type as text)  || ''~'' || CAST(t479.value as text)  || ''~'' || CAST(t480.value as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.loan current_record
        LEFT JOIN history_octane.loan AS history_records ON current_record.l_pid = history_records.l_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<aus_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.aus_type current_record
                LEFT JOIN history_octane.aus_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t459 ON primary_table.l_aus_type = t459.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<buydown_schedule_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.buydown_schedule_type current_record
                LEFT JOIN history_octane.buydown_schedule_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t461 ON primary_table.l_buydown_schedule_type = t461.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<interest_only_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.interest_only_type current_record
                LEFT JOIN history_octane.interest_only_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t466 ON primary_table.l_interest_only_type = t466.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mortgage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mortgage_type current_record
                LEFT JOIN history_octane.mortgage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t479 ON primary_table.l_mortgage_type = t479.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prepay_penalty_schedule_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.prepay_penalty_schedule_type current_record
                LEFT JOIN history_octane.prepay_penalty_schedule_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t480 ON primary_table.l_prepay_penalty_schedule_type = t480.code
 WHERE
    GREATEST(primary_table.include_record, t459.include_record, t461.include_record, t466.include_record, t479.include_record, t480.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'product_choice_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'aus', 'aus', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_schedule', 'buydown_schedule', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'interest_only', 'interest_only', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'aus_code', 'aus_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepay_penatly_schedule_code', 'prepay_penatly_schedule_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_schedule_code', 'buydown_schedule_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'interest_only_code', 'interest_only_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mortgage_type_code', 'mortgage_type_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mortgage_type', 'mortgage_type', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepay_penalty_schedule', 'prepay_penalty_schedule', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'aus_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'aus_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'buydown_schedule_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'buydown_schedule_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'interest_only_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'interest_only_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_4 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_9 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mortgage_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mortgage_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_10 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'prepay_penalty_schedule_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'prepay_penalty_schedule_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.product_choice_dim (SP-200016)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.product_dim (SP-200017)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200017', 'Dimension ETL to populate product_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''product_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.p_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.product current_record
        LEFT JOIN history_octane.product AS history_records ON current_record.p_pid = history_records.p_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.p_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fund_source_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fund_source_type current_record
                LEFT JOIN history_octane.fund_source_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t755 ON primary_table.p_fund_source_type = t755.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<product_side_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.product_side_type current_record
                LEFT JOIN history_octane.product_side_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t756 ON primary_table.p_product_side_type = t756.code
 WHERE
    GREATEST(primary_table.include_record, t755.include_record, t756.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'product_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fund_source', 'fund_source', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_pid', 'product_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'description', 'description', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lock_auto_confirm_flag', 'lock_auto_confirm_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_product_name', 'fnm_product_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'through_date', 'through_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'from_date', 'from_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_product_name', 'investor_product_name', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_product_id', 'investor_product_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fund_source_code', 'fund_source_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_side_code', 'product_side_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'investor_pid', 'investor_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_side', 'product_side', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fund_source_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fund_source_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'product'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'product') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_13 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'product_side_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'product_side_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.product_dim (SP-200017)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.product_terms_dim (SP-200018)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200018', 'Dimension ETL to populate product_terms_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''product_terms_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.pt_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
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
        current_record.*
    FROM history_octane.product_terms current_record
        LEFT JOIN history_octane.product_terms AS history_records ON current_record.pt_pid = history_records.pt_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.pt_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<arm_index_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.arm_index_type current_record
                LEFT JOIN history_octane.arm_index_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t715 ON primary_table.pt_arm_index_type = t715.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<buydown_base_date_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.buydown_base_date_type current_record
                LEFT JOIN history_octane.buydown_base_date_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t717 ON primary_table.pt_buydown_base_date_type = t717.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<buydown_subsidy_calculation_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.buydown_subsidy_calculation_type current_record
                LEFT JOIN history_octane.buydown_subsidy_calculation_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t718 ON primary_table.pt_buydown_subsidy_calculation_type = t718.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<community_lending_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.community_lending_type current_record
                LEFT JOIN history_octane.community_lending_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t719 ON primary_table.pt_community_lending_type = t719.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<days_per_year_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.days_per_year_type current_record
                LEFT JOIN history_octane.days_per_year_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t720 ON primary_table.pt_days_per_year_type = t720.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<decision_credit_score_calc_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.decision_credit_score_calc_type current_record
                LEFT JOIN history_octane.decision_credit_score_calc_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t721 ON primary_table.pt_decision_credit_score_calc_type = t721.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fha_rehab_program_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fha_rehab_program_type current_record
                LEFT JOIN history_octane.fha_rehab_program_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t722 ON primary_table.pt_fha_rehab_program_type = t722.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fha_special_program_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fha_special_program_type current_record
                LEFT JOIN history_octane.fha_special_program_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t723 ON primary_table.pt_fha_special_program_type = t723.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_arm_plan_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fnm_arm_plan_type current_record
                LEFT JOIN history_octane.fnm_arm_plan_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t724 ON primary_table.pt_fnm_arm_plan_type = t724.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_community_lending_product_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fnm_community_lending_product_type current_record
                LEFT JOIN history_octane.fnm_community_lending_product_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t725 ON primary_table.pt_fnm_community_lending_product_type = t725.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fre_community_program_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.fre_community_program_type current_record
                LEFT JOIN history_octane.fre_community_program_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t726 ON primary_table.pt_fre_community_program_type = t726.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<heloc_cancel_fee_applicable_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.heloc_cancel_fee_applicable_type current_record
                LEFT JOIN history_octane.heloc_cancel_fee_applicable_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t727 ON primary_table.pt_heloc_cancel_fee_applicable_type = t727.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_calc_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_calc_type current_record
                LEFT JOIN history_octane.ipc_calc_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t729 ON primary_table.pt_ipc_calc_type = t729.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_comparison_operator_type current_record
                LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t732 ON primary_table.pt_ipc_comparison_operator_type3 = t732.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_comparison_operator_type current_record
                LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t730 ON primary_table.pt_ipc_comparison_operator_type1 = t730.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_comparison_operator_type current_record
                LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t731 ON primary_table.pt_ipc_comparison_operator_type2 = t731.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_comparison_operator_type current_record
                LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t733 ON primary_table.pt_ipc_comparison_operator_type4 = t733.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_property_usage_type current_record
                LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t736 ON primary_table.pt_ipc_property_usage_type3 = t736.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_property_usage_type current_record
                LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t734 ON primary_table.pt_ipc_property_usage_type1 = t734.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_property_usage_type current_record
                LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t735 ON primary_table.pt_ipc_property_usage_type2 = t735.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.ipc_property_usage_type current_record
                LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t737 ON primary_table.pt_ipc_property_usage_type4 = t737.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lien_priority_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.lien_priority_type current_record
                LEFT JOIN history_octane.lien_priority_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t738 ON primary_table.pt_lien_priority_type = t738.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<loan_amortization_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.loan_amortization_type current_record
                LEFT JOIN history_octane.loan_amortization_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t739 ON primary_table.pt_loan_amortization_type = t739.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mortgage_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.mortgage_type current_record
                LEFT JOIN history_octane.mortgage_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t740 ON primary_table.pt_mortgage_type = t740.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<negative_amortization_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.negative_amortization_type current_record
                LEFT JOIN history_octane.negative_amortization_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t741 ON primary_table.pt_negative_amortization_type = t741.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<partial_payment_policy_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.partial_payment_policy_type current_record
                LEFT JOIN history_octane.partial_payment_policy_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t742 ON primary_table.pt_partial_payment_policy_type = t742.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<payment_adjustment_calculation_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.payment_adjustment_calculation_type current_record
                LEFT JOIN history_octane.payment_adjustment_calculation_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t716 ON primary_table.pt_arm_payment_adjustment_calculation_type = t716.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<payment_frequency_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.payment_frequency_type current_record
                LEFT JOIN history_octane.payment_frequency_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t743 ON primary_table.pt_payment_frequency_type = t743.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<payment_structure_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.payment_structure_type current_record
                LEFT JOIN history_octane.payment_structure_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t744 ON primary_table.pt_payment_structure_type = t744.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prepaid_interest_rate_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.prepaid_interest_rate_type current_record
                LEFT JOIN history_octane.prepaid_interest_rate_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t745 ON primary_table.pt_prepaid_interest_rate_type = t745.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prepay_penalty_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.prepay_penalty_type current_record
                LEFT JOIN history_octane.prepay_penalty_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t746 ON primary_table.pt_prepay_penalty_type = t746.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<product_appraisal_requirement_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.product_appraisal_requirement_type current_record
                LEFT JOIN history_octane.product_appraisal_requirement_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t747 ON primary_table.pt_product_appraisal_requirement_type = t747.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<product_special_program_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.product_special_program_type current_record
                LEFT JOIN history_octane.product_special_program_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t748 ON primary_table.pt_product_special_program_type = t748.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<qualifying_monthly_payment_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.qualifying_monthly_payment_type current_record
                LEFT JOIN history_octane.qualifying_monthly_payment_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t749 ON primary_table.pt_qualifying_monthly_payment_type = t749.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<qualifying_rate_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.qualifying_rate_type current_record
                LEFT JOIN history_octane.qualifying_rate_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t750 ON primary_table.pt_qualifying_rate_type = t750.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<section_of_act_coarse_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.section_of_act_coarse_type current_record
                LEFT JOIN history_octane.section_of_act_coarse_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t751 ON primary_table.pt_section_of_act_coarse_type = t751.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<servicing_transfer_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.servicing_transfer_type current_record
                LEFT JOIN history_octane.servicing_transfer_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t752 ON primary_table.pt_servicing_transfer_type = t752.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<third_party_community_second_program_eligibility_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.third_party_community_second_program_eligibility_type current_record
                LEFT JOIN history_octane.third_party_community_second_program_eligibility_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t754 ON primary_table.pt_third_party_community_second_program_eligibility_type = t754.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.yes_no_unknown_type current_record
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t753 ON primary_table.pt_texas_veterans_land_board = t753.code
        -- ignoring this because the table alias t753 has already been added: INNER JOIN history_octane.yes_no_unknown_type t753 ON primary_table.pt_texas_veterans_land_board = t753.code
 WHERE
    GREATEST(primary_table.include_record, t715.include_record, t717.include_record, t718.include_record, t719.include_record, t720.include_record, t721.include_record, t722.include_record, t723.include_record, t724.include_record, t725.include_record, t726.include_record, t727.include_record, t729.include_record, t732.include_record, t730.include_record, t731.include_record, t733.include_record, t736.include_record, t734.include_record, t735.include_record, t737.include_record, t738.include_record, t739.include_record, t740.include_record, t741.include_record, t742.include_record, t716.include_record, t743.include_record, t744.include_record, t745.include_record, t746.include_record, t747.include_record, t748.include_record, t749.include_record, t750.include_record, t751.include_record, t752.include_record, t754.include_record, t753.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'product_terms_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_index', 'arm_index', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_base_date', 'buydown_base_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_subsidy_calculation', 'buydown_subsidy_calculation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'community_lending', 'community_lending', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'days_per_year', 'days_per_year', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'decision_credit_score_calc', 'decision_credit_score_calc', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_14 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_rehab_program', 'fha_rehab_program', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_15 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_special_program', 'fha_special_program', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_16 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_arm_plan', 'fnm_arm_plan', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_17 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_community_lending_product', 'fnm_community_lending_product', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_18 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fre_community_program', 'fre_community_program', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_19 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_cancel_fee_applicable', 'heloc_cancel_fee_applicable', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_20 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_calc', 'ipc_calc', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_21 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator3', 'ipc_comparison_operator3', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_22 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator1', 'ipc_comparison_operator1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_23 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator2', 'ipc_comparison_operator2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_24 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator4', 'ipc_comparison_operator4', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_25 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage3', 'ipc_property_usage3', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_26 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage1', 'ipc_property_usage1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_27 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage2', 'ipc_property_usage2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_28 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage4', 'ipc_property_usage4', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_29 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lien_priority', 'lien_priority', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_30 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_amortization', 'loan_amortization', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_31 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mortgage_type', 'mortgage_type', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_32 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'negative_amortization', 'negative_amortization', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_33 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'partial_payment_policy', 'partial_payment_policy', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_34 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_payment_adjustment_calculation', 'arm_payment_adjustment_calculation', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_35 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'payment_frequency', 'payment_frequency', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_36 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'payment_structure', 'payment_structure', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_37 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepaid_interest_rate', 'prepaid_interest_rate', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_38 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepay_penalty', 'prepay_penalty', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_39 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_appraisal_requirement', 'product_appraisal_requirement', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_40 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_special_program', 'product_special_program', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_41 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator_code3', 'ipc_comparison_operator_code3', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_42 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_cltv_ratio_percent3', 'ipc_cltv_ratio_percent3', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_43 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_limit_percent4', 'ipc_limit_percent4', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_44 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage_code4', 'ipc_property_usage_code4', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_45 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator_code4', 'ipc_comparison_operator_code4', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_46 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_cltv_ratio_percent4', 'ipc_cltv_ratio_percent4', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_47 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_base_date_code', 'buydown_base_date_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_48 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'buydown_subsidy_calculation_code', 'buydown_subsidy_calculation_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_49 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepaid_interest_rate_code', 'prepaid_interest_rate_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_50 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_arm_plan_code', 'fnm_arm_plan_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_51 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'dsi_plan_code', 'dsi_plan_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_52 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'credit_qualifying_flag', 'credit_qualifying_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_53 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_special_program_code', 'product_special_program_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_54 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'section_of_act_coarse_code', 'section_of_act_coarse_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_55 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_rehab_program_code', 'fha_rehab_program_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_56 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fha_special_program_code', 'fha_special_program_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_57 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'third_party_grant_eligible_flag', 'third_party_grant_eligible_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_58 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicing_transfer_code', 'servicing_transfer_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_59 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'no_mi_product_flag', 'no_mi_product_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_60 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mortgage_credit_certificate_eligible_flag', 'mortgage_credit_certificate_eligible_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_61 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fre_community_program_code', 'fre_community_program_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_62 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'fnm_community_lending_product_code', 'fnm_community_lending_product_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_63 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'zero_note_rate_flag', 'zero_note_rate_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_64 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'third_party_community_second_program_eligibility_code', 'third_party_community_second_program_eligibility_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_65 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'texas_veterans_land_board_code', 'texas_veterans_land_board_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_66 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'security_instrument_page_count', 'security_instrument_page_count', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_67 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'deed_page_count', 'deed_page_count', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_68 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'partial_payment_policy_code', 'partial_payment_policy_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_69 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'payment_structure_code', 'payment_structure_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_70 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'deferred_payment_months', 'deferred_payment_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_71 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'always_current_market_price_flag', 'always_current_market_price_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_72 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'rate_protect_flag', 'rate_protect_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_73 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'non_conforming_flag', 'non_conforming_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_74 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'allow_loan_amount_cents_flag', 'allow_loan_amount_cents_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_75 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_appraisal_requirement_code', 'product_appraisal_requirement_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_76 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'family_advantage_flag', 'family_advantage_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_77 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'community_lending_code', 'community_lending_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_78 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'high_balance_code', 'high_balance_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_79 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'decision_credit_score_calc_code', 'decision_credit_score_calc_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_80 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'new_york_flag', 'new_york_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_81 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'manual_risk_assessment_accepted_flag', 'manual_risk_assessment_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_82 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'external_fha_underwrite_accepted_flag', 'external_fha_underwrite_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_83 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'external_va_underwrite_accepted_flag', 'external_va_underwrite_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_84 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'external_usda_underwrite_accepted_flag', 'external_usda_underwrite_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_85 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'external_investor_underwrite_accepted_flag', 'external_investor_underwrite_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_86 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_cancel_fee_applicable_code', 'heloc_cancel_fee_applicable_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_87 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_cancel_fee_period_months', 'heloc_cancel_fee_period_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_88 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_cancel_fee_amount', 'heloc_cancel_fee_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_89 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_draw_period_months', 'heloc_draw_period_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_90 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_repayment_period_duration_months', 'heloc_repayment_period_duration_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_91 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_maximum_initial_draw_flag', 'heloc_maximum_initial_draw_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_92 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_maximum_initial_draw_amount', 'heloc_maximum_initial_draw_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_93 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_minimum_draw_flag', 'heloc_minimum_draw_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_94 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'heloc_minimum_draw_amount', 'heloc_minimum_draw_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_95 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'gpm_adjustment_years', 'gpm_adjustment_years', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_96 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'gpm_adjustment_percent', 'gpm_adjustment_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_97 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_monthly_payment_code', 'qualifying_monthly_payment_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_98 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_rate_code', 'qualifying_rate_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_99 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_rate_input_percent', 'qualifying_rate_input_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_100 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_calc_code', 'ipc_calc_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_101 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_limit_percent1', 'ipc_limit_percent1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_102 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage_code1', 'ipc_property_usage_code1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_103 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator_code1', 'ipc_comparison_operator_code1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_104 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_cltv_ratio_percent1', 'ipc_cltv_ratio_percent1', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_105 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_limit_percent2', 'ipc_limit_percent2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_106 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage_code2', 'ipc_property_usage_code2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_107 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_comparison_operator_code2', 'ipc_comparison_operator_code2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_108 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_cltv_ratio_percent2', 'ipc_cltv_ratio_percent2', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_109 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_limit_percent3', 'ipc_limit_percent3', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_110 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'ipc_property_usage_code3', 'ipc_property_usage_code3', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_111 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_terms_pid', 'product_terms_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_112 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'amortization_term_months', 'amortization_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_113 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_index_code', 'arm_index_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_114 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_payment_adjustment_calculation_code', 'arm_payment_adjustment_calculation_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_115 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'assumable_flag', 'assumable_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_116 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_category', 'product_category', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_117 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'conditions_to_assumability_flag', 'conditions_to_assumability_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_118 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'demand_feature_flag', 'demand_feature_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_119 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'due_in_term_months', 'due_in_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_120 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'escrow_cushion_months', 'escrow_cushion_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_121 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'from_date', 'from_date', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_122 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'initial_payment_adjustment_term_months', 'initial_payment_adjustment_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_123 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'initial_rate_adjustment_cap_percent', 'initial_rate_adjustment_cap_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_124 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'initial_rate_adjustment_term_months', 'initial_rate_adjustment_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_125 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lien_priority_code', 'lien_priority_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_126 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_amortization_code', 'loan_amortization_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_127 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'minimum_payment_rate_percent', 'minimum_payment_rate_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_128 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'minimum_rate_term_months', 'minimum_rate_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_129 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mortgage_type_code', 'mortgage_type_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_130 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'negative_amortization_code', 'negative_amortization_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_131 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'negative_amortization_limit_percent', 'negative_amortization_limit_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_132 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'negative_amortization_recast_period_months', 'negative_amortization_recast_period_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_133 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'payment_adjustment_lifetime_cap_percent', 'payment_adjustment_lifetime_cap_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_134 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'payment_adjustment_periodic_cap', 'payment_adjustment_periodic_cap', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_135 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'payment_frequency_code', 'payment_frequency_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_136 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepayment_charge_refund_flag', 'prepayment_charge_refund_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_137 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'product_pid', 'product_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_138 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'rate_adjustment_lifetime_cap_percent', 'rate_adjustment_lifetime_cap_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_139 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'subsequent_payment_adjustment_term_months', 'subsequent_payment_adjustment_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_140 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'subsequent_rate_adjustment_cap_percent', 'subsequent_rate_adjustment_cap_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_141 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'subsequent_rate_adjustment_term_months', 'subsequent_rate_adjustment_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_142 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'prepay_penalty_code', 'prepay_penalty_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_143 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_hazard_insurance_available_flag', 'lender_hazard_insurance_available_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_144 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_hazard_insurance_premium_amount', 'lender_hazard_insurance_premium_amount', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_145 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lender_hazard_insurance_term_months', 'lender_hazard_insurance_term_months', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_146 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_requires_hazard_insurance_flag', 'loan_requires_hazard_insurance_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_147 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_convertible_flag', 'arm_convertible_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_148 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_convertible_from_month', 'arm_convertible_from_month', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_149 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_convertible_through_month', 'arm_convertible_through_month', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_150 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_floor_rate_percent', 'arm_floor_rate_percent', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_151 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'arm_lookback_period_days', 'arm_lookback_period_days', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_152 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'escrow_waiver_allowed_flag', 'escrow_waiver_allowed_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_153 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'days_per_year_code', 'days_per_year_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_154 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'lp_risk_assessment_accepted_flag', 'lp_risk_assessment_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_155 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'du_risk_assessment_accepted_flag', 'du_risk_assessment_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_156 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'internal_underwrite_accepted_flag', 'internal_underwrite_accepted_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_157 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_monthly_payment', 'qualifying_monthly_payment', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_158 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'qualifying_rate', 'qualifying_rate', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_159 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'section_of_act_coarse', 'section_of_act_coarse', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_160 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'servicing_transfer', 'servicing_transfer', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_161 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'third_party_community_second_program_eligibility', 'third_party_community_second_program_eligibility', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_162 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'texas_veterans_land_board', 'texas_veterans_land_board', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_163 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'high_balance', 'high_balance', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'arm_index_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'arm_index_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'buydown_base_date_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'buydown_base_date_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'buydown_subsidy_calculation_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'buydown_subsidy_calculation_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_4 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'community_lending_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'community_lending_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_5 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'days_per_year_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'days_per_year_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_6 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'decision_credit_score_calc_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'decision_credit_score_calc_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_7 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fha_rehab_program_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fha_rehab_program_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_8 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fha_special_program_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fha_special_program_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_9 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fnm_arm_plan_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fnm_arm_plan_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_10 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fnm_community_lending_product_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fnm_community_lending_product_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_11 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'fre_community_program_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'fre_community_program_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_12 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'heloc_cancel_fee_applicable_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'heloc_cancel_fee_applicable_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_13 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'ipc_calc_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'ipc_calc_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_14 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'ipc_comparison_operator_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'ipc_comparison_operator_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_18 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'ipc_property_usage_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'ipc_property_usage_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_22 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'lien_priority_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'lien_priority_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_23 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_amortization_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_amortization_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_24 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'mortgage_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'mortgage_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_25 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'negative_amortization_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'negative_amortization_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_26 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'partial_payment_policy_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'partial_payment_policy_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_27 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'payment_adjustment_calculation_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'payment_adjustment_calculation_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_28 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'payment_frequency_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'payment_frequency_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_29 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'payment_structure_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'payment_structure_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_30 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'prepaid_interest_rate_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'prepaid_interest_rate_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_31 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'prepay_penalty_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'prepay_penalty_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_32 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'product_appraisal_requirement_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'product_appraisal_requirement_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_33 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'product_special_program_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'product_special_program_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_34 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'product_terms'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'product_terms') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_150 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'qualifying_monthly_payment_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'qualifying_monthly_payment_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_151 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'qualifying_rate_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'qualifying_rate_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_152 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'section_of_act_coarse_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'section_of_act_coarse_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_153 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'servicing_transfer_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'servicing_transfer_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_154 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'third_party_community_second_program_eligibility_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'third_party_community_second_program_eligibility_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_155 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'yes_no_unknown_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'yes_no_unknown_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.product_terms_dim (SP-200018)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.transaction_dim (SP-200019)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200019', 'Dimension ETL to populate transaction_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''deal_pid'' || ''~'' || ''active_proposal_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(t1441.d_pid as text)  || ''~'' || CAST(primary_table.prp_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t1441.d_pid as deal_pid,
        primary_table.prp_pid as active_proposal_pid
 FROM (
    SELECT
        <<proposal_partial_load_condition>> as include_record,
        current_record.*
    FROM history_octane.proposal current_record
        LEFT JOIN history_octane.proposal AS history_records ON current_record.prp_pid = history_records.prp_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<deal_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.deal current_record
                LEFT JOIN history_octane.deal AS history_records ON current_record.d_pid = history_records.d_pid
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.d_pid IS NULL
        ) as primary_table

    ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
 WHERE
    GREATEST(primary_table.include_record, t1441.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'transaction_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'deal_pid', 'deal_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'active_proposal_pid', 'active_proposal_pid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'deal'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'deal') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'proposal'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'proposal') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.transaction_dim (SP-200019)' as etl_creator_status;



-- The following statement adds an ETL configuration to populate star_loan.transaction_junk_dim (SP-200020)

WITH temp_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-200020', 'Dimension ETL to populate transaction_junk_dim from history_octane')
    RETURNING dwid)

    , temp_table_input_step as (INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, connectionname)   -- mdi.table_input_step
    select temp_process.dwid, 1, 'SELECT
        ''is_test_loan_flag'' || ''~'' || ''structure_code'' || ''~'' || ''mi_required_flag'' || ''~'' || ''structure'' || ''~'' || ''data_source_dwid'' || ''~'' || ''piggyback_flag'' as data_source_integration_columns,
        CAST(t1441.d_test_loan as text)  || ''~'' || CAST(primary_table.prp_structure_type as text)  || ''~'' || CAST(primary_table.prp_mi_required as text)  || ''~'' || CAST(t661.value as text)  || ''~'' || CAST(1 as text)  || ''~'' || CAST(primary_table.prp_structure_type = ''COMBO'' as text) as data_source_integration_id,
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
        current_record.*
    FROM history_octane.proposal current_record
        LEFT JOIN history_octane.proposal AS history_records ON current_record.prp_pid = history_records.prp_pid
            AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<deal_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.deal current_record
                LEFT JOIN history_octane.deal AS history_records ON current_record.d_pid = history_records.d_pid
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.d_pid IS NULL
        ) as primary_table

    ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<loan_purpose_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.loan_purpose_type current_record
                LEFT JOIN history_octane.loan_purpose_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t649 ON primary_table.prp_loan_purpose_type = t649.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<proposal_structure_type_partial_load_condition>> as include_record,
            current_record.*
            FROM history_octane.proposal_structure_type current_record
                LEFT JOIN history_octane.proposal_structure_type AS history_records ON current_record.code = history_records.code
                AND current_record.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t661 ON primary_table.prp_structure_type = t661.code
 WHERE
    GREATEST(primary_table.include_record, t1441.include_record, t649.include_record, t661.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;', 0, 'Staging DB Connection'
    FROM temp_process
    RETURNING dwid)

    , temp_json_output_field as (INSERT INTO mdi.json_output_field (process_dwid, field_name)   -- mdi.json_output_field
    select temp_process.dwid, 'data_source_integration_id'
    FROM temp_process)

    , temp_insert_update_step as (INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)   -- mdi.insert_update_step
    select temp_process.dwid, 'Staging DB Connection', 'star_loan', 'transaction_junk_dim', 1000, 'N'
    FROM temp_process
    RETURNING dwid)

    , temp_insert_update_key as (INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_condition)   -- mdi.insert_update_key
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', '= ~NULL'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_1 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_dwid', 'data_source_dwid', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_2 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_columns', 'data_source_integration_columns', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_3 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_integration_id', 'data_source_integration_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_4 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_created_datetime', 'edw_created_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_5 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'edw_modified_datetime', 'edw_modified_datetime', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_6 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'data_source_modified_datetime', 'data_source_modified_datetime', 'N', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_7 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'etl_batch_id', 'etl_batch_id', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_8 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'is_test_loan_flag', 'is_test_loan_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_9 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_purpose', 'loan_purpose', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_10 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'structure_code', 'structure_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_11 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'mi_required_flag', 'mi_required_flag', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_12 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'loan_purpose_code', 'loan_purpose_code', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_insert_update_field_13 as (INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)   -- mdi.insert_update_field
    select temp_insert_update_step.dwid, 'structure', 'structure', 'Y', 'FALSE'
    FROM temp_insert_update_step
    RETURNING dwid)

    , temp_state_machine_step_insert as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT temp_process.dwid, NULL
    FROM temp_process)

    , temp_state_machine_step_insert_1 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'deal'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'deal') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_2 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'loan_purpose_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'loan_purpose_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_3 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'proposal'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'proposal') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

    , temp_state_machine_step_insert_6 as (INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)  -- mdi.state_machine_step
    SELECT (SELECT
                process_dwid
            FROM
                mdi.table_output_step
            WHERE
                    table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = 'proposal_structure_type'
            UNION ALL
            SELECT
                process_dwid
            FROM
                mdi.insert_update_step
            WHERE
                    insert_update_step.schema_name = 'history_octane'
                AND insert_update_step.table_name = 'proposal_structure_type') as process_dwid
        , temp_process.dwid as next_process_dwid
    FROM temp_process)

SELECT 'Done adding MDI configuration for star_loan.transaction_junk_dim (SP-200020)' as etl_creator_status;
