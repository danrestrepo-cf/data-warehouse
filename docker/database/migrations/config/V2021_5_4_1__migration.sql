--
-- EDW | edw_field_definition table: reporting_hidden field has yes/no AND true/false as possible values
-- https://app.asana.com/0/0/1200391232357557
--

-- fix existing value errors in reporting_hidden
UPDATE mdi.edw_field_definition
SET reporting_hidden = 'yes'
WHERE reporting_hidden = 'true';

UPDATE mdi.edw_field_definition
SET reporting_hidden = 'no'
WHERE reporting_hidden = 'false';

--prevent similar errors in the future
CREATE TYPE looker_yes_no AS ENUM ('yes', 'no');

ALTER TABLE mdi.edw_field_definition
    ALTER COLUMN reporting_hidden TYPE looker_yes_no USING reporting_hidden::looker_yes_no;

--
-- EDW | DML changes - Octane Schema changes for 2021.5.4.0 (5/28/21)
-- https://app.asana.com/0/0/1200387930619086
--

--
-- INSERT EDW_TABLE_DEFINITION ROWS
--

-- Insert edw_table_definition rows for credit_request_liability
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'credit_request_liability', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'credit_request_liability', staging_table.dwid
FROM staging_table;

-- Insert edw_table_definition rows for liability_new
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'liability_new', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'liability_new', staging_table.dwid
FROM staging_table;

-- Insert edw_table_definition rows for liability_place
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'liability_place', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'liability_place', staging_table.dwid
FROM staging_table;

-- Insert edw_table_definition rows for liability_mortgage_payoff
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'liability_mortgage_payoff', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'liability_mortgage_payoff', staging_table.dwid
FROM staging_table;


--
-- INSERT EDW_FIELD_DEFINITION ROWS
--

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_field_data (
    table_name TEXT,
    field_name TEXT,
    key_field_flag BOOLEAN,
    field_order INTEGER
);

INSERT
INTO temp_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('credit_request_liability', 'crl_pid', TRUE, 1)
     , ('credit_request_liability', 'crl_version', FALSE, 2)
     , ('credit_request_liability', 'crl_deal_pid', FALSE, 3)
     , ('credit_request_liability', 'crl_credit_request_pid', FALSE, 4)
     , ('credit_request_liability', 'crl_credit_report_identifier', FALSE, 5)
     , ('credit_request_liability', 'crl_report_liability_type', FALSE, 6)
     , ('credit_request_liability', 'crl_report_holder_name', FALSE, 7)
     , ('credit_request_liability', 'crl_report_account_opened_date', FALSE, 8)
     , ('credit_request_liability', 'crl_account_reported_date', FALSE, 9)
     , ('credit_request_liability', 'crl_last_activity_date', FALSE, 10)
     , ('credit_request_liability', 'crl_most_recent_adverse_rating_date', FALSE, 11)
     , ('credit_request_liability', 'crl_report_monthly_payment_amount', FALSE, 12)
     , ('credit_request_liability', 'crl_report_remaining_term_months', FALSE, 13)
     , ('credit_request_liability', 'crl_months_reviewed_count', FALSE, 14)
     , ('credit_request_liability', 'crl_report_unpaid_balance_amount', FALSE, 15)
     , ('credit_request_liability', 'crl_report_credit_limit_amount', FALSE, 16)
     , ('credit_request_liability', 'crl_report_past_due_amount', FALSE, 17)
     , ('credit_request_liability', 'crl_report_terms_months_count', FALSE, 18)
     , ('credit_request_liability', 'crl_report_liability_current_rating_type', FALSE, 19)
     , ('credit_request_liability', 'crl_report_liability_account_status_type', FALSE, 20)
     , ('credit_request_liability', 'crl_report_liability_account_ownership_type', FALSE, 21)
     , ('credit_request_liability', 'crl_consumer_dispute', FALSE, 22)
     , ('credit_request_liability', 'crl_derogatory_data', FALSE, 23)
     , ('credit_request_liability', 'crl_late_30_days_count', FALSE, 24)
     , ('credit_request_liability', 'crl_late_60_days_count', FALSE, 25)
     , ('credit_request_liability', 'crl_late_90_days_count', FALSE, 26)
     , ('credit_request_liability', 'crl_equifax_included', FALSE, 27)
     , ('credit_request_liability', 'crl_experian_included', FALSE, 28)
     , ('credit_request_liability', 'crl_trans_union_included', FALSE, 29)
     , ('liability_new', 'lia_pid', TRUE, 1)
     , ('liability_new', 'lia_version', FALSE, 2)
     , ('liability_new', 'lia_proposal_pid', FALSE, 3)
     , ('liability_new', 'lia_account_id', FALSE, 4)
     , ('liability_new', 'lia_aggregate_description', FALSE, 5)
     , ('liability_new', 'lia_credit_request_liability_pid', FALSE, 6)
     , ('liability_new', 'lia_description', FALSE, 7)
     , ('liability_new', 'lia_city', FALSE, 8)
     , ('liability_new', 'lia_country', FALSE, 9)
     , ('liability_new', 'lia_postal_code', FALSE, 10)
     , ('liability_new', 'lia_state', FALSE, 11)
     , ('liability_new', 'lia_street1', FALSE, 12)
     , ('liability_new', 'lia_street2', FALSE, 13)
     , ('liability_new', 'lia_holder_name', FALSE, 14)
     , ('liability_new', 'lia_holder_phone', FALSE, 15)
     , ('liability_new', 'lia_holder_phone_extension', FALSE, 16)
     , ('liability_new', 'lia_holder_fax', FALSE, 17)
     , ('liability_new', 'lia_holder_email', FALSE, 18)
     , ('liability_new', 'lia_account_opened_date', FALSE, 19)
     , ('liability_new', 'lia_liability_disposition_type', FALSE, 20)
     , ('liability_new', 'lia_liability_type', FALSE, 21)
     , ('liability_new', 'lia_monthly_payment_amount', FALSE, 22)
     , ('liability_new', 'lia_remaining_term_months', FALSE, 23)
     , ('liability_new', 'lia_high_balance_amount', FALSE, 24)
     , ('liability_new', 'lia_credit_limit_amount', FALSE, 25)
     , ('liability_new', 'lia_past_due_amount', FALSE, 26)
     , ('liability_new', 'lia_unpaid_balance_amount', FALSE, 27)
     , ('liability_new', 'lia_report_value_overridden', FALSE, 28)
     , ('liability_new', 'lia_bankruptcy_exception_type', FALSE, 29)
     , ('liability_new', 'lia_note', FALSE, 30)
     , ('liability_new', 'lia_terms_months_count', FALSE, 31)
     , ('liability_new', 'lia_payoff_amount', FALSE, 32)
     , ('liability_new', 'lia_energy_related_type', FALSE, 33)
     , ('liability_place', 'lip_pid', TRUE, 1)
     , ('liability_place', 'lip_version', FALSE, 2)
     , ('liability_place', 'lip_liability_pid', FALSE, 3)
     , ('liability_place', 'lip_creditor_pid', FALSE, 4)
     , ('liability_place', 'lip_place_pid', FALSE, 5)
     , ('liability_place', 'lip_lien_priority_type', FALSE, 6)
     , ('liability_place', 'lip_liability_financing_type', FALSE, 7)
     , ('liability_place', 'lip_liability_foreclosure_exception_type', FALSE, 8)
     , ('liability_place', 'lip_liability_mi_type', FALSE, 9)
     , ('liability_place', 'lip_original_loan_amount', FALSE, 10)
     , ('liability_place', 'lip_property_taxes_escrowed', FALSE, 11)
     , ('liability_place', 'lip_property_insurance_escrowed', FALSE, 12)
     , ('liability_place', 'lip_senior_lien_restriction_type', FALSE, 13)
     , ('liability_place', 'lip_senior_lien_restriction_amount', FALSE, 14)
     , ('liability_place', 'lip_texas_equity', FALSE, 15)
     , ('liability_place', 'lip_texas_equity_conversion', FALSE, 16)
     , ('liability_place', 'lip_texas_equity_locked', FALSE, 17)
     , ('liability_place', 'lip_third_party_community_second_program_pid', FALSE, 18)
     , ('liability_mortgage_payoff', 'lmp_pid', TRUE, 1)
     , ('liability_mortgage_payoff', 'lmp_version', FALSE, 2)
     , ('liability_mortgage_payoff', 'lmp_liability_pid', FALSE, 3)
     , ('liability_mortgage_payoff', 'lmp_interest_rate_on_statement', FALSE, 4)
     , ('liability_mortgage_payoff', 'lmp_interest_rate_percent', FALSE, 5)
     , ('liability_mortgage_payoff', 'lmp_loan_amortization_type', FALSE, 6)
     , ('liability_mortgage_payoff', 'lmp_interest_only', FALSE, 7)
     , ('liability_mortgage_payoff', 'lmp_agency_case_id', FALSE, 8)
     , ('liability_mortgage_payoff', 'lmp_payoff_statement_date', FALSE, 9)
     , ('liability_mortgage_payoff', 'lmp_payoff_statement_good_through_date', FALSE, 10)
     , ('liability_mortgage_payoff', 'lmp_next_payment_due_date', FALSE, 11)
     , ('liability_mortgage_payoff', 'lmp_payoff_statement_interest', FALSE, 12)
     , ('liability_mortgage_payoff', 'lmp_daily_interest_amount', FALSE, 13)
     , ('liability_mortgage_payoff', 'lmp_monthly_interest_amount', FALSE, 14)
     , ('liability_mortgage_payoff', 'lmp_payoff_interest_pad_days', FALSE, 15)
     , ('liability_mortgage_payoff', 'lmp_effective_payoff_date', FALSE, 16)
     , ('liability_mortgage_payoff', 'lmp_effective_payoff_date_adjustment_amount', FALSE, 17)
     , ('liability_mortgage_payoff', 'lmp_effective_payoff_date_adjustment_days', FALSE, 18)
     , ('liability_mortgage_payoff', 'lmp_other_payoff_related_charges_amount', FALSE, 19)
     , ('liability_mortgage_payoff', 'lmp_unpaid_late_charges_amount', FALSE, 20)
     , ('liability_mortgage_payoff', 'lmp_mortgage_payoff_amount_estimated', FALSE, 21)
     , ('liability_mortgage_payoff', 'lmp_mip_due_amount', FALSE, 22)
     , ('liability_mortgage_payoff', 'lmp_used_to_acquire_property', FALSE, 23)
     , ('liability_mortgage_payoff', 'lmp_heloc_advance_last_12_months_over_thousand', FALSE, 24)
     , ('liability_mortgage_payoff', 'lmp_net_escrow', FALSE, 25)
     , ('liability_mortgage_payoff', 'lmp_current_escrow_balance_amount', FALSE, 26)
     , ('liability_mortgage_payoff', 'lmp_first_payment_date', FALSE, 27)
     , ('liability_mortgage_payoff', 'lmp_closing_date', FALSE, 28)
     , ('liability_mortgage_payoff', 'lmp_include_within_cema', FALSE, 29);

-- Insert edw_field_data for new staging_octane tables
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_field_data.field_name, temp_field_data.key_field_flag
FROM temp_field_data
JOIN mdi.edw_table_definition
     ON temp_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'staging_octane';

-- Load history_octane-specific fields into temporary table before inserting history_octane field data
INSERT
INTO temp_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('credit_request_liability', 'crl_temp_liability_pid', FALSE, NULL) --this field was deleted from staging_octane.credit_request_liability
     , ('credit_request_liability', 'data_source_updated_datetime', FALSE, 30)
     , ('credit_request_liability', 'data_source_deleted_flag', FALSE, 31)
     , ('liability_new', 'data_source_updated_datetime', FALSE, 34)
     , ('liability_new', 'data_source_deleted_flag', FALSE, 35)
     , ('liability_place', 'data_source_updated_datetime', FALSE, 19)
     , ('liability_place', 'data_source_deleted_flag', FALSE, 20)
     , ('liability_mortgage_payoff', 'data_source_updated_datetime', FALSE, 30)
     , ('liability_mortgage_payoff', 'data_source_deleted_flag', FALSE, 31);

-- Insert edw_field_data fo new history_octane tables
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
SELECT edw_table_definition.dwid, temp_field_data.field_name, temp_field_data.key_field_flag, source_field_definition.dwid
FROM temp_field_data
JOIN mdi.edw_table_definition
     ON temp_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'history_octane'
JOIN mdi.edw_table_definition source_table_definition
     ON edw_table_definition.table_name = source_table_definition.table_name
         AND source_table_definition.schema_name = 'staging_octane'
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND temp_field_data.field_name = source_field_definition.field_name;

--
-- INSERT MDI ETL CONFIG DATA
--

-- Load fields field values that differ between processes into a temp table before inserting MDI config data
CREATE TEMPORARY TABLE temp_mdi_data (
    table_name TEXT,
    process_name TEXT,
    json_output_field TEXT,
    input_sql TEXT,
    process_dwid BIGINT
);

INSERT
INTO temp_mdi_data (table_name, process_name, json_output_field, input_sql)
VALUES ('credit_request_liability', 'SP-100821', 'crl_pid', '--finding records to insert into history_octane.credit_request_liability
SELECT staging_table.crl_pid
     , staging_table.crl_version
     , staging_table.crl_deal_pid
     , staging_table.crl_credit_request_pid
     , staging_table.crl_credit_report_identifier
     , staging_table.crl_report_liability_type
     , staging_table.crl_report_holder_name
     , staging_table.crl_report_account_opened_date
     , staging_table.crl_account_reported_date
     , staging_table.crl_last_activity_date
     , staging_table.crl_most_recent_adverse_rating_date
     , staging_table.crl_report_monthly_payment_amount
     , staging_table.crl_report_remaining_term_months
     , staging_table.crl_months_reviewed_count
     , staging_table.crl_report_unpaid_balance_amount
     , staging_table.crl_report_credit_limit_amount
     , staging_table.crl_report_past_due_amount
     , staging_table.crl_report_terms_months_count
     , staging_table.crl_report_liability_current_rating_type
     , staging_table.crl_report_liability_account_status_type
     , staging_table.crl_report_liability_account_ownership_type
     , staging_table.crl_consumer_dispute
     , staging_table.crl_derogatory_data
     , staging_table.crl_late_30_days_count
     , staging_table.crl_late_60_days_count
     , staging_table.crl_late_90_days_count
     , staging_table.crl_equifax_included
     , staging_table.crl_experian_included
     , staging_table.crl_trans_union_included
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.credit_request_liability staging_table
LEFT JOIN history_octane.credit_request_liability history_table
          ON staging_table.crl_pid = history_table.crl_pid AND staging_table.crl_version = history_table.crl_version
WHERE history_table.crl_pid IS NULL
UNION ALL
SELECT history_table.crl_pid
     , history_table.crl_version + 1
     , history_table.crl_deal_pid
     , history_table.crl_credit_request_pid
     , history_table.crl_credit_report_identifier
     , history_table.crl_report_liability_type
     , history_table.crl_report_holder_name
     , history_table.crl_report_account_opened_date
     , history_table.crl_account_reported_date
     , history_table.crl_last_activity_date
     , history_table.crl_most_recent_adverse_rating_date
     , history_table.crl_report_monthly_payment_amount
     , history_table.crl_report_remaining_term_months
     , history_table.crl_months_reviewed_count
     , history_table.crl_report_unpaid_balance_amount
     , history_table.crl_report_credit_limit_amount
     , history_table.crl_report_past_due_amount
     , history_table.crl_report_terms_months_count
     , history_table.crl_report_liability_current_rating_type
     , history_table.crl_report_liability_account_status_type
     , history_table.crl_report_liability_account_ownership_type
     , history_table.crl_consumer_dispute
     , history_table.crl_derogatory_data
     , history_table.crl_late_30_days_count
     , history_table.crl_late_60_days_count
     , history_table.crl_late_90_days_count
     , history_table.crl_equifax_included
     , history_table.crl_experian_included
     , history_table.crl_trans_union_included
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.credit_request_liability history_table
LEFT JOIN staging_octane.credit_request_liability staging_table
          ON staging_table.crl_pid = history_table.crl_pid
WHERE staging_table.crl_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.credit_request_liability deleted_records
                  WHERE deleted_records.crl_pid = history_table.crl_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
')
     , ('liability_new', 'SP-100822', 'lia_pid', '--finding records to insert into history_octane.liability_new
SELECT staging_table.lia_pid
     , staging_table.lia_version
     , staging_table.lia_proposal_pid
     , staging_table.lia_account_id
     , staging_table.lia_aggregate_description
     , staging_table.lia_credit_request_liability_pid
     , staging_table.lia_description
     , staging_table.lia_city
     , staging_table.lia_country
     , staging_table.lia_postal_code
     , staging_table.lia_state
     , staging_table.lia_street1
     , staging_table.lia_street2
     , staging_table.lia_holder_name
     , staging_table.lia_holder_phone
     , staging_table.lia_holder_phone_extension
     , staging_table.lia_holder_fax
     , staging_table.lia_holder_email
     , staging_table.lia_account_opened_date
     , staging_table.lia_liability_disposition_type
     , staging_table.lia_liability_type
     , staging_table.lia_monthly_payment_amount
     , staging_table.lia_remaining_term_months
     , staging_table.lia_high_balance_amount
     , staging_table.lia_credit_limit_amount
     , staging_table.lia_past_due_amount
     , staging_table.lia_unpaid_balance_amount
     , staging_table.lia_report_value_overridden
     , staging_table.lia_bankruptcy_exception_type
     , staging_table.lia_note
     , staging_table.lia_terms_months_count
     , staging_table.lia_payoff_amount
     , staging_table.lia_energy_related_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.liability_new staging_table
LEFT JOIN history_octane.liability_new history_table
          ON staging_table.lia_pid = history_table.lia_pid AND staging_table.lia_version = history_table.lia_version
WHERE history_table.lia_pid IS NULL
UNION ALL
SELECT history_table.lia_pid
     , history_table.lia_version + 1
     , history_table.lia_proposal_pid
     , history_table.lia_account_id
     , history_table.lia_aggregate_description
     , history_table.lia_credit_request_liability_pid
     , history_table.lia_description
     , history_table.lia_city
     , history_table.lia_country
     , history_table.lia_postal_code
     , history_table.lia_state
     , history_table.lia_street1
     , history_table.lia_street2
     , history_table.lia_holder_name
     , history_table.lia_holder_phone
     , history_table.lia_holder_phone_extension
     , history_table.lia_holder_fax
     , history_table.lia_holder_email
     , history_table.lia_account_opened_date
     , history_table.lia_liability_disposition_type
     , history_table.lia_liability_type
     , history_table.lia_monthly_payment_amount
     , history_table.lia_remaining_term_months
     , history_table.lia_high_balance_amount
     , history_table.lia_credit_limit_amount
     , history_table.lia_past_due_amount
     , history_table.lia_unpaid_balance_amount
     , history_table.lia_report_value_overridden
     , history_table.lia_bankruptcy_exception_type
     , history_table.lia_note
     , history_table.lia_terms_months_count
     , history_table.lia_payoff_amount
     , history_table.lia_energy_related_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.liability_new history_table
LEFT JOIN staging_octane.liability_new staging_table
          ON staging_table.lia_pid = history_table.lia_pid
WHERE staging_table.lia_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.liability_new deleted_records
                  WHERE deleted_records.lia_pid = history_table.lia_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
')
     , ('liability_place', 'SP-100823', 'lip_pid', '--finding records to insert into history_octane.liability_place
SELECT staging_table.lip_pid
     , staging_table.lip_version
     , staging_table.lip_liability_pid
     , staging_table.lip_creditor_pid
     , staging_table.lip_place_pid
     , staging_table.lip_lien_priority_type
     , staging_table.lip_liability_financing_type
     , staging_table.lip_liability_foreclosure_exception_type
     , staging_table.lip_liability_mi_type
     , staging_table.lip_original_loan_amount
     , staging_table.lip_property_taxes_escrowed
     , staging_table.lip_property_insurance_escrowed
     , staging_table.lip_senior_lien_restriction_type
     , staging_table.lip_senior_lien_restriction_amount
     , staging_table.lip_texas_equity
     , staging_table.lip_texas_equity_conversion
     , staging_table.lip_texas_equity_locked
     , staging_table.lip_third_party_community_second_program_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.liability_place staging_table
LEFT JOIN history_octane.liability_place history_table
          ON staging_table.lip_pid = history_table.lip_pid AND staging_table.lip_version = history_table.lip_version
WHERE history_table.lip_pid IS NULL
UNION ALL
SELECT history_table.lip_pid
     , history_table.lip_version + 1
     , history_table.lip_liability_pid
     , history_table.lip_creditor_pid
     , history_table.lip_place_pid
     , history_table.lip_lien_priority_type
     , history_table.lip_liability_financing_type
     , history_table.lip_liability_foreclosure_exception_type
     , history_table.lip_liability_mi_type
     , history_table.lip_original_loan_amount
     , history_table.lip_property_taxes_escrowed
     , history_table.lip_property_insurance_escrowed
     , history_table.lip_senior_lien_restriction_type
     , history_table.lip_senior_lien_restriction_amount
     , history_table.lip_texas_equity
     , history_table.lip_texas_equity_conversion
     , history_table.lip_texas_equity_locked
     , history_table.lip_third_party_community_second_program_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.liability_place history_table
LEFT JOIN staging_octane.liability_place staging_table
          ON staging_table.lip_pid = history_table.lip_pid
WHERE staging_table.lip_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.liability_place deleted_records
                  WHERE deleted_records.lip_pid = history_table.lip_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
')
     , ('liability_mortgage_payoff', 'SP-100824', 'lmp_pid', '--finding records to insert into history_octane.liability_mortgage_payoff
SELECT staging_table.lmp_pid
     , staging_table.lmp_version
     , staging_table.lmp_liability_pid
     , staging_table.lmp_interest_rate_on_statement
     , staging_table.lmp_interest_rate_percent
     , staging_table.lmp_loan_amortization_type
     , staging_table.lmp_interest_only
     , staging_table.lmp_agency_case_id
     , staging_table.lmp_payoff_statement_date
     , staging_table.lmp_payoff_statement_good_through_date
     , staging_table.lmp_next_payment_due_date
     , staging_table.lmp_payoff_statement_interest
     , staging_table.lmp_daily_interest_amount
     , staging_table.lmp_monthly_interest_amount
     , staging_table.lmp_payoff_interest_pad_days
     , staging_table.lmp_effective_payoff_date
     , staging_table.lmp_effective_payoff_date_adjustment_amount
     , staging_table.lmp_effective_payoff_date_adjustment_days
     , staging_table.lmp_other_payoff_related_charges_amount
     , staging_table.lmp_unpaid_late_charges_amount
     , staging_table.lmp_mortgage_payoff_amount_estimated
     , staging_table.lmp_mip_due_amount
     , staging_table.lmp_used_to_acquire_property
     , staging_table.lmp_heloc_advance_last_12_months_over_thousand
     , staging_table.lmp_net_escrow
     , staging_table.lmp_current_escrow_balance_amount
     , staging_table.lmp_first_payment_date
     , staging_table.lmp_closing_date
     , staging_table.lmp_include_within_cema
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.liability_mortgage_payoff staging_table
LEFT JOIN history_octane.liability_mortgage_payoff history_table
          ON staging_table.lmp_pid = history_table.lmp_pid AND staging_table.lmp_version = history_table.lmp_version
WHERE history_table.lmp_pid IS NULL
UNION ALL
SELECT history_table.lmp_pid
     , history_table.lmp_version + 1
     , history_table.lmp_liability_pid
     , history_table.lmp_interest_rate_on_statement
     , history_table.lmp_interest_rate_percent
     , history_table.lmp_loan_amortization_type
     , history_table.lmp_interest_only
     , history_table.lmp_agency_case_id
     , history_table.lmp_payoff_statement_date
     , history_table.lmp_payoff_statement_good_through_date
     , history_table.lmp_next_payment_due_date
     , history_table.lmp_payoff_statement_interest
     , history_table.lmp_daily_interest_amount
     , history_table.lmp_monthly_interest_amount
     , history_table.lmp_payoff_interest_pad_days
     , history_table.lmp_effective_payoff_date
     , history_table.lmp_effective_payoff_date_adjustment_amount
     , history_table.lmp_effective_payoff_date_adjustment_days
     , history_table.lmp_other_payoff_related_charges_amount
     , history_table.lmp_unpaid_late_charges_amount
     , history_table.lmp_mortgage_payoff_amount_estimated
     , history_table.lmp_mip_due_amount
     , history_table.lmp_used_to_acquire_property
     , history_table.lmp_heloc_advance_last_12_months_over_thousand
     , history_table.lmp_net_escrow
     , history_table.lmp_current_escrow_balance_amount
     , history_table.lmp_first_payment_date
     , history_table.lmp_closing_date
     , history_table.lmp_include_within_cema
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.liability_mortgage_payoff history_table
LEFT JOIN staging_octane.liability_mortgage_payoff staging_table
          ON staging_table.lmp_pid = history_table.lmp_pid
WHERE staging_table.lmp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.liability_mortgage_payoff deleted_records
                  WHERE deleted_records.lmp_pid = history_table.lmp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
');

-- Insert process rows for all new tables
INSERT
INTO mdi.process (name, description)
SELECT process_name, 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
FROM temp_mdi_data;

-- Update temp_mdi_data table with newly-inserted process dwids to avoid repetitive joins later
UPDATE temp_mdi_data
SET process_dwid = process.dwid
FROM mdi.process
WHERE temp_mdi_data.process_name = process.name;

-- Insert table_input_step rows for all new tables
INSERT
INTO mdi.table_input_step (process_dwid,
                           data_source_dwid,
                           sql,
                           limit_size,
                           execute_for_each_row,
                           replace_variables,
                           enable_lazy_conversion,
                           cached_row_meta,
                           connectionname)
SELECT temp_mdi_data.process_dwid
     , 0
     , temp_mdi_data.input_sql
     , 0
     , 'N'
     , 'N'
     , 'N'
     , 'N'
     , 'Staging DB Connection'
FROM temp_mdi_data;

-- Insert table_output_step rows for all new tables
INSERT
INTO mdi.table_output_step (process_dwid,
                            target_schema,
                            target_table,
                            commit_size,
                            partitioning_field,
                            table_name_field,
                            auto_generated_key_field,
                            partition_data_per,
                            table_name_defined_in_field,
                            return_auto_generated_key_field,
                            truncate_table,
                            connectionname,
                            partition_over_tables,
                            specify_database_fields,
                            ignore_insert_errors,
                            use_batch_update)
SELECT temp_mdi_data.process_dwid
     , 'history_octane'
     , temp_mdi_data.table_name
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
FROM temp_mdi_data;

-- Insert table_output_field rows for all new tables
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, temp_field_data.field_name, temp_field_data.field_name, temp_field_data.field_order, FALSE
FROM temp_mdi_data
JOIN temp_field_data
     ON temp_mdi_data.table_name = temp_field_data.table_name
JOIN mdi.table_output_step
     ON temp_mdi_data.table_name = table_output_step.target_table
         AND table_output_step.target_schema = 'history_octane'
WHERE temp_field_data.field_name <> 'crl_temp_liability_pid';
-- this field was deleted from staging_octane.credit_request_liability

-- Insert state_machine_definition rows for all new tables
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT temp_mdi_data.process_dwid
     , 'Octane ' || temp_mdi_data.table_name
     , 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
FROM temp_mdi_data;

-- Insert state_machine_step rows for all new tables
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT temp_mdi_data.process_dwid, NULL
FROM temp_mdi_data;

-- Insert json_output_field rows for all new tables
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT temp_mdi_data.process_dwid, temp_mdi_data.json_output_field
FROM temp_mdi_data;

--
-- UPDATE CONFIGS REFERENCING proposal.prp_construction_budget_url TO REFLECT RENAME TO proposal.prp_cr_tracker_url
--

-- rename proposal field in edw_field_definition
UPDATE mdi.edw_field_definition
SET field_name = 'prp_cr_tracker_url'
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
  AND edw_field_definition.field_name = 'prp_construction_budget_url'
  AND edw_table_definition.table_name = 'proposal';

UPDATE mdi.table_input_step
SET sql = '--finding records to insert into history_octane.proposal
SELECT staging_table.prp_pid
     , staging_table.prp_version
     , staging_table.prp_decision_lp_request_pid
     , staging_table.prp_decision_du_request_pid
     , staging_table.prp_proposal_type
     , staging_table.prp_description
     , staging_table.prp_doc_level_type
     , staging_table.prp_loan_purpose_type
     , staging_table.prp_name
     , staging_table.prp_create_datetime
     , staging_table.prp_effective_funding_date
     , staging_table.prp_estimated_funding_date
     , staging_table.prp_calculated_earliest_allowed_consummation_date
     , staging_table.prp_overridden_earliest_allowed_consummation_date
     , staging_table.prp_effective_earliest_allowed_consummation_date
     , staging_table.prp_earliest_allowed_consummation_date_override_reason
     , staging_table.prp_last_requested_disclosure_date
     , staging_table.prp_closing_document_sign_datetime
     , staging_table.prp_scheduled_closing_document_sign_datetime
     , staging_table.prp_rescission_through_date
     , staging_table.prp_rescission_notification_date
     , staging_table.prp_rescission_notification_by
     , staging_table.prp_rescission_notification_type
     , staging_table.prp_rescission_effective_date
     , staging_table.prp_first_payment_date
     , staging_table.prp_first_payment_date_auto_compute
     , staging_table.prp_property_usage_type
     , staging_table.prp_estimated_property_value_amount
     , staging_table.prp_smart_charges_enabled
     , staging_table.prp_charges_updated_datetime
     , staging_table.prp_smart_docs_enabled
     , staging_table.prp_docs_enabled_datetime
     , staging_table.prp_request_fha_mip_refund_required
     , staging_table.prp_request_recording_fees_required
     , staging_table.prp_request_property_taxes_required
     , staging_table.prp_property_tax_request_error_messages
     , staging_table.prp_fha_mip_refund_request_input_error
     , staging_table.prp_recording_fees_request_input_error
     , staging_table.prp_property_taxes_request_input_error
     , staging_table.prp_publish
     , staging_table.prp_publish_date
     , staging_table.prp_ipc_auto_compute
     , staging_table.prp_ipc_limit_percent
     , staging_table.prp_ipc_maximum_amount_allowed
     , staging_table.prp_ipc_amount
     , staging_table.prp_ipc_percent
     , staging_table.prp_ipc_financing_concession_amount
     , staging_table.prp_ipc_non_cash_concession_amount
     , staging_table.prp_sale_price_amount
     , staging_table.prp_structure_type
     , staging_table.prp_deal_pid
     , staging_table.prp_gfe_interest_rate_expiration_date
     , staging_table.prp_gfe_lock_duration_days
     , staging_table.prp_gfe_lock_before_settlement_days
     , staging_table.prp_proposal_expiration_date
     , staging_table.prp_uuts_master_contact_name
     , staging_table.prp_uuts_master_contact_title
     , staging_table.prp_uuts_master_office_phone
     , staging_table.prp_uuts_master_office_phone_extension
     , staging_table.prp_underwrite_risk_assessment_type
     , staging_table.prp_underwriting_comments
     , staging_table.prp_reserves_auto_compute
     , staging_table.prp_reserves_amount
     , staging_table.prp_reserves_months
     , staging_table.prp_underwrite_disposition_type
     , staging_table.prp_underwrite_publish_date
     , staging_table.prp_underwrite_expiration_date
     , staging_table.prp_usda_gsa_sam_exclusion
     , staging_table.prp_usda_gsa_sam_checked_date
     , staging_table.prp_usda_rd_single_family_housing_type
     , staging_table.prp_underwrite_method_type
     , staging_table.prp_mi_required
     , staging_table.prp_decision_credit_score_borrower_pid
     , staging_table.prp_decision_credit_score
     , staging_table.prp_estimated_credit_score
     , staging_table.prp_effective_credit_score
     , staging_table.prp_mortgagee_builder_seller_relationship
     , staging_table.prp_fha_prior_agency_case_id
     , staging_table.prp_fha_prior_agency_case_endorsement_date
     , staging_table.prp_fha_refinance_authorization_number
     , staging_table.prp_fha_refinance_authorization_expiration_date
     , staging_table.prp_fhac_refinance_authorization_messages
     , staging_table.prp_fha_203k_consultant_id
     , staging_table.prp_hud_fha_de_approval_type
     , staging_table.prp_owner_occupancy_not_required
     , staging_table.prp_va_monthly_utilities_included
     , staging_table.prp_va_maintenance_utilities_auto_compute
     , staging_table.prp_va_monthly_maintenance_utilities_amount
     , staging_table.prp_va_maintenance_utilities_per_square_feet_amount
     , staging_table.prp_household_size_count
     , staging_table.prp_va_past_credit_record_type
     , staging_table.prp_va_meets_credit_standards
     , staging_table.prp_va_prior_paid_in_full_loan_number
     , staging_table.prp_note_date
     , staging_table.prp_security_instrument_type
     , staging_table.prp_trustee_pid
     , staging_table.prp_trustee_name
     , staging_table.prp_trustee_address_street1
     , staging_table.prp_trustee_address_street2
     , staging_table.prp_trustee_address_city
     , staging_table.prp_trustee_address_state
     , staging_table.prp_trustee_address_postal_code
     , staging_table.prp_trustee_address_country
     , staging_table.prp_trustee_mers_org_id
     , staging_table.prp_trustee_phone_number
     , staging_table.prp_fre_ctp_closing_feature_type
     , staging_table.prp_fre_ctp_closing_type
     , staging_table.prp_fre_ctp_first_payment_due_date
     , staging_table.prp_purchase_contract_date
     , staging_table.prp_purchase_contract_financing_contingency_date
     , staging_table.prp_purchase_contract_funding_date
     , staging_table.prp_effective_property_value_type
     , staging_table.prp_effective_property_value_amount
     , staging_table.prp_decision_appraised_value_amount
     , staging_table.prp_fha_va_reasonable_value_amount
     , staging_table.prp_cd_clear_date
     , staging_table.prp_disaster_declaration_check_date_type
     , staging_table.prp_disaster_declaration_check_date
     , staging_table.prp_any_disaster_declaration_before_appraisal
     , staging_table.prp_any_disaster_declaration_after_appraisal
     , staging_table.prp_any_disaster_declaration
     , staging_table.prp_early_first_payment
     , staging_table.prp_property_acquired_through_inheritance
     , staging_table.prp_property_acquired_through_ancillary_relief
     , staging_table.prp_delayed_financing_exception_guidelines_applicable
     , staging_table.prp_delayed_financing_exception_verified
     , staging_table.prp_effective_property_value_explanation_type
     , staging_table.prp_taxes_escrowed
     , staging_table.prp_flood_insurance_applicable
     , staging_table.prp_windstorm_insurance_applicable
     , staging_table.prp_earthquake_insurance_applicable
     , staging_table.prp_arms_length
     , staging_table.prp_fha_non_arms_length_ltv_exception_type
     , staging_table.prp_fha_non_arms_length_ltv_exception_verified
     , staging_table.prp_escrow_cushion_months
     , staging_table.prp_escrow_cushion_months_auto_compute
     , staging_table.prp_fha_eligible_maximum_financing
     , staging_table.prp_hazard_insurance_applicable
     , staging_table.prp_property_repairs_required_type
     , staging_table.prp_property_repairs_description
     , staging_table.prp_property_repairs_cost_amount
     , staging_table.prp_property_repairs_holdback_calc_type
     , staging_table.prp_property_repairs_holdback_amount
     , staging_table.prp_property_repairs_holdback_payer_type
     , staging_table.prp_property_repairs_holdback_administrator
     , staging_table.prp_property_repairs_holdback_required_completion_date
     , staging_table.prp_property_repairs_completed_notification_date
     , staging_table.prp_property_repairs_inspection_ordered_date
     , staging_table.prp_property_repairs_inspection_completed_date
     , staging_table.prp_property_repairs_funds_released_contractor_date
     , staging_table.prp_anti_steering_lowest_rate_option_rate_percent
     , staging_table.prp_anti_steering_lowest_rate_option_fee_amount
     , staging_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
     , staging_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
     , staging_table.prp_anti_steering_lowest_cost_option_rate_percent
     , staging_table.prp_anti_steering_lowest_cost_option_fee_amount
     , staging_table.prp_initial_uw_submit_datetime
     , staging_table.prp_va_notice_of_value_source_type
     , staging_table.prp_va_notice_of_value_date
     , staging_table.prp_va_notice_of_value_estimated_reasonable_value_amount
     , staging_table.prp_sar_significant_adjustments
     , staging_table.prp_separate_transaction_for_land_acquisition
     , staging_table.prp_land_acquisition_transaction_date
     , staging_table.prp_land_acquisition_price
     , staging_table.prp_cash_out_reason_home_improvement
     , staging_table.prp_cash_out_reason_debt_or_debt_consolidation
     , staging_table.prp_cash_out_reason_personal_use
     , staging_table.prp_cash_out_reason_future_investment_not_under_contract
     , staging_table.prp_cash_out_reason_future_investment_under_contract
     , staging_table.prp_cash_out_reason_other
     , staging_table.prp_cash_out_reason_other_text
     , staging_table.prp_decision_veteran_borrower_pid
     , staging_table.prp_signed_closing_doc_received_datetime
     , staging_table.prp_other_lender_requires_appraisal
     , staging_table.prp_other_lender_requires_appraisal_reason
     , staging_table.prp_texas_equity_determination_datetime
     , staging_table.prp_texas_equity_conversion_determination_datetime
     , staging_table.prp_texas_equity_determination_datetime_override
     , staging_table.prp_texas_equity_determination_datetime_override_reason
     , staging_table.prp_texas_equity_conversion_determination_datetime_override
     , staging_table.prp_texas_equity_conversion_determ_datetime_override_reason
     , staging_table.prp_cema
     , staging_table.prp_cema_borrower_savings
     , staging_table.prp_any_vesting_changes
     , staging_table.prp_vesting_change_titleholder_added
     , staging_table.prp_vesting_change_titleholder_removed
     , staging_table.prp_vesting_change_titleholder_name_change
     , staging_table.prp_deed_taxes_applicable
     , staging_table.prp_deed_taxes_applicable_explanation
     , staging_table.prp_deed_taxes_auto_compute
     , staging_table.prp_deed_taxes_auto_compute_override_reason
     , staging_table.prp_intent_to_proceed_date
     , staging_table.prp_intent_to_proceed_type
     , staging_table.prp_intent_to_proceed_provider_unparsed_name
     , staging_table.prp_intent_to_proceed_obtainer_unparsed_name
     , staging_table.prp_cash_out_reason_student_loans
     , staging_table.prp_household_income_exclusive_edit
     , staging_table.prp_purchase_contract_received_date
     , staging_table.prp_down_payment_percent_mode
     , staging_table.prp_lender_escrow_loan_amount
     , staging_table.prp_underwrite_disposition_note
     , staging_table.prp_rescission_applicable
     , staging_table.prp_area_median_income
     , staging_table.prp_total_income_to_ami_ratio
     , staging_table.prp_cr_tracker_url
     , staging_table.prp_construction_borrower_contribution_amount
     , staging_table.prp_construction_lot_ownership_status_type
     , staging_table.prp_intent_to_proceed_provided
     , staging_table.prp_effective_signing_location_state
     , staging_table.prp_effective_signing_location_city
     , staging_table.prp_va_required_guaranty_amount
     , staging_table.prp_va_amount_used_to_calculate_maximum_guaranty
     , staging_table.prp_va_actual_guaranty_amount
     , staging_table.prp_last_corrective_disclosure_processed_datetime
     , staging_table.prp_user_entered_note_date
     , staging_table.prp_effective_note_date
     , staging_table.prp_lender_escrow_loan_due_date
     , staging_table.prp_va_maximum_base_loan_amount
     , staging_table.prp_va_maximum_funding_fee_amount
     , staging_table.prp_va_maximum_total_loan_amount
     , staging_table.prp_va_required_cash_amount
     , staging_table.prp_va_guaranty_percent
     , staging_table.prp_gse_version_type
     , staging_table.prp_minimum_household_income_amount
     , staging_table.prp_minimum_residual_income_amount
     , staging_table.prp_minimum_residual_income_auto_compute
     , staging_table.prp_financed_property_improvements_category_type
     , staging_table.prp_adjusted_as_is_value_amount
     , staging_table.prp_after_improved_value_amount
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_pid
     , history_table.prp_version + 1
     , history_table.prp_decision_lp_request_pid
     , history_table.prp_decision_du_request_pid
     , history_table.prp_proposal_type
     , history_table.prp_description
     , history_table.prp_doc_level_type
     , history_table.prp_loan_purpose_type
     , history_table.prp_name
     , history_table.prp_create_datetime
     , history_table.prp_effective_funding_date
     , history_table.prp_estimated_funding_date
     , history_table.prp_calculated_earliest_allowed_consummation_date
     , history_table.prp_overridden_earliest_allowed_consummation_date
     , history_table.prp_effective_earliest_allowed_consummation_date
     , history_table.prp_earliest_allowed_consummation_date_override_reason
     , history_table.prp_last_requested_disclosure_date
     , history_table.prp_closing_document_sign_datetime
     , history_table.prp_scheduled_closing_document_sign_datetime
     , history_table.prp_rescission_through_date
     , history_table.prp_rescission_notification_date
     , history_table.prp_rescission_notification_by
     , history_table.prp_rescission_notification_type
     , history_table.prp_rescission_effective_date
     , history_table.prp_first_payment_date
     , history_table.prp_first_payment_date_auto_compute
     , history_table.prp_property_usage_type
     , history_table.prp_estimated_property_value_amount
     , history_table.prp_smart_charges_enabled
     , history_table.prp_charges_updated_datetime
     , history_table.prp_smart_docs_enabled
     , history_table.prp_docs_enabled_datetime
     , history_table.prp_request_fha_mip_refund_required
     , history_table.prp_request_recording_fees_required
     , history_table.prp_request_property_taxes_required
     , history_table.prp_property_tax_request_error_messages
     , history_table.prp_fha_mip_refund_request_input_error
     , history_table.prp_recording_fees_request_input_error
     , history_table.prp_property_taxes_request_input_error
     , history_table.prp_publish
     , history_table.prp_publish_date
     , history_table.prp_ipc_auto_compute
     , history_table.prp_ipc_limit_percent
     , history_table.prp_ipc_maximum_amount_allowed
     , history_table.prp_ipc_amount
     , history_table.prp_ipc_percent
     , history_table.prp_ipc_financing_concession_amount
     , history_table.prp_ipc_non_cash_concession_amount
     , history_table.prp_sale_price_amount
     , history_table.prp_structure_type
     , history_table.prp_deal_pid
     , history_table.prp_gfe_interest_rate_expiration_date
     , history_table.prp_gfe_lock_duration_days
     , history_table.prp_gfe_lock_before_settlement_days
     , history_table.prp_proposal_expiration_date
     , history_table.prp_uuts_master_contact_name
     , history_table.prp_uuts_master_contact_title
     , history_table.prp_uuts_master_office_phone
     , history_table.prp_uuts_master_office_phone_extension
     , history_table.prp_underwrite_risk_assessment_type
     , history_table.prp_underwriting_comments
     , history_table.prp_reserves_auto_compute
     , history_table.prp_reserves_amount
     , history_table.prp_reserves_months
     , history_table.prp_underwrite_disposition_type
     , history_table.prp_underwrite_publish_date
     , history_table.prp_underwrite_expiration_date
     , history_table.prp_usda_gsa_sam_exclusion
     , history_table.prp_usda_gsa_sam_checked_date
     , history_table.prp_usda_rd_single_family_housing_type
     , history_table.prp_underwrite_method_type
     , history_table.prp_mi_required
     , history_table.prp_decision_credit_score_borrower_pid
     , history_table.prp_decision_credit_score
     , history_table.prp_estimated_credit_score
     , history_table.prp_effective_credit_score
     , history_table.prp_mortgagee_builder_seller_relationship
     , history_table.prp_fha_prior_agency_case_id
     , history_table.prp_fha_prior_agency_case_endorsement_date
     , history_table.prp_fha_refinance_authorization_number
     , history_table.prp_fha_refinance_authorization_expiration_date
     , history_table.prp_fhac_refinance_authorization_messages
     , history_table.prp_fha_203k_consultant_id
     , history_table.prp_hud_fha_de_approval_type
     , history_table.prp_owner_occupancy_not_required
     , history_table.prp_va_monthly_utilities_included
     , history_table.prp_va_maintenance_utilities_auto_compute
     , history_table.prp_va_monthly_maintenance_utilities_amount
     , history_table.prp_va_maintenance_utilities_per_square_feet_amount
     , history_table.prp_household_size_count
     , history_table.prp_va_past_credit_record_type
     , history_table.prp_va_meets_credit_standards
     , history_table.prp_va_prior_paid_in_full_loan_number
     , history_table.prp_note_date
     , history_table.prp_security_instrument_type
     , history_table.prp_trustee_pid
     , history_table.prp_trustee_name
     , history_table.prp_trustee_address_street1
     , history_table.prp_trustee_address_street2
     , history_table.prp_trustee_address_city
     , history_table.prp_trustee_address_state
     , history_table.prp_trustee_address_postal_code
     , history_table.prp_trustee_address_country
     , history_table.prp_trustee_mers_org_id
     , history_table.prp_trustee_phone_number
     , history_table.prp_fre_ctp_closing_feature_type
     , history_table.prp_fre_ctp_closing_type
     , history_table.prp_fre_ctp_first_payment_due_date
     , history_table.prp_purchase_contract_date
     , history_table.prp_purchase_contract_financing_contingency_date
     , history_table.prp_purchase_contract_funding_date
     , history_table.prp_effective_property_value_type
     , history_table.prp_effective_property_value_amount
     , history_table.prp_decision_appraised_value_amount
     , history_table.prp_fha_va_reasonable_value_amount
     , history_table.prp_cd_clear_date
     , history_table.prp_disaster_declaration_check_date_type
     , history_table.prp_disaster_declaration_check_date
     , history_table.prp_any_disaster_declaration_before_appraisal
     , history_table.prp_any_disaster_declaration_after_appraisal
     , history_table.prp_any_disaster_declaration
     , history_table.prp_early_first_payment
     , history_table.prp_property_acquired_through_inheritance
     , history_table.prp_property_acquired_through_ancillary_relief
     , history_table.prp_delayed_financing_exception_guidelines_applicable
     , history_table.prp_delayed_financing_exception_verified
     , history_table.prp_effective_property_value_explanation_type
     , history_table.prp_taxes_escrowed
     , history_table.prp_flood_insurance_applicable
     , history_table.prp_windstorm_insurance_applicable
     , history_table.prp_earthquake_insurance_applicable
     , history_table.prp_arms_length
     , history_table.prp_fha_non_arms_length_ltv_exception_type
     , history_table.prp_fha_non_arms_length_ltv_exception_verified
     , history_table.prp_escrow_cushion_months
     , history_table.prp_escrow_cushion_months_auto_compute
     , history_table.prp_fha_eligible_maximum_financing
     , history_table.prp_hazard_insurance_applicable
     , history_table.prp_property_repairs_required_type
     , history_table.prp_property_repairs_description
     , history_table.prp_property_repairs_cost_amount
     , history_table.prp_property_repairs_holdback_calc_type
     , history_table.prp_property_repairs_holdback_amount
     , history_table.prp_property_repairs_holdback_payer_type
     , history_table.prp_property_repairs_holdback_administrator
     , history_table.prp_property_repairs_holdback_required_completion_date
     , history_table.prp_property_repairs_completed_notification_date
     , history_table.prp_property_repairs_inspection_ordered_date
     , history_table.prp_property_repairs_inspection_completed_date
     , history_table.prp_property_repairs_funds_released_contractor_date
     , history_table.prp_anti_steering_lowest_rate_option_rate_percent
     , history_table.prp_anti_steering_lowest_rate_option_fee_amount
     , history_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
     , history_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
     , history_table.prp_anti_steering_lowest_cost_option_rate_percent
     , history_table.prp_anti_steering_lowest_cost_option_fee_amount
     , history_table.prp_initial_uw_submit_datetime
     , history_table.prp_va_notice_of_value_source_type
     , history_table.prp_va_notice_of_value_date
     , history_table.prp_va_notice_of_value_estimated_reasonable_value_amount
     , history_table.prp_sar_significant_adjustments
     , history_table.prp_separate_transaction_for_land_acquisition
     , history_table.prp_land_acquisition_transaction_date
     , history_table.prp_land_acquisition_price
     , history_table.prp_cash_out_reason_home_improvement
     , history_table.prp_cash_out_reason_debt_or_debt_consolidation
     , history_table.prp_cash_out_reason_personal_use
     , history_table.prp_cash_out_reason_future_investment_not_under_contract
     , history_table.prp_cash_out_reason_future_investment_under_contract
     , history_table.prp_cash_out_reason_other
     , history_table.prp_cash_out_reason_other_text
     , history_table.prp_decision_veteran_borrower_pid
     , history_table.prp_signed_closing_doc_received_datetime
     , history_table.prp_other_lender_requires_appraisal
     , history_table.prp_other_lender_requires_appraisal_reason
     , history_table.prp_texas_equity_determination_datetime
     , history_table.prp_texas_equity_conversion_determination_datetime
     , history_table.prp_texas_equity_determination_datetime_override
     , history_table.prp_texas_equity_determination_datetime_override_reason
     , history_table.prp_texas_equity_conversion_determination_datetime_override
     , history_table.prp_texas_equity_conversion_determ_datetime_override_reason
     , history_table.prp_cema
     , history_table.prp_cema_borrower_savings
     , history_table.prp_any_vesting_changes
     , history_table.prp_vesting_change_titleholder_added
     , history_table.prp_vesting_change_titleholder_removed
     , history_table.prp_vesting_change_titleholder_name_change
     , history_table.prp_deed_taxes_applicable
     , history_table.prp_deed_taxes_applicable_explanation
     , history_table.prp_deed_taxes_auto_compute
     , history_table.prp_deed_taxes_auto_compute_override_reason
     , history_table.prp_intent_to_proceed_date
     , history_table.prp_intent_to_proceed_type
     , history_table.prp_intent_to_proceed_provider_unparsed_name
     , history_table.prp_intent_to_proceed_obtainer_unparsed_name
     , history_table.prp_cash_out_reason_student_loans
     , history_table.prp_household_income_exclusive_edit
     , history_table.prp_purchase_contract_received_date
     , history_table.prp_down_payment_percent_mode
     , history_table.prp_lender_escrow_loan_amount
     , history_table.prp_underwrite_disposition_note
     , history_table.prp_rescission_applicable
     , history_table.prp_area_median_income
     , history_table.prp_total_income_to_ami_ratio
     , history_table.prp_cr_tracker_url
     , history_table.prp_construction_borrower_contribution_amount
     , history_table.prp_construction_lot_ownership_status_type
     , history_table.prp_intent_to_proceed_provided
     , history_table.prp_effective_signing_location_state
     , history_table.prp_effective_signing_location_city
     , history_table.prp_va_required_guaranty_amount
     , history_table.prp_va_amount_used_to_calculate_maximum_guaranty
     , history_table.prp_va_actual_guaranty_amount
     , history_table.prp_last_corrective_disclosure_processed_datetime
     , history_table.prp_user_entered_note_date
     , history_table.prp_effective_note_date
     , history_table.prp_lender_escrow_loan_due_date
     , history_table.prp_va_maximum_base_loan_amount
     , history_table.prp_va_maximum_funding_fee_amount
     , history_table.prp_va_maximum_total_loan_amount
     , history_table.prp_va_required_cash_amount
     , history_table.prp_va_guaranty_percent
     , history_table.prp_gse_version_type
     , history_table.prp_minimum_household_income_amount
     , history_table.prp_minimum_residual_income_amount
     , history_table.prp_minimum_residual_income_auto_compute
     , history_table.prp_financed_property_improvements_category_type
     , history_table.prp_adjusted_as_is_value_amount
     , history_table.prp_after_improved_value_amount
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal deleted_records
                  WHERE deleted_records.prp_pid = history_table.prp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
'
FROM mdi.process
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid
WHERE process.dwid = table_input_step.process_dwid
  AND table_output_step.target_table = 'proposal'
  AND table_output_step.target_schema = 'history_octane';

-- rename proposal field in table_output_field
UPDATE mdi.table_output_field
SET database_field_name = 'prp_cr_tracker_url'
  , database_stream_name = 'prp_cr_tracker_url'
WHERE database_field_name = 'prp_construction_budget_url';
