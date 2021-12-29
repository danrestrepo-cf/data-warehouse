--
-- EDW | Create yaml files for star_loan tables and update python-utilities as needed
-- https://app.asana.com/0/0/1201396507267274
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'star_common', 'data_source', NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
LEFT JOIN mdi.edw_table_definition source_table_definition
     ON insert_rows.source_database_name = source_table_definition.database_name
         AND insert_rows.source_schema_name = source_table_definition.schema_name
         AND insert_rows.source_table_name = source_table_definition.table_name;

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'star_common', 'data_source', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'data_source', 'name', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'dwid', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'value', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'date_format_iso_8601', 'CHAR(10)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'date_format_us', 'CHAR(10)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_month_suffix', 'VARCHAR(4)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_chronological', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'weekday_chronological', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_year', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_quarter', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_month', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_week', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_first_day_of_year', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_last_day_of_year', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_first_day_of_quarter', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_last_day_of_quarter', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_first_day_of_month', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_last_day_of_month', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_first_day_of_week', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_last_day_of_week', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_weekday', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_weekend', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_week_name', 'VARCHAR(9)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_week_name_short', 'CHAR(3)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'day_of_week_name_letter', 'CHAR', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_leap_year', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'is_leap_day', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'week_of_year', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'quarter_of_year', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'quarter_chronological', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'quarter_name', 'CHAR(6)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'year', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'month_of_year', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'days_in_month', 'SMALLINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'first_day_of_month', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'last_day_of_month', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'first_day_of_week', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'week_name', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'date_dim', 'week_format_iso_8601', 'VARCHAR(3)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'etl_start_date_time', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'etl_end_date_time', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'etl_duration', 'INTERVAL', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'status', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'process_name', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'controller_job_batch_id', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'input_json', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_json', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'input_rows_read', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'input_step_duration_ms', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'input_step_duration', 'INTERVAL', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_rows_inserted', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_rows_updated', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_rows_deleted', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_rows_rejected', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_total_rows', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_step_duration_ms', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_common', 'etl_log', 'output_step_duration', 'INTERVAL', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
FROM insert_rows
JOIN mdi.edw_table_definition
     ON insert_rows.database_name = edw_table_definition.database_name
         AND insert_rows.schema_name = edw_table_definition.schema_name
         AND insert_rows.table_name = edw_table_definition.table_name
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON insert_rows.source_database_name = source_table_definition.database_name
              AND insert_rows.source_schema_name = source_table_definition.schema_name
              AND insert_rows.source_table_name = source_table_definition.table_name
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND insert_rows.source_field_name = source_field_definition.field_name;

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-300001-delete', 'SP-200001-insert')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.process next_process
     ON next_process.name = insert_rows.next_process_name;

/*
UPDATES
*/

--edw_table_definition
WITH update_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'star_loan', 'loan_fact', 'staging', 'history_octane', 'loan')
)
UPDATE mdi.edw_table_definition
SET primary_source_edw_table_definition_dwid = source_table_definition.dwid
FROM update_rows
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON update_rows.source_database_name = source_table_definition.database_name
              AND update_rows.source_schema_name = source_table_definition.schema_name
              AND update_rows.source_table_name = source_table_definition.table_name
WHERE update_rows.database_name = edw_table_definition.database_name
  AND update_rows.schema_name = edw_table_definition.schema_name
  AND update_rows.table_name = edw_table_definition.table_name;

--edw_field_definition
WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'star_loan', 'application_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_demographics_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lending_profile_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'hmda_purchaser_of_loan_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'interim_funder_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'investor_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'lender_user_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_beneficiary_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'apr', 'NUMERIC(15,9)', 'staging', 'history_octane', 'loan', 'l_apr')
         , ('staging', 'star_loan', 'loan_fact', 'base_loan_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_base_loan_amount')
         , ('staging', 'star_loan', 'loan_fact', 'financed_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_financed_amount')
         , ('staging', 'star_loan', 'loan_fact', 'loan_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_loan_amount')
         , ('staging', 'star_loan', 'loan_fact', 'ltv_ratio_percent', 'NUMERIC(15,9)', 'staging', 'history_octane', 'loan', 'l_ltv_ratio_percent')
         , ('staging', 'star_loan', 'loan_fact', 'note_rate_percent', 'NUMERIC(15,9)', 'staging', 'history_octane', 'loan', 'l_note_rate_percent')
         , ('staging', 'star_loan', 'loan_fact', 'finance_charge_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_finance_charge_amount')
         , ('staging', 'star_loan', 'loan_fact', 'hoepa_fees_dollar_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_hoepa_fees_dollar_amount')
         , ('staging', 'star_loan', 'loan_fact', 'interest_rate_fee_change_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_interest_rate_fee_change_amount')
         , ('staging', 'star_loan', 'loan_fact', 'principal_curtailment_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_principal_curtailment_amount')
         , ('staging', 'star_loan', 'loan_fact', 'qualifying_pi_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_qualifying_pi_amount')
         , ('staging', 'star_loan', 'loan_fact', 'target_cash_out_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_target_cash_out_amount')
         , ('staging', 'star_loan', 'loan_fact', 'heloc_maximum_balance_amount', 'NUMERIC(21,3)', 'staging', 'history_octane', 'loan', 'l_heloc_maximum_balance_amount')
         , ('staging', 'star_loan', 'loan_funding_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_junk_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_lender_user_access', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'mortgage_insurance_dim', 'loan_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'product_choice_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'product_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'product_terms_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'product_terms_dim', 'high_balance', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_na_unknown_type', 'value')
         , ('staging', 'star_loan', 'transaction_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'transaction_junk_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
)
UPDATE mdi.edw_field_definition
SET data_type = update_rows.data_type
  , source_edw_field_definition_dwid = source_field_definition.dwid
FROM update_rows
JOIN mdi.edw_table_definition
     ON update_rows.database_name = edw_table_definition.database_name
         AND update_rows.schema_name = edw_table_definition.schema_name
         AND update_rows.table_name = edw_table_definition.table_name
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON update_rows.source_database_name = source_table_definition.database_name
              AND update_rows.source_schema_name = source_table_definition.schema_name
              AND update_rows.source_table_name = source_table_definition.table_name
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND update_rows.source_field_name = source_field_definition.field_name
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = update_rows.field_name;

--process
WITH update_rows (process_name, process_description) AS (
    VALUES ('SP-200003', 'table -> table-insert_update ETL from staging.history_octane.application to staging.star_loan.application_dim')
         , ('SP-200004', 'table -> table-insert_update ETL from staging.history_octane.borrower to staging.star_loan.borrower_demographics_dim')
         , ('SP-200005', 'table -> table-insert_update ETL from staging.history_octane.borrower to staging.star_loan.borrower_dim')
         , ('SP-200006', 'table -> table-insert_update ETL from staging.history_octane.borrower to staging.star_loan.borrower_lending_profile_dim')
         , ('SP-200007', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.hmda_purchaser_of_loan_dim')
         , ('SP-200008', 'table -> table-insert_update ETL from staging.history_octane.interim_funder to staging.star_loan.interim_funder_dim')
         , ('SP-200009', 'table -> table-insert_update ETL from staging.history_octane.investor to staging.star_loan.investor_dim')
         , ('SP-200010', 'table -> table-insert_update ETL from staging.history_octane.lender_user to staging.star_loan.lender_user_dim')
         , ('SP-200011', 'table -> table-insert_update ETL from staging.history_octane.loan_beneficiary to staging.star_loan.loan_beneficiary_dim')
         , ('SP-200012', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.loan_dim')
         , ('SP-300001-insert-update', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.loan_fact')
         , ('SP-300001-delete', 'table -> table-delete ETL from staging.history_octane.loan to staging.star_loan.loan_fact')
         , ('SP-200013', 'table -> table-insert_update ETL from staging.history_octane.loan_funding to staging.star_loan.loan_funding_dim')
         , ('SP-200014', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.loan_junk_dim')
         , ('SP-200001-insert', 'table -> table-insert ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200015', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.mortgage_insurance_dim')
         , ('SP-200016', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.product_choice_dim')
         , ('SP-200017', 'table -> table-insert_update ETL from staging.history_octane.product to staging.star_loan.product_dim')
         , ('SP-200018', 'table -> table-insert_update ETL from staging.history_octane.product_terms to staging.star_loan.product_terms_dim')
         , ('SP-200019', 'table -> table-insert_update ETL from staging.history_octane.proposal to staging.star_loan.transaction_dim')
         , ('SP-200020', 'table -> table-insert_update ETL from staging.history_octane.proposal to staging.star_loan.transaction_junk_dim')
)
UPDATE mdi.process
SET description = update_rows.process_description
FROM update_rows
WHERE update_rows.process_name = process.name;

--state_machine_definition
WITH update_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-200003', 'SP-200003', 'table -> table-insert_update ETL from staging.history_octane.application to staging.star_loan.application_dim')
         , ('SP-200004', 'SP-200004', 'table -> table-insert_update ETL from staging.history_octane.borrower to staging.star_loan.borrower_demographics_dim')
         , ('SP-200005', 'SP-200005', 'table -> table-insert_update ETL from staging.history_octane.borrower to staging.star_loan.borrower_dim')
         , ('SP-200006', 'SP-200006', 'table -> table-insert_update ETL from staging.history_octane.borrower to staging.star_loan.borrower_lending_profile_dim')
         , ('SP-200007', 'SP-200007', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.hmda_purchaser_of_loan_dim')
         , ('SP-200008', 'SP-200008', 'table -> table-insert_update ETL from staging.history_octane.interim_funder to staging.star_loan.interim_funder_dim')
         , ('SP-200009', 'SP-200009', 'table -> table-insert_update ETL from staging.history_octane.investor to staging.star_loan.investor_dim')
         , ('SP-200010', 'SP-200010', 'table -> table-insert_update ETL from staging.history_octane.lender_user to staging.star_loan.lender_user_dim')
         , ('SP-200011', 'SP-200011', 'table -> table-insert_update ETL from staging.history_octane.loan_beneficiary to staging.star_loan.loan_beneficiary_dim')
         , ('SP-200012', 'SP-200012', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.loan_dim')
         , ('SP-300001-insert-update', 'SP-300001-insert-update', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.loan_fact')
         , ('SP-300001-delete', 'SP-300001-delete', 'table -> table-delete ETL from staging.history_octane.loan to staging.star_loan.loan_fact')
         , ('SP-200013', 'SP-200013', 'table -> table-insert_update ETL from staging.history_octane.loan_funding to staging.star_loan.loan_funding_dim')
         , ('SP-200014', 'SP-200014', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.loan_junk_dim')
         , ('SP-200001-insert', 'SP-200001-insert', 'table -> table-insert ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200001-delete', 'SP-200001-delete', 'table -> table-delete ETL from staging.history_octane.deal_lender_user to staging.star_loan.loan_lender_user_access')
         , ('SP-200015', 'SP-200015', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.mortgage_insurance_dim')
         , ('SP-200016', 'SP-200016', 'table -> table-insert_update ETL from staging.history_octane.loan to staging.star_loan.product_choice_dim')
         , ('SP-200017', 'SP-200017', 'table -> table-insert_update ETL from staging.history_octane.product to staging.star_loan.product_dim')
         , ('SP-200018', 'SP-200018', 'table -> table-insert_update ETL from staging.history_octane.product_terms to staging.star_loan.product_terms_dim')
         , ('SP-200019', 'SP-200019', 'table -> table-insert_update ETL from staging.history_octane.proposal to staging.star_loan.transaction_dim')
         , ('SP-200020', 'SP-200020', 'table -> table-insert_update ETL from staging.history_octane.proposal to staging.star_loan.transaction_junk_dim')
)
UPDATE mdi.state_machine_definition
SET name = update_rows.state_machine_name
  , comment = update_rows.state_machine_comment
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = state_machine_definition.process_dwid;
