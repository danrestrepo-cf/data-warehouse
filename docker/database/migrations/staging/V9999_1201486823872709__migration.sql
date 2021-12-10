--
-- EDW | backfill etl_log with existing star_loan etl_batch_id and insure all future etl_batch_ids correspond to a row in etl_log
-- https://app.asana.com/0/0/1201486823872709
--

/*
 Add indexes to star_loan etl_batch_id columns and date_dim's value column
 */

CREATE INDEX idx_application_dim__etl_batch_id ON star_loan.application_dim (etl_batch_id);
CREATE INDEX idx_borrower_demographics_dim__etl_batch_id ON star_loan.borrower_demographics_dim (etl_batch_id);
CREATE INDEX idx_lender_user_dim__etl_batch_id ON star_loan.lender_user_dim (etl_batch_id);
CREATE INDEX idx_loan_lender_user_access__etl_batch_id ON star_loan.loan_lender_user_access (etl_batch_id);
CREATE INDEX idx_loan_funding_dim__etl_batch_id ON star_loan.loan_funding_dim (etl_batch_id);
CREATE INDEX idx_borrower_dim__etl_batch_id ON star_loan.borrower_dim (etl_batch_id);
CREATE INDEX idx_loan_junk_dim__etl_batch_id ON star_loan.loan_junk_dim (etl_batch_id);
CREATE INDEX idx_investor_dim__etl_batch_id ON star_loan.investor_dim (etl_batch_id);
CREATE INDEX idx_hmda_purchaser_of_loan_dim__etl_batch_id ON star_loan.hmda_purchaser_of_loan_dim (etl_batch_id);
CREATE INDEX idx_borrower_lending_profile_dim__etl_batch_id ON star_loan.borrower_lending_profile_dim (etl_batch_id);
CREATE INDEX idx_loan_dim__etl_batch_id ON star_loan.loan_dim (etl_batch_id);
CREATE INDEX idx_product_terms_dim__etl_batch_id ON star_loan.product_terms_dim (etl_batch_id);
CREATE INDEX idx_product_dim__etl_batch_id ON star_loan.product_dim (etl_batch_id);
CREATE INDEX idx_product_choice_dim__etl_batch_id ON star_loan.product_choice_dim (etl_batch_id);
CREATE INDEX idx_mortgage_insurance_dim__etl_batch_id ON star_loan.mortgage_insurance_dim (etl_batch_id);
CREATE INDEX idx_transaction_junk_dim__etl_batch_id ON star_loan.transaction_junk_dim (etl_batch_id);
CREATE INDEX idx_loan_fact__etl_batch_id ON star_loan.loan_fact (etl_batch_id);
CREATE INDEX idx_loan_beneficiary_dim__etl_batch_id ON star_loan.loan_beneficiary_dim (etl_batch_id);
CREATE INDEX idx_transaction_dim__etl_batch_id ON star_loan.transaction_dim (etl_batch_id);
CREATE INDEX idx_interim_funder_dim__etl_batch_id ON star_loan.interim_funder_dim (etl_batch_id);

CREATE INDEX idx_date_dim__value ON star_common.date_dim (value);

/*
 back-fill etl_log to ensure no etl_batch_id in any star_loan table does *not* correspond to an etl_log row
*/

--star_loan.application_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT application_dim.etl_batch_id, MAX( application_dim.edw_modified_datetime ), MAX( application_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200003', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.application_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = application_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY application_dim.etl_batch_id;

--star_loan.borrower_demographics_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT borrower_demographics_dim.etl_batch_id, MAX( borrower_demographics_dim.edw_modified_datetime ), MAX( borrower_demographics_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200004', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.borrower_demographics_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = borrower_demographics_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY borrower_demographics_dim.etl_batch_id;

--star_loan.borrower_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT borrower_dim.etl_batch_id, MAX( borrower_dim.edw_modified_datetime ), MAX( borrower_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200005', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.borrower_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = borrower_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY borrower_dim.etl_batch_id;

--star_loan.borrower_lending_profile_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT borrower_lending_profile_dim.etl_batch_id, MAX( borrower_lending_profile_dim.edw_modified_datetime ), MAX( borrower_lending_profile_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200006', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.borrower_lending_profile_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = borrower_lending_profile_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY borrower_lending_profile_dim.etl_batch_id;

--star_loan.hmda_purchaser_of_loan_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT hmda_purchaser_of_loan_dim.etl_batch_id, MAX( hmda_purchaser_of_loan_dim.edw_modified_datetime ), MAX( hmda_purchaser_of_loan_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200007', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.hmda_purchaser_of_loan_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = hmda_purchaser_of_loan_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY hmda_purchaser_of_loan_dim.etl_batch_id;

--star_loan.interim_funder_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT interim_funder_dim.etl_batch_id, MAX( interim_funder_dim.edw_modified_datetime ), MAX( interim_funder_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200008', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.interim_funder_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = interim_funder_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY interim_funder_dim.etl_batch_id;

--star_loan.investor_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT investor_dim.etl_batch_id, MAX( investor_dim.edw_modified_datetime ), MAX( investor_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200009', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.investor_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = investor_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY investor_dim.etl_batch_id;

--star_loan.lender_user_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT lender_user_dim.etl_batch_id, MAX( lender_user_dim.edw_modified_datetime ), MAX( lender_user_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200010', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.lender_user_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = lender_user_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY lender_user_dim.etl_batch_id;

--star_loan.loan_beneficiary_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT loan_beneficiary_dim.etl_batch_id, MAX( loan_beneficiary_dim.edw_modified_datetime ), MAX( loan_beneficiary_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200011', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.loan_beneficiary_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = loan_beneficiary_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY loan_beneficiary_dim.etl_batch_id;

--star_loan.loan_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT loan_dim.etl_batch_id, MAX( loan_dim.edw_modified_datetime ), MAX( loan_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200012', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.loan_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = loan_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY loan_dim.etl_batch_id;

--star_loan.loan_fact
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT loan_fact.etl_batch_id, MAX( loan_fact.edw_modified_datetime ), MAX( loan_fact.edw_modified_datetime ) + '1 second', 'success', 'SP-300001-insert-update', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.loan_fact
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = loan_fact.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY loan_fact.etl_batch_id;

--star_loan.loan_funding_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT loan_funding_dim.etl_batch_id, MAX( loan_funding_dim.edw_modified_datetime ), MAX( loan_funding_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200013', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.loan_funding_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = loan_funding_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY loan_funding_dim.etl_batch_id;

--star_loan.loan_junk_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT loan_junk_dim.etl_batch_id, MAX( loan_junk_dim.edw_modified_datetime ), MAX( loan_junk_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200014', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.loan_junk_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = loan_junk_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY loan_junk_dim.etl_batch_id;

--star_loan.loan_lender_user_access
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT loan_lender_user_access.etl_batch_id, MAX( loan_lender_user_access.edw_modified_datetime ), MAX( loan_lender_user_access.edw_modified_datetime ) + '1 second', 'success', 'SP-200001-insert', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.loan_lender_user_access
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = loan_lender_user_access.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY loan_lender_user_access.etl_batch_id;

--star_loan.mortgage_insurance_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT mortgage_insurance_dim.etl_batch_id, MAX( mortgage_insurance_dim.edw_modified_datetime ), MAX( mortgage_insurance_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200015', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.mortgage_insurance_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = mortgage_insurance_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY mortgage_insurance_dim.etl_batch_id;

--star_loan.product_choice_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT product_choice_dim.etl_batch_id, MAX( product_choice_dim.edw_modified_datetime ), MAX( product_choice_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200016', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.product_choice_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = product_choice_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY product_choice_dim.etl_batch_id;

--star_loan.product_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT product_dim.etl_batch_id, MAX( product_dim.edw_modified_datetime ), MAX( product_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200017', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.product_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = product_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY product_dim.etl_batch_id;

--star_loan.product_terms_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT product_terms_dim.etl_batch_id, MAX( product_terms_dim.edw_modified_datetime ), MAX( product_terms_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200018', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.product_terms_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = product_terms_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY product_terms_dim.etl_batch_id;

--star_loan.transaction_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT transaction_dim.etl_batch_id, MAX( transaction_dim.edw_modified_datetime ), MAX( transaction_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200019', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.transaction_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = transaction_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY transaction_dim.etl_batch_id;

--star_loan.transaction_junk_dim
INSERT
INTO star_common.etl_log (etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
SELECT transaction_junk_dim.etl_batch_id, MAX( transaction_junk_dim.edw_modified_datetime ), MAX( transaction_junk_dim.edw_modified_datetime ) + '1 second', 'success', 'SP-200020', -1, '', '', 0, 0, 0, 0, 0, 0, 0
FROM star_loan.transaction_junk_dim
LEFT JOIN star_common.etl_log
          ON etl_log.etl_batch_id = transaction_junk_dim.etl_batch_id
WHERE etl_log.dwid IS NULL
GROUP BY transaction_junk_dim.etl_batch_id;
