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
TRUNCATE history_octane.deal_stage_type;
TRUNCATE history_octane.deal_stage;
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
VALUES ('batch_id', now() - interval '1' day, now(), 'success', 'SP-X')
;

--history_octane.deal
INSERT
    INTO history_octane.deal (data_source_updated_datetime, data_source_deleted_flag, d_pid, d_version, d_active_proposal_pid, d_test_loan, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, FALSE, 'batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, FALSE, 'batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, FALSE, 'batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, FALSE, 'batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, FALSE, 'batch_id')
;

--history_octane.proposal
INSERT
    INTO history_octane.proposal (data_source_updated_datetime, data_source_deleted_flag, prp_pid, prp_version, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 'batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 'batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 'batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 'batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 'batch_id')
;

--history_octane.application
INSERT
    INTO history_octane.application (data_source_updated_datetime, data_source_deleted_flag, apl_pid, apl_version, apl_proposal_pid, apl_primary_application, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, TRUE, 'batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, TRUE, 'batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, TRUE, 'batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, TRUE, 'batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, TRUE, 'batch_id')
;

--history_octane.loan
INSERT
    INTO history_octane.loan (data_source_updated_datetime, data_source_deleted_flag, l_pid, l_version, l_proposal_pid, l_loan_amount, l_hmda_purchaser_of_loan_2017_type, l_hmda_purchaser_of_loan_2018_type, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, 0, NULL, NULL, 'batch_id')
     , ('2022-01-01', FALSE, 1001, 2, 1001, 123456, '2017_CODE_2', '2018_CODE_2', 'batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, 200001, NULL, NULL, 'batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, 300000, NULL, NULL, 'batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, 400000, '2017_CODE_1', '2018_CODE_1', 'batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, 500001, '2017_CODE_1', '2018_CODE_1', 'batch_id')
;

--star_loan.loan_dim
INSERT
    INTO star_loan.loan_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, loan_pid)
VALUES (1001, 1, '2020-01-01', '2020-01-01', 'batch_id', 'loan_pid~data_source_dwid', '1001~1', '2020-01-01', 1001)
     , (1002, 1, '2020-01-01', '2020-01-01', 'batch_id', 'loan_pid~data_source_dwid', '1002~1', '2020-01-01', 1002)
     , (1003, 1, '2020-01-01', '2020-01-01', 'batch_id', 'loan_pid~data_source_dwid', '1003~1', '2020-01-01', 1003)
     , (1004, 1, '2020-01-01', '2020-01-01', 'batch_id', 'loan_pid~data_source_dwid', '1004~1', '2020-01-01', 1004)
     , (1005, 1, '2020-01-01', '2020-01-01', 'batch_id', 'loan_pid~data_source_dwid', '1005~1', '2020-01-01', 1005)
;

--history_octane.deal_key_roles
INSERT
    INTO history_octane.deal_key_roles (data_source_updated_datetime, data_source_deleted_flag, dkrs_pid, dkrs_version, dkrs_deal_pid, dkrs_account_executive_lender_user_pid, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, NULL, 'batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, NULL, 'batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, 1301, 'batch_id')
     , ('2022-01-01', FALSE, 1003, 2, 1003, 1302, 'batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, NULL, 'batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, NULL, 'batch_id')
;

--star_loan.lender_user_dim
INSERT
    INTO star_loan.lender_user_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, lender_user_pid)
VALUES (1301, 1, '2020-01-01', '2020-01-01', 'batch_id', 'lender_user_pid~data_source_dwid', '1301~1', '2020-01-01', 1301)
     , (1302, 1, '2020-01-01', '2020-01-01', 'batch_id', 'lender_user_pid~data_source_dwid', '1302~1', '2020-01-01', 1302)
;

--history_octane.borrower (B1)
INSERT
    INTO history_octane.borrower (data_source_updated_datetime, data_source_deleted_flag, b_pid, b_version, b_application_pid, b_borrower_tiny_id_type, etl_batch_id)
VALUES ('2020-01-01', FALSE, 1001, 1, 1001, 'B1', 'batch_id')
     , ('2020-01-01', FALSE, 1002, 1, 1002, 'B1', 'batch_id')
     , ('2020-01-01', FALSE, 1003, 1, 1003, 'B1', 'batch_id')
     , ('2020-01-01', FALSE, 1004, 1, 1004, 'B1', 'batch_id')
     , ('2020-01-01', FALSE, 1005, 1, 1005, 'B1', 'batch_id')
;


-- test data for transaction_dim
INSERT INTO history_octane.deal_stage
(data_source_updated_datetime, data_source_deleted_flag, dst_pid, dst_version, dst_deal_pid, dst_deal_stage_type, dst_from_date, dst_from_datetime, dst_through_date, dst_through_datetime, dst_duration_seconds, dst_business_hours_duration_seconds, etl_batch_id)
VALUES
(now(), false, 300, 3, 1001, 'STARTED', now() - interval '1' day,now() - interval '1', NOW(), NOW(), 86400, 86400, 'batch_id'), -- not sure why these have numbers like 3 and 4 in prod for version
(now(), false, 301, 1, 1001, 'PREQUAL', now(),now(), NULL, NULL, NULL, NULL, 'batch_id'),

(now(), false, 302, 3, 1002, 'STARTED', now() - interval '2' day,now() - interval '2', NOW(), NOW(), 86400, 86400, 'batch_id'),
(now(), false, 303, 4, 1002, 'PREQUAL', now() - interval '1' day,now() - interval '1', NOW(), NOW(), 86400, 86400, 'batch_id'),
(now(), false, 304, 1, 1002, 'INITIALUW', now(),now(), NULL, NULL, NULL, NULL, 'batch_id'),

(now(), false, 303, 1, 1003, 'STARTED', now(),now(), NULL, NULL, NULL, NULL, 'batch_id'),

(now(), false, 304, 1, 1004, 'INITIALUW', now(),now(), NULL, NULL, NULL, NULL, 'batch_id'),

(now(), false, 304, 1, 1005, 'STARTED', now(),now(), NULL, NULL, NULL, NULL, 'batch_id');



INSERT INTO history_octane.deal_stage_type
(data_source_updated_datetime, data_source_deleted_flag, code, value, etl_batch_id)
VALUES
(now(), false, 'STARTED', 'Now in started', 'batch_id'),
(now(), false, 'PREQUAL', 'Now in prequal', 'batch_id'),
(now(), false, 'INITIALUW', 'Now in initial underwriting', 'batch_id'),
(now(), false, 'UNUSED', 'This value is not used', 'batch_id');
