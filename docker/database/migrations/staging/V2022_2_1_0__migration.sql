--
-- EDW | Add Octane table deal_stage data EDW so it is reportable at the loan level - https://app.asana.com/0/0/1200811462378267
--

ALTER TABLE star_loan.loan_fact
    ADD current_transaction_stage_from_date_dwid BIGINT;

ALTER TABLE star_loan.transaction_dim
    ADD current_transaction_stage VARCHAR(1024)
    , ADD current_transaction_stage_code VARCHAR(128);



-- test data for loan_fact
--clean up between test runs
TRUNCATE history_octane.deal;
TRUNCATE history_octane.proposal;
TRUNCATE history_octane.application;
TRUNCATE history_octane.loan;
TRUNCATE history_octane.deal_key_roles;
TRUNCATE history_octane.borrower;
TRUNCATE star_loan.loan_fact;
DELETE
FROM star_loan.loan_dim
WHERE dwid <> 0;
DELETE
FROM star_loan.lender_user_dim
WHERE dwid <> 0;
TRUNCATE star_common.etl_log;

--star_common.etl_log
INSERT
    INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name)
VALUES ('before_fact_batch_id', '2020-01-01', '2020-02-02', 'success', 'SP-X')
     , ('fact_batch_id', '2021-01-01', '2021-02-02', 'success', 'SP-X')
     , ('overlapping_fact_batch_id', '2020-01-01', '2021-01-15', 'success', 'SP-X')
     , ('after_fact_batch_id', '2022-01-01', '2022-02-02', 'success', 'SP-X')
;

/*--star_loan.loan_fact
INSERT
    INTO star_loan.loan_fact(data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, loan_pid, loan_dwid, loan_junk_dwid, product_choice_dwid, transaction_dwid, transaction_junk_dwid, current_loan_beneficiary_dwid, active_loan_funding_dwid, b1_borrower_dwid, b2_borrower_dwid, b3_borrower_dwid, b4_borrower_dwid, b5_borrower_dwid, c1_borrower_dwid, c2_borrower_dwid, c3_borrower_dwid, c4_borrower_dwid, c5_borrower_dwid, n1_borrower_dwid, n2_borrower_dwid, n3_borrower_dwid, n4_borrower_dwid, n5_borrower_dwid, n6_borrower_dwid, n7_borrower_dwid, n8_borrower_dwid, b1_borrower_demographics_dwid, b1_borrower_lending_profile_dwid, primary_application_dwid, collateral_to_custodian_lender_user_dwid, interim_funder_dwid, product_terms_dwid, product_dwid, product_investor_dwid, hmda_purchaser_of_loan_dwid, apr, base_loan_amount, financed_amount, loan_amount, ltv_ratio_percent, note_rate_percent, purchase_advice_amount, finance_charge_amount, hoepa_fees_dollar_amount, interest_rate_fee_change_amount, principal_curtailment_amount, qualifying_pi_amount, target_cash_out_amount, heloc_maximum_balance_amount, agency_case_id_assigned_date_dwid, apor_date_dwid, application_signed_date_dwid, approved_with_conditions_date_dwid, beneficiary_from_date_dwid, beneficiary_through_date_dwid, collateral_sent_date_dwid, disbursement_date_dwid, early_funding_date_dwid, effective_funding_date_dwid, fha_endorsement_date_dwid, estimated_funding_date_dwid, intent_to_proceed_date_dwid, funding_date_dwid, funding_requested_date_dwid, loan_file_ship_date_dwid, mers_transfer_creation_date_dwid, pending_wire_date_dwid, rejected_date_dwid, return_confirmed_date_dwid, return_request_date_dwid, scheduled_release_date_dwid, usda_guarantee_date_dwid, va_guaranty_date_dwid, account_executive_lender_user_dwid, closing_doc_specialist_lender_user_dwid, closing_scheduler_lender_user_dwid, collateral_to_investor_lender_user_dwid, collateral_underwriter_lender_user_dwid, correspondent_client_advocate_lender_user_dwid, final_documents_to_investor_lender_user_dwid, flood_insurance_specialist_lender_user_dwid, funder_lender_user_dwid, government_insurance_lender_user_dwid, ho6_specialist_lender_user_dwid, hoa_specialist_lender_user_dwid, hoi_specialist_lender_user_dwid, hud_va_lender_officer_lender_user_dwid, internal_construction_manager_lender_user_dwid, investor_conditions_lender_user_dwid, investor_stack_to_investor_lender_user_dwid, loan_officer_assistant_lender_user_dwid, loan_payoff_specialist_lender_user_dwid, originator_lender_user_dwid, processor_lender_user_dwid, project_underwriter_lender_user_dwid, subordination_specialist_lender_user_dwid, supplemental_originator_lender_user_dwid, title_specialist_lender_user_dwid, transaction_assistant_lender_user_dwid, underwriter_lender_user_dwid, underwriting_manager_lender_user_dwid, va_specialist_lender_user_dwid, verbal_voe_specialist_lender_user_dwid, voe_specialist_lender_user_dwid, wholesale_client_advocate_lender_user_dwid, wire_specialist_lender_user_dwid, initial_beneficiary_investor_dwid, first_beneficiary_after_initial_investor_dwid, most_recent_purchasing_beneficiary_investor_dwid, current_beneficiary_investor_dwid)
VALUES (1, '2021-01-01', '2021-01-01', 'fact_batch_id', 'loan_pid~data_source_dwid', '1001~1', '2020-01-01', 1001, 1001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
     , (1, '2021-01-01', '2021-01-01', 'fact_batch_id', 'loan_pid~data_source_dwid', '1002~1', '2020-01-01', 1002, 1002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 200000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
     , (1, '2021-01-01', '2021-01-01', 'fact_batch_id', 'loan_pid~data_source_dwid', '1003~1', '2020-01-01', 1003, 1003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 300000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1301, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
     , (1, '2021-01-01', '2021-01-01', 'nonexistent_batch_id', 'loan_pid~data_source_dwid', '1005~1', '2020-01-01', 1005, 1005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 500000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1301, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
;*/

--history_octane.deal
INSERT
    INTO history_octane.deal (data_source_updated_datetime, data_source_deleted_flag, d_pid, d_version, d_active_proposal_pid, d_test_loan, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, FALSE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, FALSE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, FALSE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, FALSE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, FALSE, 'before_fact_batch_id')
;

--history_octane.proposal
INSERT
    INTO history_octane.proposal (data_source_updated_datetime, data_source_deleted_flag, prp_pid, prp_version, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 'before_fact_batch_id')
;

--history_octane.application
INSERT
    INTO history_octane.application (data_source_updated_datetime, data_source_deleted_flag, apl_pid, apl_version, apl_proposal_pid, apl_primary_application, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, TRUE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, TRUE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, TRUE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, TRUE, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, TRUE, 'before_fact_batch_id')
;

--history_octane.loan
INSERT
    INTO history_octane.loan (data_source_updated_datetime, data_source_deleted_flag, l_pid, l_version, l_proposal_pid, l_loan_amount, l_hmda_purchaser_of_loan_2017_type, l_hmda_purchaser_of_loan_2018_type, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, 0, NULL, NULL, 'before_fact_batch_id')
     , ('2022-01-01', FALSE, 1001, 2, 1001, 123456, '2017_CODE_2', '2018_CODE_2', 'after_fact_batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, 200001, NULL, NULL, 'overlapping_fact_batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, 300000, NULL, NULL, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, 400000, '2017_CODE_1', '2018_CODE_1', 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, 500001, '2017_CODE_1', '2018_CODE_1', 'after_fact_batch_id')
;

--star_loan.loan_dim
INSERT
    INTO star_loan.loan_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, loan_pid)
VALUES (1001, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'loan_pid~data_source_dwid', '1001~1', '2020-01-01', 1001)
     , (1002, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'loan_pid~data_source_dwid', '1002~1', '2020-01-01', 1002)
     , (1003, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'loan_pid~data_source_dwid', '1003~1', '2020-01-01', 1003)
     , (1004, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'loan_pid~data_source_dwid', '1004~1', '2020-01-01', 1004)
     , (1005, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'loan_pid~data_source_dwid', '1005~1', '2020-01-01', 1005)
;

--history_octane.deal_key_roles
INSERT
    INTO history_octane.deal_key_roles (data_source_updated_datetime, data_source_deleted_flag, dkrs_pid, dkrs_version, dkrs_deal_pid, dkrs_account_executive_lender_user_pid, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, NULL, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, NULL, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, 1301, 'before_fact_batch_id')
     , ('2022-01-01', FALSE, 1003, 2, 1003, 1302, 'fact_batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, NULL, 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, NULL, 'before_fact_batch_id')
;

--star_loan.lender_user_dim
INSERT
    INTO star_loan.lender_user_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, lender_user_pid)
VALUES (1301, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'lender_user_pid~data_source_dwid', '1301~1', '2020-01-01', 1301)
     , (1302, 1, '2020-01-01', '2020-01-01', 'before_fact_batch_id', 'lender_user_pid~data_source_dwid', '1302~1', '2020-01-01', 1302)
;

--history_octane.borrower (B1)
INSERT
    INTO history_octane.borrower (data_source_updated_datetime, data_source_deleted_flag, b_pid, b_version, b_application_pid, b_borrower_tiny_id_type, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, 'B1', 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, 'B1', 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, 'B1', 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, 'B1', 'before_fact_batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, 'B1', 'before_fact_batch_id')
;

INSERT INTO history_octane.deal_stage
(data_source_updated_datetime, data_source_deleted_flag, dst_pid, dst_version, dst_deal_pid, dst_deal_stage_type, dst_from_date, dst_from_datetime, dst_through_date, dst_through_datetime, dst_duration_seconds, dst_business_hours_duration_seconds, etl_batch_id)
VALUES
(now(), false, 300, 1, 1001, 'STARTED', now() - interval '1' day,now() - interval '1', NOW(), NOW(), 86400, 86400, 'batch_id_1'),
(now(), false, 301, 1, 1001, 'PREQUAL', now(),now(), NULL, NULL, NULL, NULL, 'batch_id_1');

INSERT INTO history_octane.deal_stage_type
(data_source_updated_datetime, data_source_deleted_flag, code, value, etl_batch_id)
VALUES
(now(), false, 'STARTED', 'Now in started', 'batch_id_1'),
(now(), false, 'PREQUAL', 'Now in prequal', 'batch_id_1');


-- test data for transaction_dim
insert into star_common. etl_log
(dwid, etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
VALUES
(1, 'batch_id_1', now(), now(), 'finished', 'SAMPLE-ETL',0, '','',0,0,0,0,0,0,0);

INSERT INTO history_octane.proposal
(data_source_updated_datetime, data_source_deleted_flag, prp_pid, prp_version, etl_batch_id)
values
(now(), false, 200, 1, 'batch_id_1');

INSERT INTO history_octane.deal
(data_source_updated_datetime, data_source_deleted_flag, d_pid, d_version, d_active_proposal_pid, etl_batch_id)
values
(now(),false,100,1,200,'batch_id_1');

INSERT INTO history_octane.deal_stage
(data_source_updated_datetime, data_source_deleted_flag, dst_pid, dst_version, dst_deal_pid, dst_deal_stage_type, dst_from_date, dst_from_datetime, dst_through_date, dst_through_datetime, dst_duration_seconds, dst_business_hours_duration_seconds, etl_batch_id)
VALUES
(now(), false, 300, 1, 100, 'STARTED', now() - interval '1' day,now() - interval '1', NOW(), NOW(), 86400, 86400, 'batch_id_1'),
(now(), false, 301, 1, 100, 'PREQUAL', now(),now(), NULL, NULL, NULL, NULL, 'batch_id_1');

INSERT INTO history_octane.deal_stage_type
(data_source_updated_datetime, data_source_deleted_flag, code, value, etl_batch_id)
VALUES
(now(), false, 'STARTED', 'Now in started', 'batch_id_1'),
(now(), false, 'PREQUAL', 'Now in prequal', 'batch_id_1');

