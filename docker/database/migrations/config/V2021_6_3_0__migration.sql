--
-- EDW | DML Changes - Octane schemas for 2021.5.1.1 (5/7/21)
-- https://app.asana.com/0/0/1200297951276317
--
-- NOTE: these metadata changes are being done significantly after the original
-- schema changes because the metadata infrastructure/update process was not fully
-- developed at the time of the original changes
--

-- Reset temp tables used in previous DML migration
DROP TABLE IF EXISTS temp_new_table_field_data;
DROP TABLE IF EXISTS temp_new_table_mdi_data;
DROP TABLE IF EXISTS temp_new_column_field_data;
DROP TABLE IF EXISTS temp_new_column_mdi_data;

--
-- INSERT EDW_TABLE_DEFINITION ROWS FOR NEW TABLES: construction_cost_calculation_type, proposal_hud_consultant
--

-- Insert edw_table_definition rows for construction_cost_calculation_type
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'construction_cost_calculation_type', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'construction_cost_calculation_type', staging_table.dwid
FROM staging_table;

-- Insert edw_table_definition rows for proposal_hud_consultant
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'proposal_hud_consultant', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'proposal_hud_consultant', staging_table.dwid
FROM staging_table;

--
-- INSERT EDW_FIELD_DEFINITION ROWS FOR NEW TABLES: construction_cost_calculation_type, proposal_hud_consultant
--

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_new_table_field_data (
    table_name TEXT,
    field_name TEXT,
    key_field_flag BOOLEAN,
    field_order INTEGER
);

INSERT
INTO temp_new_table_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('construction_cost_calculation_type', 'code', TRUE, 1)
     , ('construction_cost_calculation_type', 'value', FALSE, 2)
     , ('proposal_hud_consultant', 'phc_pid', TRUE, 1)
     , ('proposal_hud_consultant', 'phc_version', FALSE, 2)
     , ('proposal_hud_consultant', 'phc_proposal_pid', FALSE, 3)
     , ('proposal_hud_consultant', 'phc_consultant_id', FALSE, 4)
     , ('proposal_hud_consultant', 'phc_company_name', FALSE, 5)
     , ('proposal_hud_consultant', 'phc_first_name', FALSE, 6)
     , ('proposal_hud_consultant', 'phc_last_name', FALSE, 7)
     , ('proposal_hud_consultant', 'phc_email', FALSE, 8)
     , ('proposal_hud_consultant', 'phc_mobile_phone', FALSE, 9)
     , ('proposal_hud_consultant', 'phc_office_phone', FALSE, 10)
     , ('proposal_hud_consultant', 'phc_office_phone_extension', FALSE, 11)
     , ('proposal_hud_consultant', 'phc_fax', FALSE, 12)
     , ('proposal_hud_consultant', 'phc_address_street1', FALSE, 13)
     , ('proposal_hud_consultant', 'phc_address_street2', FALSE, 14)
     , ('proposal_hud_consultant', 'phc_address_city', FALSE, 15)
     , ('proposal_hud_consultant', 'phc_address_state', FALSE, 16)
     , ('proposal_hud_consultant', 'phc_address_postal_code', FALSE, 17);

-- Insert edw_field_definition data for new staging_octane tables
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_new_table_field_data.field_name, temp_new_table_field_data.key_field_flag
FROM temp_new_table_field_data
JOIN mdi.edw_table_definition
     ON temp_new_table_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'staging_octane';

-- Load history_octane-specific fields into temporary table before inserting history_octane field data
INSERT
INTO temp_new_table_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('construction_cost_calculation_type', 'data_source_updated_datetime', FALSE, 3)
     , ('construction_cost_calculation_type', 'data_source_deleted_flag', FALSE, 4)
     , ('proposal_hud_consultant', 'data_source_updated_datetime', FALSE, 18)
     , ('proposal_hud_consultant', 'data_source_deleted_flag', FALSE, 19);

-- Insert edw_field_definition data fo new history_octane tables
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
SELECT edw_table_definition.dwid
     , temp_new_table_field_data.field_name
     , temp_new_table_field_data.key_field_flag
     , source_field_definition.dwid
FROM temp_new_table_field_data
JOIN mdi.edw_table_definition
     ON temp_new_table_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'history_octane'
JOIN mdi.edw_table_definition source_table_definition
     ON edw_table_definition.table_name = source_table_definition.table_name
         AND source_table_definition.schema_name = 'staging_octane'
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND temp_new_table_field_data.field_name = source_field_definition.field_name;

--
-- INSERT MDI ETL CONFIG DATA FOR NEW TABLES: construction_cost_calculation_type, proposal_hud_consultant
--

-- Load field values that differ between processes into a temp table before inserting MDI config data
CREATE TEMPORARY TABLE temp_new_table_mdi_data (
    table_name TEXT,
    process_name TEXT,
    json_output_field TEXT,
    input_sql TEXT,
    process_dwid BIGINT
);

INSERT
INTO temp_new_table_mdi_data (table_name, process_name, json_output_field, input_sql)
VALUES ('construction_cost_calculation_type', 'SP-100827', 'code', 'SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.construction_cost_calculation_type staging_table
LEFT JOIN history_octane.construction_cost_calculation_type history_table
          ON staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;')
     , ('proposal_hud_consultant', 'SP-100828', 'phc_pid', '--finding records to insert into history_octane.proposal_hud_consultant
SELECT staging_table.phc_pid, staging_table.phc_version, staging_table.phc_proposal_pid, staging_table.phc_proposal_pid, staging_table.phc_consultant_id, staging_table.phc_company_name, staging_table.phc_first_name, staging_table.phc_last_name, staging_table.phc_email, staging_table.phc_mobile_phone, staging_table.phc_office_phone, staging_table.phc_office_phone_extension, staging_table.phc_fax, staging_table.phc_address_street1, staging_table.phc_address_street2, staging_table.phc_address_city, staging_table.phc_address_state, staging_table.phc_address_postal_code, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_hud_consultant staging_table
LEFT JOIN history_octane.proposal_hud_consultant history_table
          ON staging_table.phc_pid = history_table.phc_pid AND staging_table.phc_version = history_table.phc_version
WHERE history_table.phc_pid IS NULL
UNION ALL
SELECT history_table.phc_pid, history_table.phc_version + 1, history_table.phc_proposal_pid, history_table.phc_proposal_pid, history_table.phc_consultant_id, history_table.phc_company_name, history_table.phc_first_name, history_table.phc_last_name, history_table.phc_email, history_table.phc_mobile_phone, history_table.phc_office_phone, history_table.phc_office_phone_extension, history_table.phc_fax, history_table.phc_address_street1, history_table.phc_address_street2, history_table.phc_address_city, history_table.phc_address_state, history_table.phc_address_postal_code, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_hud_consultant history_table
LEFT JOIN staging_octane.proposal_hud_consultant staging_table
          ON staging_table.phc_pid = history_table.phc_pid
WHERE staging_table.phc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal_hud_consultant deleted_records
                  WHERE deleted_records.phc_pid = history_table.phc_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );');

-- Insert process rows for all new tables
INSERT
INTO mdi.process (name, description)
SELECT process_name, 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
FROM temp_new_table_mdi_data;

-- Update temp_mdi_data table with newly-inserted process dwids to avoid repetitive joins later
UPDATE temp_new_table_mdi_data
SET process_dwid = process.dwid
FROM mdi.process
WHERE temp_new_table_mdi_data.process_name = process.name;

-- Insert table_input_step rows for all new tables
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT temp_new_table_mdi_data.process_dwid
     , 0
     , temp_new_table_mdi_data.input_sql
     , 0
     , 'N'
     , 'N'
     , 'N'
     , 'N'
     , 'Staging DB Connection'
FROM temp_new_table_mdi_data;

-- Insert table_output_step rows for all new tables
INSERT
INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT temp_new_table_mdi_data.process_dwid
     , 'history_octane'
     , temp_new_table_mdi_data.table_name
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
FROM temp_new_table_mdi_data;

-- Insert table_output_field rows for all new tables
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid
     , temp_new_table_field_data.field_name
     , temp_new_table_field_data.field_name
     , temp_new_table_field_data.field_order
     , FALSE
FROM temp_new_table_mdi_data
JOIN temp_new_table_field_data
     ON temp_new_table_mdi_data.table_name = temp_new_table_field_data.table_name
JOIN mdi.table_output_step
     ON temp_new_table_mdi_data.table_name = table_output_step.target_table
         AND table_output_step.target_schema = 'history_octane';

-- Insert state_machine_definition rows for all new tables
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT temp_new_table_mdi_data.process_dwid
     , 'Octane__' || temp_new_table_mdi_data.table_name
     , 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
FROM temp_new_table_mdi_data;

-- Insert state_machine_step rows for all new tables
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT temp_new_table_mdi_data.process_dwid, NULL
FROM temp_new_table_mdi_data;

-- Insert json_output_field rows for all new tables
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT temp_new_table_mdi_data.process_dwid, temp_new_table_mdi_data.json_output_field
FROM temp_new_table_mdi_data;

--
-- INSERT EDW_FIELD_DEFINITION DATA FOR NEW COLUMNS:
-- - construction_cost.coc_calculation_percentage
-- - construction_cost.coc_construction_cost_calculation_type
-- - deal.d_initial_cancel_status_date
-- - proposal.prp_hud_consultant
-- - borrower.b_credit_report_required
-- - deal_key_roles.dkrs_internal_construction_manager_lender_user_pid
-- - deal_key_roles.dkrs_internal_construction_manager_fmls

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_new_column_field_data (
    table_name TEXT,
    field_name TEXT,
    key_field_flag BOOLEAN,
    field_order INTEGER
);

INSERT
INTO temp_new_column_field_data (table_name, field_name, key_field_flag)
VALUES ('construction_cost', 'coc_calculation_percentage', FALSE)
     , ('construction_cost', 'coc_construction_cost_calculation_type', FALSE)
     , ('deal', 'd_initial_cancel_status_date', FALSE)
     , ('proposal', 'prp_hud_consultant', FALSE)
     , ('borrower', 'b_credit_report_required', FALSE)
     , ('deal_key_roles', 'dkrs_internal_construction_manager_lender_user_pid', FALSE)
     , ('deal_key_roles', 'dkrs_internal_construction_manager_fmls', FALSE);

-- add field order to the temp table based on the maximum existing field order
WITH max_field_orders AS (
    SELECT table_output_step.target_table
         , MAX( table_output_field.field_order ) AS max_field_order
    FROM mdi.table_output_field
    JOIN mdi.table_output_step
         ON table_output_step.dwid = table_output_field.table_output_step_dwid
             AND table_output_step.target_schema = 'history_octane'
    JOIN temp_new_column_field_data
         ON table_output_step.target_table = temp_new_column_field_data.table_name
    GROUP BY table_output_step.target_table
)
   , new_column_field_orders AS (
    SELECT temp_new_column_field_data.field_name
         , ROW_NUMBER( ) OVER (PARTITION BY temp_new_column_field_data.table_name) + max_field_orders.max_field_order AS field_order
    FROM temp_new_column_field_data
    JOIN max_field_orders
         ON max_field_orders.target_table = temp_new_column_field_data.table_name
)
UPDATE temp_new_column_field_data
SET field_order = new_column_field_orders.field_order
FROM new_column_field_orders
WHERE temp_new_column_field_data.field_name = new_column_field_orders.field_name;

-- Insert edw_field_definition data for new staging_octane columns
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_new_column_field_data.field_name, temp_new_column_field_data.key_field_flag
FROM temp_new_column_field_data
JOIN mdi.edw_table_definition
     ON temp_new_column_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'staging_octane';

-- Insert edw_field_definition data for new history_octane columns
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
SELECT edw_table_definition.dwid
     , temp_new_column_field_data.field_name
     , temp_new_column_field_data.key_field_flag
     , source_field_definition.dwid
FROM temp_new_column_field_data
JOIN mdi.edw_table_definition
     ON temp_new_column_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'history_octane'
JOIN mdi.edw_table_definition source_table_definition
     ON edw_table_definition.table_name = source_table_definition.table_name
         AND source_table_definition.schema_name = 'staging_octane'
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND temp_new_column_field_data.field_name = source_field_definition.field_name;

--
-- INSERT/UPDATE MDI CONFIG DATA FOR NEW COLUMNS:
-- - construction_cost.coc_calculation_percentage
-- - construction_cost.coc_construction_cost_calculation_type
-- - deal.d_initial_cancel_status_date
-- - proposal.prp_hud_consultant
-- - borrower.b_credit_report_required
-- - deal_key_roles.dkrs_internal_construction_manager_lender_user_pid
-- - deal_key_roles.dkrs_internal_construction_manager_fmls
--

-- Load field values that differ between processes into a temp table before inserting MDI config data
CREATE TEMPORARY TABLE temp_new_column_mdi_data (
    process_name TEXT,
    input_sql TEXT
);

INSERT
INTO temp_new_column_mdi_data (process_name, input_sql)
-- construction_cost
VALUES ('SP-100161', '--finding records to insert into history_octane.construction_cost
SELECT staging_table.coc_pid, staging_table.coc_version, staging_table.coc_proposal_pid, staging_table.coc_construction_cost_category_type, staging_table.coc_construction_cost_funding_type, staging_table.coc_construction_cost_status_type, staging_table.coc_construction_cost_payee_type, staging_table.coc_create_datetime, staging_table.coc_construction_cost_amount, staging_table.coc_construction_cost_notes, staging_table.coc_contractor_pid, staging_table.coc_proposal_contractor_pid, staging_table.coc_payee, staging_table.coc_permit_pid, staging_table.coc_category_type_label, staging_table.coc_calculation_percentage, staging_table.coc_construction_cost_calculation_type, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.construction_cost staging_table
LEFT JOIN history_octane.construction_cost history_table
          ON staging_table.coc_pid = history_table.coc_pid AND staging_table.coc_version = history_table.coc_version
WHERE history_table.coc_pid IS NULL
UNION ALL
SELECT history_table.coc_pid, history_table.coc_version + 1, history_table.coc_proposal_pid, history_table.coc_construction_cost_category_type, history_table.coc_construction_cost_funding_type, history_table.coc_construction_cost_status_type, history_table.coc_construction_cost_payee_type, history_table.coc_create_datetime, history_table.coc_construction_cost_amount, history_table.coc_construction_cost_notes, history_table.coc_contractor_pid, history_table.coc_proposal_contractor_pid, history_table.coc_payee, history_table.coc_permit_pid, history_table.coc_category_type_label, history_table.coc_calculation_percentage, history_table.coc_construction_cost_calculation_type, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.construction_cost history_table
LEFT JOIN staging_octane.construction_cost staging_table
          ON staging_table.coc_pid = history_table.coc_pid
WHERE staging_table.coc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.construction_cost deleted_records
                  WHERE deleted_records.coc_pid = history_table.coc_pid AND deleted_records.data_source_deleted_flag = TRUE );')
     -- deal
     , ('SP-100267', '--finding records to insert into history_octane.deal
SELECT staging_table.d_pid, staging_table.d_version, staging_table.d_account_pid, staging_table.d_company_pid, staging_table.d_active_proposal_pid, staging_table.d_branch_pid, staging_table.d_deal_create_date, staging_table.d_deal_status_type, staging_table.d_velocify_lead_id, staging_table.d_lead_zillow_zq, staging_table.d_lead_tracking_id, staging_table.d_lead_reference_id, staging_table.d_los_loan_id_main, staging_table.d_los_loan_id_piggyback, staging_table.d_mers_min_main, staging_table.d_mers_min_piggyback, staging_table.d_external_loan_id_main, staging_table.d_external_loan_id_piggyback, staging_table.d_lead_source_pid, staging_table.d_disclosure_mode_date, staging_table.d_deal_status_date, staging_table.d_sap_deal, staging_table.d_hmda_action_date, staging_table.d_hmda_action_type, staging_table.d_hmda_denial_reason_type_1, staging_table.d_hmda_denial_reason_type_2, staging_table.d_hmda_denial_reason_type_3, staging_table.d_hmda_denial_reason_type_4, staging_table.d_borrower_esign, staging_table.d_application_type, staging_table.d_welcome_call_datetime, staging_table.d_realty_agent_scenario_type, staging_table.d_test_loan, staging_table.d_charges_enabled_date, staging_table.d_credit_bureau_type, staging_table.d_performer_team_pid, staging_table.d_deal_create_type, staging_table.d_hmda_denial_reason_other_description, staging_table.d_effective_hmda_action_date, staging_table.d_copy_source_los_loan_id_main, staging_table.d_copy_source_los_loan_id_piggyback, staging_table.d_referred_by_name, staging_table.d_hmda_universal_loan_id_main, staging_table.d_hmda_universal_loan_id_piggyback, staging_table.d_calyx_loan_guid, staging_table.d_invoices_enabled_date, staging_table.d_invoices_enabled, staging_table.d_training_loan, staging_table.d_deal_orphan_status_type, staging_table.d_deal_orphan_earliest_check_date, staging_table.d_deal_create_date_time, staging_table.d_early_wire_request, staging_table.d_enable_electronic_transaction, staging_table.d_initial_cancel_status_date, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal staging_table
LEFT JOIN history_octane.deal history_table
          ON staging_table.d_pid = history_table.d_pid AND staging_table.d_version = history_table.d_version
WHERE history_table.d_pid IS NULL
UNION ALL
SELECT history_table.d_pid, history_table.d_version + 1, history_table.d_account_pid, history_table.d_company_pid, history_table.d_active_proposal_pid, history_table.d_branch_pid, history_table.d_deal_create_date, history_table.d_deal_status_type, history_table.d_velocify_lead_id, history_table.d_lead_zillow_zq, history_table.d_lead_tracking_id, history_table.d_lead_reference_id, history_table.d_los_loan_id_main, history_table.d_los_loan_id_piggyback, history_table.d_mers_min_main, history_table.d_mers_min_piggyback, history_table.d_external_loan_id_main, history_table.d_external_loan_id_piggyback, history_table.d_lead_source_pid, history_table.d_disclosure_mode_date, history_table.d_deal_status_date, history_table.d_sap_deal, history_table.d_hmda_action_date, history_table.d_hmda_action_type, history_table.d_hmda_denial_reason_type_1, history_table.d_hmda_denial_reason_type_2, history_table.d_hmda_denial_reason_type_3, history_table.d_hmda_denial_reason_type_4, history_table.d_borrower_esign, history_table.d_application_type, history_table.d_welcome_call_datetime, history_table.d_realty_agent_scenario_type, history_table.d_test_loan, history_table.d_charges_enabled_date, history_table.d_credit_bureau_type, history_table.d_performer_team_pid, history_table.d_deal_create_type, history_table.d_hmda_denial_reason_other_description, history_table.d_effective_hmda_action_date, history_table.d_copy_source_los_loan_id_main, history_table.d_copy_source_los_loan_id_piggyback, history_table.d_referred_by_name, history_table.d_hmda_universal_loan_id_main, history_table.d_hmda_universal_loan_id_piggyback, history_table.d_calyx_loan_guid, history_table.d_invoices_enabled_date, history_table.d_invoices_enabled, history_table.d_training_loan, history_table.d_deal_orphan_status_type, history_table.d_deal_orphan_earliest_check_date, history_table.d_deal_create_date_time, history_table.d_early_wire_request, history_table.d_enable_electronic_transaction, history_table.d_initial_cancel_status_date, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.deal history_table
LEFT JOIN staging_octane.deal staging_table
          ON staging_table.d_pid = history_table.d_pid
WHERE staging_table.d_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.deal deleted_records
                  WHERE deleted_records.d_pid = history_table.d_pid AND deleted_records.data_source_deleted_flag = TRUE );')
     -- proposal (also remove prp_fha_203k_consultant_id in this step, since it is being deleted)
     , ('SP-100317', '--finding records to insert into history_octane.proposal
SELECT staging_table.prp_pid, staging_table.prp_version, staging_table.prp_decision_lp_request_pid, staging_table.prp_decision_du_request_pid, staging_table.prp_proposal_type, staging_table.prp_description, staging_table.prp_doc_level_type, staging_table.prp_loan_purpose_type, staging_table.prp_name, staging_table.prp_create_datetime, staging_table.prp_effective_funding_date, staging_table.prp_estimated_funding_date, staging_table.prp_calculated_earliest_allowed_consummation_date, staging_table.prp_overridden_earliest_allowed_consummation_date, staging_table.prp_effective_earliest_allowed_consummation_date, staging_table.prp_earliest_allowed_consummation_date_override_reason, staging_table.prp_last_requested_disclosure_date, staging_table.prp_closing_document_sign_datetime, staging_table.prp_scheduled_closing_document_sign_datetime, staging_table.prp_rescission_through_date, staging_table.prp_rescission_notification_date, staging_table.prp_rescission_notification_by, staging_table.prp_rescission_notification_type, staging_table.prp_rescission_effective_date, staging_table.prp_first_payment_date, staging_table.prp_first_payment_date_auto_compute, staging_table.prp_property_usage_type, staging_table.prp_estimated_property_value_amount, staging_table.prp_smart_charges_enabled, staging_table.prp_charges_updated_datetime, staging_table.prp_smart_docs_enabled, staging_table.prp_docs_enabled_datetime, staging_table.prp_request_fha_mip_refund_required, staging_table.prp_request_recording_fees_required, staging_table.prp_request_property_taxes_required, staging_table.prp_property_tax_request_error_messages, staging_table.prp_fha_mip_refund_request_input_error, staging_table.prp_recording_fees_request_input_error, staging_table.prp_property_taxes_request_input_error, staging_table.prp_publish, staging_table.prp_publish_date, staging_table.prp_ipc_auto_compute, staging_table.prp_ipc_limit_percent, staging_table.prp_ipc_maximum_amount_allowed, staging_table.prp_ipc_amount, staging_table.prp_ipc_percent, staging_table.prp_ipc_financing_concession_amount, staging_table.prp_ipc_non_cash_concession_amount, staging_table.prp_sale_price_amount, staging_table.prp_structure_type, staging_table.prp_deal_pid, staging_table.prp_gfe_interest_rate_expiration_date, staging_table.prp_gfe_lock_duration_days, staging_table.prp_gfe_lock_before_settlement_days, staging_table.prp_proposal_expiration_date, staging_table.prp_uuts_master_contact_name, staging_table.prp_uuts_master_contact_title, staging_table.prp_uuts_master_office_phone, staging_table.prp_uuts_master_office_phone_extension, staging_table.prp_underwrite_risk_assessment_type, staging_table.prp_underwriting_comments, staging_table.prp_reserves_auto_compute, staging_table.prp_reserves_amount, staging_table.prp_reserves_months, staging_table.prp_underwrite_disposition_type, staging_table.prp_underwrite_publish_date, staging_table.prp_underwrite_expiration_date, staging_table.prp_usda_gsa_sam_exclusion, staging_table.prp_usda_gsa_sam_checked_date, staging_table.prp_usda_rd_single_family_housing_type, staging_table.prp_underwrite_method_type, staging_table.prp_mi_required, staging_table.prp_decision_credit_score_borrower_pid, staging_table.prp_decision_credit_score, staging_table.prp_estimated_credit_score, staging_table.prp_effective_credit_score, staging_table.prp_mortgagee_builder_seller_relationship, staging_table.prp_fha_prior_agency_case_id, staging_table.prp_fha_prior_agency_case_endorsement_date, staging_table.prp_fha_refinance_authorization_number, staging_table.prp_fha_refinance_authorization_expiration_date, staging_table.prp_fhac_refinance_authorization_messages, staging_table.prp_hud_fha_de_approval_type, staging_table.prp_owner_occupancy_not_required, staging_table.prp_va_monthly_utilities_included, staging_table.prp_va_maintenance_utilities_auto_compute, staging_table.prp_va_monthly_maintenance_utilities_amount, staging_table.prp_va_maintenance_utilities_per_square_feet_amount, staging_table.prp_household_size_count, staging_table.prp_va_past_credit_record_type, staging_table.prp_va_meets_credit_standards, staging_table.prp_va_prior_paid_in_full_loan_number, staging_table.prp_note_date, staging_table.prp_security_instrument_type, staging_table.prp_trustee_pid, staging_table.prp_trustee_name, staging_table.prp_trustee_address_street1, staging_table.prp_trustee_address_street2, staging_table.prp_trustee_address_city, staging_table.prp_trustee_address_state, staging_table.prp_trustee_address_postal_code, staging_table.prp_trustee_address_country, staging_table.prp_trustee_mers_org_id, staging_table.prp_trustee_phone_number, staging_table.prp_fre_ctp_closing_feature_type, staging_table.prp_fre_ctp_first_payment_due_date, staging_table.prp_purchase_contract_date, staging_table.prp_purchase_contract_financing_contingency_date, staging_table.prp_purchase_contract_funding_date, staging_table.prp_effective_property_value_type, staging_table.prp_effective_property_value_amount, staging_table.prp_decision_appraised_value_amount, staging_table.prp_fha_va_reasonable_value_amount, staging_table.prp_cd_clear_date, staging_table.prp_disaster_declaration_check_date_type, staging_table.prp_disaster_declaration_check_date, staging_table.prp_any_disaster_declaration_before_appraisal, staging_table.prp_any_disaster_declaration_after_appraisal, staging_table.prp_any_disaster_declaration, staging_table.prp_early_first_payment, staging_table.prp_property_acquired_through_inheritance, staging_table.prp_property_acquired_through_ancillary_relief, staging_table.prp_delayed_financing_exception_guidelines_applicable, staging_table.prp_delayed_financing_exception_verified, staging_table.prp_effective_property_value_explanation_type, staging_table.prp_taxes_escrowed, staging_table.prp_flood_insurance_applicable, staging_table.prp_windstorm_insurance_applicable, staging_table.prp_earthquake_insurance_applicable, staging_table.prp_arms_length, staging_table.prp_fha_non_arms_length_ltv_exception_type, staging_table.prp_fha_non_arms_length_ltv_exception_verified, staging_table.prp_escrow_cushion_months, staging_table.prp_escrow_cushion_months_auto_compute, staging_table.prp_fha_eligible_maximum_financing, staging_table.prp_hazard_insurance_applicable, staging_table.prp_property_repairs_required_type, staging_table.prp_property_repairs_description, staging_table.prp_property_repairs_cost_amount, staging_table.prp_property_repairs_holdback_calc_type, staging_table.prp_property_repairs_holdback_amount, staging_table.prp_property_repairs_holdback_payer_type, staging_table.prp_property_repairs_holdback_administrator, staging_table.prp_property_repairs_holdback_required_completion_date, staging_table.prp_property_repairs_completed_notification_date, staging_table.prp_property_repairs_inspection_ordered_date, staging_table.prp_property_repairs_inspection_completed_date, staging_table.prp_property_repairs_funds_released_contractor_date, staging_table.prp_anti_steering_lowest_rate_option_rate_percent, staging_table.prp_anti_steering_lowest_rate_option_fee_amount, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount, staging_table.prp_anti_steering_lowest_cost_option_rate_percent, staging_table.prp_anti_steering_lowest_cost_option_fee_amount, staging_table.prp_initial_uw_submit_datetime, staging_table.prp_va_notice_of_value_source_type, staging_table.prp_va_notice_of_value_date, staging_table.prp_va_notice_of_value_estimated_reasonable_value_amount, staging_table.prp_sar_significant_adjustments, staging_table.prp_separate_transaction_for_land_acquisition, staging_table.prp_land_acquisition_transaction_date, staging_table.prp_land_acquisition_price, staging_table.prp_cash_out_reason_home_improvement, staging_table.prp_cash_out_reason_debt_or_debt_consolidation, staging_table.prp_cash_out_reason_personal_use, staging_table.prp_cash_out_reason_future_investment_not_under_contract, staging_table.prp_cash_out_reason_future_investment_under_contract, staging_table.prp_cash_out_reason_other, staging_table.prp_cash_out_reason_other_text, staging_table.prp_decision_veteran_borrower_pid, staging_table.prp_signed_closing_doc_received_datetime, staging_table.prp_other_lender_requires_appraisal, staging_table.prp_other_lender_requires_appraisal_reason, staging_table.prp_texas_equity_determination_datetime, staging_table.prp_texas_equity_conversion_determination_datetime, staging_table.prp_texas_equity_determination_datetime_override, staging_table.prp_texas_equity_determination_datetime_override_reason, staging_table.prp_texas_equity_conversion_determination_datetime_override, staging_table.prp_texas_equity_conversion_determ_datetime_override_reason, staging_table.prp_cema, staging_table.prp_cema_borrower_savings, staging_table.prp_any_vesting_changes, staging_table.prp_vesting_change_titleholder_added, staging_table.prp_vesting_change_titleholder_removed, staging_table.prp_vesting_change_titleholder_name_change, staging_table.prp_deed_taxes_applicable, staging_table.prp_deed_taxes_applicable_explanation, staging_table.prp_deed_taxes_auto_compute, staging_table.prp_deed_taxes_auto_compute_override_reason, staging_table.prp_intent_to_proceed_date, staging_table.prp_intent_to_proceed_type, staging_table.prp_intent_to_proceed_provider_unparsed_name, staging_table.prp_intent_to_proceed_obtainer_unparsed_name, staging_table.prp_cash_out_reason_student_loans, staging_table.prp_household_income_exclusive_edit, staging_table.prp_purchase_contract_received_date, staging_table.prp_down_payment_percent_mode, staging_table.prp_lender_escrow_loan_amount, staging_table.prp_underwrite_disposition_note, staging_table.prp_rescission_applicable, staging_table.prp_area_median_income, staging_table.prp_total_income_to_ami_ratio, staging_table.prp_cr_tracker_url, staging_table.prp_construction_borrower_contribution_amount, staging_table.prp_construction_lot_ownership_status_type, staging_table.prp_intent_to_proceed_provided, staging_table.prp_effective_signing_location_state, staging_table.prp_effective_signing_location_city, staging_table.prp_va_required_guaranty_amount, staging_table.prp_va_amount_used_to_calculate_maximum_guaranty, staging_table.prp_va_actual_guaranty_amount, staging_table.prp_last_corrective_disclosure_processed_datetime, staging_table.prp_user_entered_note_date, staging_table.prp_effective_note_date, staging_table.prp_lender_escrow_loan_due_date, staging_table.prp_va_maximum_base_loan_amount, staging_table.prp_va_maximum_funding_fee_amount, staging_table.prp_va_maximum_total_loan_amount, staging_table.prp_va_required_cash_amount, staging_table.prp_va_guaranty_percent, staging_table.prp_gse_version_type, staging_table.prp_minimum_household_income_amount, staging_table.prp_minimum_residual_income_amount, staging_table.prp_minimum_residual_income_auto_compute, staging_table.prp_financed_property_improvements_category_type, staging_table.prp_adjusted_as_is_value_amount, staging_table.prp_after_improved_value_amount, staging_table.prp_disclosure_action_type, staging_table.prp_hud_consultant, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_pid, history_table.prp_version + 1, history_table.prp_decision_lp_request_pid, history_table.prp_decision_du_request_pid, history_table.prp_proposal_type, history_table.prp_description, history_table.prp_doc_level_type, history_table.prp_loan_purpose_type, history_table.prp_name, history_table.prp_create_datetime, history_table.prp_effective_funding_date, history_table.prp_estimated_funding_date, history_table.prp_calculated_earliest_allowed_consummation_date, history_table.prp_overridden_earliest_allowed_consummation_date, history_table.prp_effective_earliest_allowed_consummation_date, history_table.prp_earliest_allowed_consummation_date_override_reason, history_table.prp_last_requested_disclosure_date, history_table.prp_closing_document_sign_datetime, history_table.prp_scheduled_closing_document_sign_datetime, history_table.prp_rescission_through_date, history_table.prp_rescission_notification_date, history_table.prp_rescission_notification_by, history_table.prp_rescission_notification_type, history_table.prp_rescission_effective_date, history_table.prp_first_payment_date, history_table.prp_first_payment_date_auto_compute, history_table.prp_property_usage_type, history_table.prp_estimated_property_value_amount, history_table.prp_smart_charges_enabled, history_table.prp_charges_updated_datetime, history_table.prp_smart_docs_enabled, history_table.prp_docs_enabled_datetime, history_table.prp_request_fha_mip_refund_required, history_table.prp_request_recording_fees_required, history_table.prp_request_property_taxes_required, history_table.prp_property_tax_request_error_messages, history_table.prp_fha_mip_refund_request_input_error, history_table.prp_recording_fees_request_input_error, history_table.prp_property_taxes_request_input_error, history_table.prp_publish, history_table.prp_publish_date, history_table.prp_ipc_auto_compute, history_table.prp_ipc_limit_percent, history_table.prp_ipc_maximum_amount_allowed, history_table.prp_ipc_amount, history_table.prp_ipc_percent, history_table.prp_ipc_financing_concession_amount, history_table.prp_ipc_non_cash_concession_amount, history_table.prp_sale_price_amount, history_table.prp_structure_type, history_table.prp_deal_pid, history_table.prp_gfe_interest_rate_expiration_date, history_table.prp_gfe_lock_duration_days, history_table.prp_gfe_lock_before_settlement_days, history_table.prp_proposal_expiration_date, history_table.prp_uuts_master_contact_name, history_table.prp_uuts_master_contact_title, history_table.prp_uuts_master_office_phone, history_table.prp_uuts_master_office_phone_extension, history_table.prp_underwrite_risk_assessment_type, history_table.prp_underwriting_comments, history_table.prp_reserves_auto_compute, history_table.prp_reserves_amount, history_table.prp_reserves_months, history_table.prp_underwrite_disposition_type, history_table.prp_underwrite_publish_date, history_table.prp_underwrite_expiration_date, history_table.prp_usda_gsa_sam_exclusion, history_table.prp_usda_gsa_sam_checked_date, history_table.prp_usda_rd_single_family_housing_type, history_table.prp_underwrite_method_type, history_table.prp_mi_required, history_table.prp_decision_credit_score_borrower_pid, history_table.prp_decision_credit_score, history_table.prp_estimated_credit_score, history_table.prp_effective_credit_score, history_table.prp_mortgagee_builder_seller_relationship, history_table.prp_fha_prior_agency_case_id, history_table.prp_fha_prior_agency_case_endorsement_date, history_table.prp_fha_refinance_authorization_number, history_table.prp_fha_refinance_authorization_expiration_date, history_table.prp_fhac_refinance_authorization_messages, history_table.prp_hud_fha_de_approval_type, history_table.prp_owner_occupancy_not_required, history_table.prp_va_monthly_utilities_included, history_table.prp_va_maintenance_utilities_auto_compute, history_table.prp_va_monthly_maintenance_utilities_amount, history_table.prp_va_maintenance_utilities_per_square_feet_amount, history_table.prp_household_size_count, history_table.prp_va_past_credit_record_type, history_table.prp_va_meets_credit_standards, history_table.prp_va_prior_paid_in_full_loan_number, history_table.prp_note_date, history_table.prp_security_instrument_type, history_table.prp_trustee_pid, history_table.prp_trustee_name, history_table.prp_trustee_address_street1, history_table.prp_trustee_address_street2, history_table.prp_trustee_address_city, history_table.prp_trustee_address_state, history_table.prp_trustee_address_postal_code, history_table.prp_trustee_address_country, history_table.prp_trustee_mers_org_id, history_table.prp_trustee_phone_number, history_table.prp_fre_ctp_closing_feature_type, history_table.prp_fre_ctp_first_payment_due_date, history_table.prp_purchase_contract_date, history_table.prp_purchase_contract_financing_contingency_date, history_table.prp_purchase_contract_funding_date, history_table.prp_effective_property_value_type, history_table.prp_effective_property_value_amount, history_table.prp_decision_appraised_value_amount, history_table.prp_fha_va_reasonable_value_amount, history_table.prp_cd_clear_date, history_table.prp_disaster_declaration_check_date_type, history_table.prp_disaster_declaration_check_date, history_table.prp_any_disaster_declaration_before_appraisal, history_table.prp_any_disaster_declaration_after_appraisal, history_table.prp_any_disaster_declaration, history_table.prp_early_first_payment, history_table.prp_property_acquired_through_inheritance, history_table.prp_property_acquired_through_ancillary_relief, history_table.prp_delayed_financing_exception_guidelines_applicable, history_table.prp_delayed_financing_exception_verified, history_table.prp_effective_property_value_explanation_type, history_table.prp_taxes_escrowed, history_table.prp_flood_insurance_applicable, history_table.prp_windstorm_insurance_applicable, history_table.prp_earthquake_insurance_applicable, history_table.prp_arms_length, history_table.prp_fha_non_arms_length_ltv_exception_type, history_table.prp_fha_non_arms_length_ltv_exception_verified, history_table.prp_escrow_cushion_months, history_table.prp_escrow_cushion_months_auto_compute, history_table.prp_fha_eligible_maximum_financing, history_table.prp_hazard_insurance_applicable, history_table.prp_property_repairs_required_type, history_table.prp_property_repairs_description, history_table.prp_property_repairs_cost_amount, history_table.prp_property_repairs_holdback_calc_type, history_table.prp_property_repairs_holdback_amount, history_table.prp_property_repairs_holdback_payer_type, history_table.prp_property_repairs_holdback_administrator, history_table.prp_property_repairs_holdback_required_completion_date, history_table.prp_property_repairs_completed_notification_date, history_table.prp_property_repairs_inspection_ordered_date, history_table.prp_property_repairs_inspection_completed_date, history_table.prp_property_repairs_funds_released_contractor_date, history_table.prp_anti_steering_lowest_rate_option_rate_percent, history_table.prp_anti_steering_lowest_rate_option_fee_amount, history_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent, history_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount, history_table.prp_anti_steering_lowest_cost_option_rate_percent, history_table.prp_anti_steering_lowest_cost_option_fee_amount, history_table.prp_initial_uw_submit_datetime, history_table.prp_va_notice_of_value_source_type, history_table.prp_va_notice_of_value_date, history_table.prp_va_notice_of_value_estimated_reasonable_value_amount, history_table.prp_sar_significant_adjustments, history_table.prp_separate_transaction_for_land_acquisition, history_table.prp_land_acquisition_transaction_date, history_table.prp_land_acquisition_price, history_table.prp_cash_out_reason_home_improvement, history_table.prp_cash_out_reason_debt_or_debt_consolidation, history_table.prp_cash_out_reason_personal_use, history_table.prp_cash_out_reason_future_investment_not_under_contract, history_table.prp_cash_out_reason_future_investment_under_contract, history_table.prp_cash_out_reason_other, history_table.prp_cash_out_reason_other_text, history_table.prp_decision_veteran_borrower_pid, history_table.prp_signed_closing_doc_received_datetime, history_table.prp_other_lender_requires_appraisal, history_table.prp_other_lender_requires_appraisal_reason, history_table.prp_texas_equity_determination_datetime, history_table.prp_texas_equity_conversion_determination_datetime, history_table.prp_texas_equity_determination_datetime_override, history_table.prp_texas_equity_determination_datetime_override_reason, history_table.prp_texas_equity_conversion_determination_datetime_override, history_table.prp_texas_equity_conversion_determ_datetime_override_reason, history_table.prp_cema, history_table.prp_cema_borrower_savings, history_table.prp_any_vesting_changes, history_table.prp_vesting_change_titleholder_added, history_table.prp_vesting_change_titleholder_removed, history_table.prp_vesting_change_titleholder_name_change, history_table.prp_deed_taxes_applicable, history_table.prp_deed_taxes_applicable_explanation, history_table.prp_deed_taxes_auto_compute, history_table.prp_deed_taxes_auto_compute_override_reason, history_table.prp_intent_to_proceed_date, history_table.prp_intent_to_proceed_type, history_table.prp_intent_to_proceed_provider_unparsed_name, history_table.prp_intent_to_proceed_obtainer_unparsed_name, history_table.prp_cash_out_reason_student_loans, history_table.prp_household_income_exclusive_edit, history_table.prp_purchase_contract_received_date, history_table.prp_down_payment_percent_mode, history_table.prp_lender_escrow_loan_amount, history_table.prp_underwrite_disposition_note, history_table.prp_rescission_applicable, history_table.prp_area_median_income, history_table.prp_total_income_to_ami_ratio, history_table.prp_cr_tracker_url, history_table.prp_construction_borrower_contribution_amount, history_table.prp_construction_lot_ownership_status_type, history_table.prp_intent_to_proceed_provided, history_table.prp_effective_signing_location_state, history_table.prp_effective_signing_location_city, history_table.prp_va_required_guaranty_amount, history_table.prp_va_amount_used_to_calculate_maximum_guaranty, history_table.prp_va_actual_guaranty_amount, history_table.prp_last_corrective_disclosure_processed_datetime, history_table.prp_user_entered_note_date, history_table.prp_effective_note_date, history_table.prp_lender_escrow_loan_due_date, history_table.prp_va_maximum_base_loan_amount, history_table.prp_va_maximum_funding_fee_amount, history_table.prp_va_maximum_total_loan_amount, history_table.prp_va_required_cash_amount, history_table.prp_va_guaranty_percent, history_table.prp_gse_version_type, history_table.prp_minimum_household_income_amount, history_table.prp_minimum_residual_income_amount, history_table.prp_minimum_residual_income_auto_compute, history_table.prp_financed_property_improvements_category_type, history_table.prp_adjusted_as_is_value_amount, history_table.prp_after_improved_value_amount, history_table.prp_disclosure_action_type, history_table.prp_hud_consultant, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal deleted_records
                  WHERE deleted_records.prp_pid = history_table.prp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
')
     -- borrower
     , ('SP-100308', '--finding records to insert into history_octane.borrower
SELECT staging_table.b_pid, staging_table.b_version, staging_table.b_alimony_child_support, staging_table.b_alimony_child_support_explanation, staging_table.b_application_pid, staging_table.b_application_signed_date, staging_table.b_application_taken_method_type, staging_table.b_bankruptcy, staging_table.b_bankruptcy_explanation, staging_table.b_birth_date, staging_table.b_borrowed_down_payment, staging_table.b_borrowed_down_payment_explanation, staging_table.b_applicant_role_type, staging_table.b_required_to_sign, staging_table.b_spousal_homestead, staging_table.b_has_no_ssn, staging_table.b_citizenship_residency_type, staging_table.b_credit_request_pid, staging_table.b_credit_report_identifier, staging_table.b_credit_report_authorization, staging_table.b_has_dependents, staging_table.b_dependent_count, staging_table.b_dependents_age_years, staging_table.b_email, staging_table.b_fax, staging_table.b_first_name, staging_table.b_nickname, staging_table.b_first_time_homebuyer, staging_table.b_lender_employee, staging_table.b_lender_employee_status_confirmed, staging_table.b_sex_refused, staging_table.b_sex_collected_visual_or_surname, staging_table.b_sex_male, staging_table.b_sex_female, staging_table.b_sex_not_obtainable, staging_table.b_ethnicity_refused, staging_table.b_ethnicity_collected_visual_or_surname, staging_table.b_ethnicity_hispanic_or_latino, staging_table.b_ethnicity_mexican, staging_table.b_ethnicity_puerto_rican, staging_table.b_ethnicity_cuban, staging_table.b_ethnicity_other_hispanic_or_latino, staging_table.b_ethnicity_other_hispanic_or_latino_description, staging_table.b_ethnicity_not_hispanic_or_latino, staging_table.b_ethnicity_not_obtainable, staging_table.b_homeowner_past_three_years, staging_table.b_home_phone, staging_table.b_intend_to_occupy, staging_table.b_last_name, staging_table.b_mailing_place_pid, staging_table.b_marital_status_type, staging_table.b_spouse_borrower_pid, staging_table.b_middle_name, staging_table.b_mobile_phone, staging_table.b_name_suffix, staging_table.b_note_endorser, staging_table.b_note_endorser_explanation, staging_table.b_obligated_loan_foreclosure, staging_table.b_obligated_loan_foreclosure_explanation, staging_table.b_office_phone, staging_table.b_office_phone_extension, staging_table.b_other_race_national_origin_description, staging_table.b_outstanding_judgements, staging_table.b_outstanding_judgments_explanation, staging_table.b_party_to_lawsuit, staging_table.b_party_to_lawsuit_explanation, staging_table.b_power_of_attorney, staging_table.b_power_of_attorney_signing_capacity, staging_table.b_power_of_attorney_first_name, staging_table.b_power_of_attorney_last_name, staging_table.b_power_of_attorney_middle_name, staging_table.b_power_of_attorney_name_suffix, staging_table.b_power_of_attorney_company_name, staging_table.b_power_of_attorney_title, staging_table.b_power_of_attorney_office_phone, staging_table.b_power_of_attorney_office_phone_extension, staging_table.b_power_of_attorney_mobile_phone, staging_table.b_power_of_attorney_email, staging_table.b_power_of_attorney_fax, staging_table.b_power_of_attorney_city, staging_table.b_power_of_attorney_country, staging_table.b_power_of_attorney_postal_code, staging_table.b_power_of_attorney_state, staging_table.b_power_of_attorney_street1, staging_table.b_power_of_attorney_street2, staging_table.b_presently_delinquent, staging_table.b_presently_delinquent_explanation, staging_table.b_prior_property_title_type, staging_table.b_prior_property_usage_type, staging_table.b_property_foreclosure, staging_table.b_property_foreclosure_explanation, staging_table.b_race_refused, staging_table.b_race_collected_visual_or_surname, staging_table.b_race_american_indian_or_alaska_native, staging_table.b_race_other_american_indian_or_alaska_native_description, staging_table.b_race_asian, staging_table.b_race_asian_indian, staging_table.b_race_chinese, staging_table.b_race_filipino, staging_table.b_race_japanese, staging_table.b_race_korean, staging_table.b_race_vietnamese, staging_table.b_race_other_asian, staging_table.b_race_other_asian_description, staging_table.b_race_black_or_african_american, staging_table.b_race_information_not_provided, staging_table.b_race_national_origin_refusal, staging_table.b_race_native_hawaiian_or_other_pacific_islander, staging_table.b_race_native_hawaiian, staging_table.b_race_guamanian_or_chamorro, staging_table.b_race_samoan, staging_table.b_race_other_pacific_islander, staging_table.b_race_not_obtainable, staging_table.b_race_other_pacific_islander_description, staging_table.b_race_not_applicable, staging_table.b_race_white, staging_table.b_schooling_years, staging_table.b_titleholder, staging_table.b_experian_credit_score, staging_table.b_equifax_credit_score, staging_table.b_trans_union_credit_score, staging_table.b_decision_credit_score, staging_table.b_borrower_tiny_id_type, staging_table.b_first_time_home_buyer_explain, staging_table.b_first_time_home_buyer_auto_compute, staging_table.b_caivrs_id, staging_table.b_caivrs_messages, staging_table.b_on_ldp_list, staging_table.b_on_gsa_list, staging_table.b_monthly_job_federal_tax_amount, staging_table.b_monthly_job_state_tax_amount, staging_table.b_monthly_job_retirement_tax_amount, staging_table.b_monthly_job_medicare_tax_amount, staging_table.b_monthly_job_state_disability_insurance_amount, staging_table.b_monthly_job_other_tax_1_amount, staging_table.b_monthly_job_other_tax_1_description, staging_table.b_monthly_job_other_tax_2_amount, staging_table.b_monthly_job_other_tax_2_description, staging_table.b_monthly_job_other_tax_3_amount, staging_table.b_monthly_job_other_tax_3_description, staging_table.b_monthly_job_total_tax_amount, staging_table.b_homeownership_education_type, staging_table.b_homeownership_education_agency_type, staging_table.b_homeownership_education_id, staging_table.b_homeownership_education_name, staging_table.b_homeownership_education_complete_date, staging_table.b_housing_counseling_type, staging_table.b_housing_counseling_agency_type, staging_table.b_housing_counseling_id, staging_table.b_housing_counseling_name, staging_table.b_housing_counseling_complete_date, staging_table.b_legal_entity_type, staging_table.b_credit_report_authorization_datetime, staging_table.b_credit_report_authorization_method, staging_table.b_credit_report_authorization_obtained_by_unparsed_name, staging_table.b_disabled, staging_table.b_usda_annual_child_care_expenses, staging_table.b_usda_disability_expenses, staging_table.b_usda_medical_expenses, staging_table.b_usda_income_from_assets, staging_table.b_usda_moderate_income_limit, staging_table.b_hud_employee, staging_table.b_relationship_to_primary_borrower_type, staging_table.b_relationship_to_seller_type, staging_table.b_preferred_first_name, staging_table.b_domestic_relationship_state_type, staging_table.b_credit_report_required, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.borrower staging_table
LEFT JOIN history_octane.borrower history_table
          ON staging_table.b_pid = history_table.b_pid AND staging_table.b_version = history_table.b_version
WHERE history_table.b_pid IS NULL
UNION ALL
SELECT history_table.b_pid, history_table.b_version + 1, history_table.b_alimony_child_support, history_table.b_alimony_child_support_explanation, history_table.b_application_pid, history_table.b_application_signed_date, history_table.b_application_taken_method_type, history_table.b_bankruptcy, history_table.b_bankruptcy_explanation, history_table.b_birth_date, history_table.b_borrowed_down_payment, history_table.b_borrowed_down_payment_explanation, history_table.b_applicant_role_type, history_table.b_required_to_sign, history_table.b_spousal_homestead, history_table.b_has_no_ssn, history_table.b_citizenship_residency_type, history_table.b_credit_request_pid, history_table.b_credit_report_identifier, history_table.b_credit_report_authorization, history_table.b_has_dependents, history_table.b_dependent_count, history_table.b_dependents_age_years, history_table.b_email, history_table.b_fax, history_table.b_first_name, history_table.b_nickname, history_table.b_first_time_homebuyer, history_table.b_lender_employee, history_table.b_lender_employee_status_confirmed, history_table.b_sex_refused, history_table.b_sex_collected_visual_or_surname, history_table.b_sex_male, history_table.b_sex_female, history_table.b_sex_not_obtainable, history_table.b_ethnicity_refused, history_table.b_ethnicity_collected_visual_or_surname, history_table.b_ethnicity_hispanic_or_latino, history_table.b_ethnicity_mexican, history_table.b_ethnicity_puerto_rican, history_table.b_ethnicity_cuban, history_table.b_ethnicity_other_hispanic_or_latino, history_table.b_ethnicity_other_hispanic_or_latino_description, history_table.b_ethnicity_not_hispanic_or_latino, history_table.b_ethnicity_not_obtainable, history_table.b_homeowner_past_three_years, history_table.b_home_phone, history_table.b_intend_to_occupy, history_table.b_last_name, history_table.b_mailing_place_pid, history_table.b_marital_status_type, history_table.b_spouse_borrower_pid, history_table.b_middle_name, history_table.b_mobile_phone, history_table.b_name_suffix, history_table.b_note_endorser, history_table.b_note_endorser_explanation, history_table.b_obligated_loan_foreclosure, history_table.b_obligated_loan_foreclosure_explanation, history_table.b_office_phone, history_table.b_office_phone_extension, history_table.b_other_race_national_origin_description, history_table.b_outstanding_judgements, history_table.b_outstanding_judgments_explanation, history_table.b_party_to_lawsuit, history_table.b_party_to_lawsuit_explanation, history_table.b_power_of_attorney, history_table.b_power_of_attorney_signing_capacity, history_table.b_power_of_attorney_first_name, history_table.b_power_of_attorney_last_name, history_table.b_power_of_attorney_middle_name, history_table.b_power_of_attorney_name_suffix, history_table.b_power_of_attorney_company_name, history_table.b_power_of_attorney_title, history_table.b_power_of_attorney_office_phone, history_table.b_power_of_attorney_office_phone_extension, history_table.b_power_of_attorney_mobile_phone, history_table.b_power_of_attorney_email, history_table.b_power_of_attorney_fax, history_table.b_power_of_attorney_city, history_table.b_power_of_attorney_country, history_table.b_power_of_attorney_postal_code, history_table.b_power_of_attorney_state, history_table.b_power_of_attorney_street1, history_table.b_power_of_attorney_street2, history_table.b_presently_delinquent, history_table.b_presently_delinquent_explanation, history_table.b_prior_property_title_type, history_table.b_prior_property_usage_type, history_table.b_property_foreclosure, history_table.b_property_foreclosure_explanation, history_table.b_race_refused, history_table.b_race_collected_visual_or_surname, history_table.b_race_american_indian_or_alaska_native, history_table.b_race_other_american_indian_or_alaska_native_description, history_table.b_race_asian, history_table.b_race_asian_indian, history_table.b_race_chinese, history_table.b_race_filipino, history_table.b_race_japanese, history_table.b_race_korean, history_table.b_race_vietnamese, history_table.b_race_other_asian, history_table.b_race_other_asian_description, history_table.b_race_black_or_african_american, history_table.b_race_information_not_provided, history_table.b_race_national_origin_refusal, history_table.b_race_native_hawaiian_or_other_pacific_islander, history_table.b_race_native_hawaiian, history_table.b_race_guamanian_or_chamorro, history_table.b_race_samoan, history_table.b_race_other_pacific_islander, history_table.b_race_not_obtainable, history_table.b_race_other_pacific_islander_description, history_table.b_race_not_applicable, history_table.b_race_white, history_table.b_schooling_years, history_table.b_titleholder, history_table.b_experian_credit_score, history_table.b_equifax_credit_score, history_table.b_trans_union_credit_score, history_table.b_decision_credit_score, history_table.b_borrower_tiny_id_type, history_table.b_first_time_home_buyer_explain, history_table.b_first_time_home_buyer_auto_compute, history_table.b_caivrs_id, history_table.b_caivrs_messages, history_table.b_on_ldp_list, history_table.b_on_gsa_list, history_table.b_monthly_job_federal_tax_amount, history_table.b_monthly_job_state_tax_amount, history_table.b_monthly_job_retirement_tax_amount, history_table.b_monthly_job_medicare_tax_amount, history_table.b_monthly_job_state_disability_insurance_amount, history_table.b_monthly_job_other_tax_1_amount, history_table.b_monthly_job_other_tax_1_description, history_table.b_monthly_job_other_tax_2_amount, history_table.b_monthly_job_other_tax_2_description, history_table.b_monthly_job_other_tax_3_amount, history_table.b_monthly_job_other_tax_3_description, history_table.b_monthly_job_total_tax_amount, history_table.b_homeownership_education_type, history_table.b_homeownership_education_agency_type, history_table.b_homeownership_education_id, history_table.b_homeownership_education_name, history_table.b_homeownership_education_complete_date, history_table.b_housing_counseling_type, history_table.b_housing_counseling_agency_type, history_table.b_housing_counseling_id, history_table.b_housing_counseling_name, history_table.b_housing_counseling_complete_date, history_table.b_legal_entity_type, history_table.b_credit_report_authorization_datetime, history_table.b_credit_report_authorization_method, history_table.b_credit_report_authorization_obtained_by_unparsed_name, history_table.b_disabled, history_table.b_usda_annual_child_care_expenses, history_table.b_usda_disability_expenses, history_table.b_usda_medical_expenses, history_table.b_usda_income_from_assets, history_table.b_usda_moderate_income_limit, history_table.b_hud_employee, history_table.b_relationship_to_primary_borrower_type, history_table.b_relationship_to_seller_type, history_table.b_preferred_first_name, history_table.b_domestic_relationship_state_type, history_table.b_credit_report_required, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.borrower history_table
LEFT JOIN staging_octane.borrower staging_table
          ON staging_table.b_pid = history_table.b_pid
WHERE staging_table.b_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.borrower deleted_records
                  WHERE deleted_records.b_pid = history_table.b_pid AND deleted_records.data_source_deleted_flag = TRUE );')
     -- deal_key_roles
     , ('SP-100017', '--finding records to insert into history_octane.deal_key_roles
SELECT staging_table.dkrs_pid, staging_table.dkrs_version, staging_table.dkrs_deal_pid, staging_table.dkrs_originator_lender_user_pid, staging_table.dkrs_originator_first_name, staging_table.dkrs_originator_last_name, staging_table.dkrs_originator_middle_name, staging_table.dkrs_originator_fmls_basic, staging_table.dkrs_originator_nmls_id, staging_table.dkrs_supplemental_originator_lender_user_pid, staging_table.dkrs_supplemental_originator_fmls, staging_table.dkrs_account_executive_lender_user_pid, staging_table.dkrs_account_executive_fmls, staging_table.dkrs_investor_conditions_lender_user_pid, staging_table.dkrs_investor_conditions_fmls, staging_table.dkrs_investor_stack_to_investor_lender_user_pid, staging_table.dkrs_investor_stack_to_investor_fmls, staging_table.dkrs_collateral_to_custodian_lender_user_pid, staging_table.dkrs_collateral_to_custodian_fmls, staging_table.dkrs_collateral_to_investor_lender_user_pid, staging_table.dkrs_collateral_to_investor_fmls, staging_table.dkrs_transaction_assistant_lender_user_pid, staging_table.dkrs_transaction_assistant_fmls, staging_table.dkrs_final_documents_to_investor_lender_user_pid, staging_table.dkrs_final_documents_to_investor_fmls, staging_table.dkrs_government_insurance_lender_user_pid, staging_table.dkrs_government_insurance_fmls, staging_table.dkrs_funder_lender_user_pid, staging_table.dkrs_funder_fmls, staging_table.dkrs_processor_lender_user_pid, staging_table.dkrs_processor_fmls, staging_table.dkrs_underwriter_lender_user_pid, staging_table.dkrs_underwriter_fmls, staging_table.dkrs_project_underwriter_lender_user_pid, staging_table.dkrs_project_underwriter_fmls, staging_table.dkrs_closing_doc_specialist_lender_user_pid, staging_table.dkrs_closing_doc_specialist_fmls, staging_table.dkrs_wholesale_client_advocate_lender_user_pid, staging_table.dkrs_wholesale_client_advocate_fmls, staging_table.dkrs_closing_scheduler_lender_user_pid, staging_table.dkrs_closing_scheduler_fmls, staging_table.dkrs_collateral_underwriter_lender_user_pid, staging_table.dkrs_collateral_underwriter_fmls, staging_table.dkrs_correspondent_client_advocate_lender_user_pid, staging_table.dkrs_correspondent_client_advocate_fmls, staging_table.dkrs_flood_insurance_specialist_lender_user_pid, staging_table.dkrs_flood_insurance_specialist_fmls, staging_table.dkrs_hoa_specialist_lender_user_pid, staging_table.dkrs_hoa_specialist_fmls, staging_table.dkrs_hoi_specialist_lender_user_pid, staging_table.dkrs_hoi_specialist_fmls, staging_table.dkrs_ho6_specialist_lender_user_pid, staging_table.dkrs_ho6_specialist_fmls, staging_table.dkrs_hud_va_lender_officer_lender_user_pid, staging_table.dkrs_hud_va_lender_officer_fmls, staging_table.dkrs_loan_officer_assistant_lender_user_pid, staging_table.dkrs_loan_officer_assistant_fmls, staging_table.dkrs_loan_payoff_specialist_lender_user_pid, staging_table.dkrs_loan_payoff_specialist_fmls, staging_table.dkrs_subordination_specialist_lender_user_pid, staging_table.dkrs_subordination_specialist_fmls, staging_table.dkrs_title_specialist_lender_user_pid, staging_table.dkrs_title_specialist_fmls, staging_table.dkrs_underwriting_manager_lender_user_pid, staging_table.dkrs_underwriting_manager_fmls, staging_table.dkrs_va_specialist_lender_user_pid, staging_table.dkrs_va_specialist_fmls, staging_table.dkrs_verbal_voe_specialist_lender_user_pid, staging_table.dkrs_verbal_voe_specialist_fmls, staging_table.dkrs_voe_specialist_lender_user_pid, staging_table.dkrs_voe_specialist_fmls, staging_table.dkrs_wire_specialist_lender_user_pid, staging_table.dkrs_wire_specialist_fmls, staging_table.dkrs_internal_construction_manager_lender_user_pid, staging_table.dkrs_internal_construction_manager_fmls, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_key_roles staging_table
LEFT JOIN history_octane.deal_key_roles history_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid AND staging_table.dkrs_version = history_table.dkrs_version
WHERE history_table.dkrs_pid IS NULL
UNION ALL
SELECT history_table.dkrs_pid, history_table.dkrs_version + 1, history_table.dkrs_deal_pid, history_table.dkrs_originator_lender_user_pid, history_table.dkrs_originator_first_name, history_table.dkrs_originator_last_name, history_table.dkrs_originator_middle_name, history_table.dkrs_originator_fmls_basic, history_table.dkrs_originator_nmls_id, history_table.dkrs_supplemental_originator_lender_user_pid, history_table.dkrs_supplemental_originator_fmls, history_table.dkrs_account_executive_lender_user_pid, history_table.dkrs_account_executive_fmls, history_table.dkrs_investor_conditions_lender_user_pid, history_table.dkrs_investor_conditions_fmls, history_table.dkrs_investor_stack_to_investor_lender_user_pid, history_table.dkrs_investor_stack_to_investor_fmls, history_table.dkrs_collateral_to_custodian_lender_user_pid, history_table.dkrs_collateral_to_custodian_fmls, history_table.dkrs_collateral_to_investor_lender_user_pid, history_table.dkrs_collateral_to_investor_fmls, history_table.dkrs_transaction_assistant_lender_user_pid, history_table.dkrs_transaction_assistant_fmls, history_table.dkrs_final_documents_to_investor_lender_user_pid, history_table.dkrs_final_documents_to_investor_fmls, history_table.dkrs_government_insurance_lender_user_pid, history_table.dkrs_government_insurance_fmls, history_table.dkrs_funder_lender_user_pid, history_table.dkrs_funder_fmls, history_table.dkrs_processor_lender_user_pid, history_table.dkrs_processor_fmls, history_table.dkrs_underwriter_lender_user_pid, history_table.dkrs_underwriter_fmls, history_table.dkrs_project_underwriter_lender_user_pid, history_table.dkrs_project_underwriter_fmls, history_table.dkrs_closing_doc_specialist_lender_user_pid, history_table.dkrs_closing_doc_specialist_fmls, history_table.dkrs_wholesale_client_advocate_lender_user_pid, history_table.dkrs_wholesale_client_advocate_fmls, history_table.dkrs_closing_scheduler_lender_user_pid, history_table.dkrs_closing_scheduler_fmls, history_table.dkrs_collateral_underwriter_lender_user_pid, history_table.dkrs_collateral_underwriter_fmls, history_table.dkrs_correspondent_client_advocate_lender_user_pid, history_table.dkrs_correspondent_client_advocate_fmls, history_table.dkrs_flood_insurance_specialist_lender_user_pid, history_table.dkrs_flood_insurance_specialist_fmls, history_table.dkrs_hoa_specialist_lender_user_pid, history_table.dkrs_hoa_specialist_fmls, history_table.dkrs_hoi_specialist_lender_user_pid, history_table.dkrs_hoi_specialist_fmls, history_table.dkrs_ho6_specialist_lender_user_pid, history_table.dkrs_ho6_specialist_fmls, history_table.dkrs_hud_va_lender_officer_lender_user_pid, history_table.dkrs_hud_va_lender_officer_fmls, history_table.dkrs_loan_officer_assistant_lender_user_pid, history_table.dkrs_loan_officer_assistant_fmls, history_table.dkrs_loan_payoff_specialist_lender_user_pid, history_table.dkrs_loan_payoff_specialist_fmls, history_table.dkrs_subordination_specialist_lender_user_pid, history_table.dkrs_subordination_specialist_fmls, history_table.dkrs_title_specialist_lender_user_pid, history_table.dkrs_title_specialist_fmls, history_table.dkrs_underwriting_manager_lender_user_pid, history_table.dkrs_underwriting_manager_fmls, history_table.dkrs_va_specialist_lender_user_pid, history_table.dkrs_va_specialist_fmls, history_table.dkrs_verbal_voe_specialist_lender_user_pid, history_table.dkrs_verbal_voe_specialist_fmls, history_table.dkrs_voe_specialist_lender_user_pid, history_table.dkrs_voe_specialist_fmls, history_table.dkrs_wire_specialist_lender_user_pid, history_table.dkrs_wire_specialist_fmls, history_table.dkrs_internal_construction_manager_lender_user_pid, history_table.dkrs_internal_construction_manager_fmls, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_key_roles history_table
LEFT JOIN staging_octane.deal_key_roles staging_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
WHERE staging_table.dkrs_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.deal_key_roles deleted_records
                  WHERE deleted_records.dkrs_pid = history_table.dkrs_pid AND deleted_records.data_source_deleted_flag = TRUE );');

-- Update table_input_step sql for all new columns
UPDATE mdi.table_input_step
SET sql = temp_new_column_mdi_data.input_sql
FROM temp_new_column_mdi_data
JOIN mdi.process
     ON process.name = temp_new_column_mdi_data.process_name
WHERE table_input_step.process_dwid = process.dwid;

-- Insert table_output_field rows for all new columns
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid
     , temp_new_column_field_data.field_name
     , temp_new_column_field_data.field_name
     , temp_new_column_field_data.field_order
     , FALSE
FROM temp_new_column_field_data
JOIN mdi.table_output_step
     ON temp_new_column_field_data.table_name = table_output_step.target_table
         AND table_output_step.target_schema = 'history_octane';

--
-- REMOVE DATA FOR DELETED COLUMN: proposal.prp_fha_203k_consultant_id
--
--   note: field is removed from proposal's table_input_step above in the same
--         update that adds the new proposal column
--

-- nullify source_edw_field_definition_dwid pointing to deleted field
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
FROM mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = 'prp_fha_203k_consultant_id'
  AND edw_table_definition.schema_name = 'history_octane';

-- delete field from edw_field_definition
DELETE
FROM mdi.edw_field_definition
    USING mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = 'prp_fha_203k_consultant_id'
  AND edw_table_definition.schema_name = 'staging_octane';

-- delete field from table_output_field
DELETE
FROM mdi.table_output_field
WHERE table_output_field.database_field_name = 'prp_fha_203k_consultant_id';

--
-- EDW | mdi.edw_field_definition - add table prefixes to all source_field_calculations to match corresponding edw_join_definition aliases
-- https://app.asana.com/0/0/1200453484886092
--

--update calculations for all calculated fields with no source joins
WITH new_calculations (table_name, field_name, calculation) AS (
    VALUES ('borrower_demographics_dim', 'ethnicity_other_hispanic_or_latino_description_flag', 'primary_table.b_ethnicity_other_hispanic_or_latino_description <> ''''')
         , ('borrower_demographics_dim', 'other_race_national_origin_description_flag', 'primary_table.b_other_race_national_origin_description <> ''''')
         , ('borrower_demographics_dim', 'race_other_american_indian_or_alaska_native_description_flag', 'primary_table.b_race_other_american_indian_or_alaska_native_description <> ''''')
         , ('borrower_demographics_dim', 'race_other_asian_description_flag', 'primary_table.b_race_other_asian_description <> ''''')
         , ('borrower_demographics_dim', 'race_other_pacific_islander_description_flag', 'primary_table.b_race_other_pacific_islander_description <> ''''')
         , ('borrower_lending_profile_dim', 'alimony_child_support_explanation_flag', 'primary_table.b_alimony_child_support_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'bankruptcy_explanation_flag', 'primary_table.b_bankruptcy_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'borrowed_down_payment_explanation_flag', 'primary_table.b_borrowed_down_payment_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'note_endorser_explanation_flag', 'primary_table.b_note_endorser_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'obligated_loan_foreclosure_explanation_flag', 'primary_table.b_obligated_loan_foreclosure_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'outstanding_judgments_explanation_flag', 'primary_table.b_outstanding_judgments_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'party_to_lawsuit_explanation_flag', 'primary_table.b_party_to_lawsuit_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'presently_delinquent_explanation_flag', 'primary_table.b_presently_delinquent_explanation <> ''''')
         , ('borrower_lending_profile_dim', 'property_foreclosure_explanation_flag', 'primary_table.b_property_foreclosure_explanation <> ''''')
         , ('transaction_junk_dim', 'piggyback_flag', 'primary_table.prp_structure_type = ''COMBO''')
)
UPDATE mdi.edw_field_definition
SET field_source_calculation = new_calculations.calculation
FROM new_calculations
   , mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
  AND edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = new_calculations.table_name
  AND edw_field_definition.field_name = new_calculations.field_name;

-- generate single-row, single-column table containing the source join dwid for loan_dim.los_loan_number
-- and loan_junk_dim.piggyback_flag (they use the same source join)
WITH join_dwid AS (
    SELECT edw_join_tree_definition.root_join_dwid AS dwid
    FROM mdi.edw_field_definition
    JOIN mdi.edw_table_definition
         ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    JOIN mdi.edw_join_tree_definition
         ON edw_field_definition.source_edw_join_tree_definition_dwid = edw_join_tree_definition.dwid
    WHERE edw_table_definition.schema_name = 'star_loan'
      AND edw_table_definition.table_name = 'loan_dim'
      AND edw_field_definition.field_name = 'los_loan_number'
)
--update calculations for loan_dim.los_loan_number and loan_junk_dim.piggyback_flag
   , los_loan_number_calculation AS (
    UPDATE mdi.edw_field_definition
        SET field_source_calculation = 'CASE WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t' ||
                                       join_dwid.dwid ||
                                       '.prp_structure_type = ''STANDALONE_2ND'' THEN t' ||
                                       join_dwid.dwid ||
                                       '.d_los_loan_id_main ELSE t' ||
                                       join_dwid.dwid ||
                                       '.d_los_loan_id_piggyback END'
        FROM mdi.edw_table_definition
            , join_dwid --this is a single-row table, so no join condition is needed
        WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
            AND edw_table_definition.schema_name = 'star_loan'
            AND edw_table_definition.table_name = 'loan_dim'
            AND edw_field_definition.field_name = 'los_loan_number'
)
UPDATE mdi.edw_field_definition
SET field_source_calculation = 'CASE WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t' ||
                               join_dwid.dwid ||
                               '.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE ELSE TRUE END'
FROM mdi.edw_table_definition
   , join_dwid --this is a single-row table, so no join condition is needed
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = 'loan_junk_dim'
  AND edw_field_definition.field_name = 'piggyback_flag';
