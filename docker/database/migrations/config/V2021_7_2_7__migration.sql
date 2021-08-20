--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-20)
-- https://app.asana.com/0/0/1200801318938944
--

-- Insert metadata for new tables: qualified_mortgage_rule_version_type
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'qualified_mortgage_rule_version_type', NULL)
        RETURNING dwid, table_name
)

   , new_history_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        SELECT 'staging'
             , 'history_octane'
             , new_staging_table_definitions.table_name
             , new_staging_table_definitions.dwid
        FROM new_staging_table_definitions
        RETURNING dwid, table_name
)

   , new_fields (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('staging_octane', 'qualified_mortgage_rule_version_type', 'code', TRUE, NULL)
         , ('staging_octane', 'qualified_mortgage_rule_version_type', 'value', FALSE, NULL)
         , ('history_octane', 'qualified_mortgage_rule_version_type', 'code', TRUE, 0)
         , ('history_octane', 'qualified_mortgage_rule_version_type', 'value', FALSE, 1)
         , ('history_octane', 'qualified_mortgage_rule_version_type', 'data_source_updated_datetime', FALSE, 2)
         , ('history_octane', 'qualified_mortgage_rule_version_type', 'data_source_deleted_flag', FALSE, 3)
)

   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid, new_fields.field_name, new_fields.key_field_flag
        FROM new_fields
        JOIN new_staging_table_definitions
             ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid
             , new_fields.field_name
             , new_fields.key_field_flag
             , new_staging_field_definitions.dwid
        FROM new_fields
        JOIN new_staging_table_definitions
             ON new_fields.table_name = new_staging_table_definitions.table_name
        JOIN new_history_table_definitions
             ON new_fields.table_name = new_history_table_definitions.table_name
        LEFT JOIN new_staging_field_definitions
                  ON new_staging_table_definitions.dwid =
                     new_staging_field_definitions.edw_table_definition_dwid
                      AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

   , new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100841', 'qualified_mortgage_rule_version_type', 'code', 'SELECT staging_table.code
, staging_table.value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.qualified_mortgage_rule_version_type staging_table
LEFT JOIN history_octane.qualified_mortgage_rule_version_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
)
   , new_processes AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
             , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)

   , new_table_input_steps AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables,
                                      enable_lazy_conversion, cached_row_meta, connectionname)
        SELECT new_processes.dwid
             , 0
             , new_process_variables.sql
             , 0
             , 'N'
             , 'N'
             , 'N'
             , 'N'
             , 'Staging DB Connection'
        FROM new_processes
        JOIN new_process_variables
             ON new_processes.name = new_process_variables.name
)

   , new_table_output_steps AS (
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                       auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                       return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                       specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT new_processes.dwid
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
        FROM new_processes
        JOIN new_process_variables
             ON new_processes.name = new_process_variables.name
        RETURNING dwid, target_schema, target_table
)

   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT new_table_output_steps.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_table_output_steps
        JOIN new_fields
             ON new_fields.schema_name = new_table_output_steps.target_schema
                 AND new_fields.table_name = new_table_output_steps.target_table
)

   , new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
        JOIN new_process_variables
             ON new_processes.name = new_process_variables.name
)

   , new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)
SELECT 'Finished inserting metadata for new table qualified_mortgage_rule_version_type';

--Insert metadata for new columns: loan.l_qualified_mortgage_rule_version_type, loan.l_qualified_mortgage_apr, loan.l_qualified_mortgage_max_allowed_rate_spread
WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('loan', 'l_qualified_mortgage_rule_version_type', 113)
         , ('loan', 'l_qualified_mortgage_apr', 114)
         , ('loan', 'l_qualified_mortgage_max_allowed_rate_spread', 115)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_fields.field_name, FALSE
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'staging_octane'
                 AND edw_table_definition.table_name = new_fields.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT
        INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
            SELECT edw_table_definition.dwid, new_fields.field_name, FALSE, new_staging_field_definitions.dwid
            FROM new_fields
            JOIN mdi.edw_table_definition
                 ON edw_table_definition.schema_name = 'history_octane'
                     AND edw_table_definition.table_name = new_fields.table_name
            JOIN mdi.edw_table_definition source_table_definition
                 ON source_table_definition.schema_name = 'staging_octane'
                     AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions
                 ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                     AND new_staging_field_definitions.field_name = new_fields.field_name
)
   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid, new_fields.field_name, new_fields.field_name, new_fields.field_order, FALSE
        FROM new_fields
        JOIN mdi.table_output_step
             ON table_output_step.target_schema = 'history_octane'
                 AND table_output_step.target_table = new_fields.table_name
)
   , updated_table_input_sql (table_name, sql) AS (
    VALUES ('loan', '--finding records to insert into history_octane.loan
SELECT staging_table.l_pid, staging_table.l_version, staging_table.l_proposal_pid, staging_table.l_offering_pid, staging_table.l_product_terms_pid, staging_table.l_mortgage_type, staging_table.l_interest_only_type, staging_table.l_buydown_schedule_type, staging_table.l_prepay_penalty_schedule_type, staging_table.l_aus_type, staging_table.l_agency_case_id, staging_table.l_arm_index_datetime, staging_table.l_arm_index_current_value_percent, staging_table.l_arm_margin_percent, staging_table.l_base_loan_amount, staging_table.l_buydown_contributor_type, staging_table.l_target_cash_out_amount, staging_table.l_heloc_maximum_balance_amount, staging_table.l_note_rate_percent, staging_table.l_initial_note_rate_percent, staging_table.l_lien_priority_type, staging_table.l_loan_amount, staging_table.l_financed_amount, staging_table.l_ltv_ratio_percent, staging_table.l_base_loan_amount_ltv_ratio_percent, staging_table.l_mi_requirement_ltv_ratio_percent, staging_table.l_mi_auto_compute, staging_table.l_mi_no_mi_product, staging_table.l_mi_input_type, staging_table.l_mi_company_name_type, staging_table.l_mi_certificate_id, staging_table.l_mi_premium_refundable_type, staging_table.l_mi_initial_calculation_type, staging_table.l_mi_renewal_calculation_type, staging_table.l_mi_payer_type, staging_table.l_mi_coverage_percent, staging_table.l_mi_ltv_cutoff_percent, staging_table.l_mi_midpoint_cutoff_required, staging_table.l_mi_required_monthly_payment_count, staging_table.l_mi_actual_monthly_payment_count, staging_table.l_mi_payment_type, staging_table.l_mi_upfront_amount, staging_table.l_mi_upfront_percent, staging_table.l_mi_initial_monthly_payment_amount, staging_table.l_mi_renewal_monthly_payment_annual_percent, staging_table.l_mi_renewal_monthly_payment_amount, staging_table.l_mi_initial_duration_months, staging_table.l_mi_initial_monthly_payment_annual_percent, staging_table.l_mi_initial_calculated_rate_type, staging_table.l_mi_renewal_calculated_rate_type, staging_table.l_mi_base_rate_label, staging_table.l_mi_base_monthly_payment_annual_percent, staging_table.l_mi_base_upfront_percent, staging_table.l_mi_base_monthly_payment_amount, staging_table.l_mi_base_upfront_payment_amount, staging_table.l_qualifying_rate_type, staging_table.l_qualifying_rate_input_percent, staging_table.l_qualifying_rate_percent, staging_table.l_fha_program_code_type, staging_table.l_fha_principal_write_down, staging_table.l_fhac_case_assignment_messages, staging_table.l_initial_pi_amount, staging_table.l_qualifying_pi_amount, staging_table.l_base_note_rate_percent, staging_table.l_base_arm_margin_percent, staging_table.l_base_price_percent, staging_table.l_lock_price_percent, staging_table.l_lock_duration_days, staging_table.l_lock_commitment_type, staging_table.l_product_choice_datetime, staging_table.l_hmda_purchaser_of_loan_2017_type, staging_table.l_hmda_purchaser_of_loan_2018_type, staging_table.l_texas_equity, staging_table.l_texas_equity_auto, staging_table.l_fnm_mbs_investor_contract_id, staging_table.l_base_guaranty_fee_percent, staging_table.l_guaranty_fee_percent, staging_table.l_guaranty_fee_after_alternate_payment_method_percent, staging_table.l_fnm_investor_product_plan_id, staging_table.l_uldd_loan_comment, staging_table.l_principal_curtailment_amount, staging_table.l_agency_case_id_assigned_date, staging_table.l_mi_lender_paid_rate_adjustment_percent, staging_table.l_apr, staging_table.l_finance_charge_amount, staging_table.l_apor_percent, staging_table.l_apor_date, staging_table.l_hmda_rate_spread_percent, staging_table.l_hoepa_apr, staging_table.l_hoepa_rate_spread, staging_table.l_hoepa_fees_dollar_amount, staging_table.l_hmda_hoepa_status_type, staging_table.l_rate_sheet_undiscounted_rate_percent, staging_table.l_effective_undiscounted_rate_percent, staging_table.l_last_unprocessed_changes_datetime, staging_table.l_locked_price_change_percent, staging_table.l_interest_rate_fee_change_amount, staging_table.l_lender_concession_candidate, staging_table.l_durp_eligibility_opt_out, staging_table.l_qualified_mortgage_status_type, staging_table.l_qualified_mortgage, staging_table.l_lqa_purchase_eligibility_type, staging_table.l_student_loan_cash_out_refinance, staging_table.l_mi_rate_quote_id, staging_table.l_mi_integration_vendor_request_pid, staging_table.l_secondary_clear_to_commit, staging_table.l_qm_eligible, staging_table.l_fha_endorsement_date, staging_table.l_va_guaranty_date, staging_table.l_usda_guarantee_date, staging_table.l_hpml, staging_table.l_qualified_mortgage_rule_version_type, staging_table.l_qualified_mortgage_apr, staging_table.l_qualified_mortgage_max_allowed_rate_spread, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.loan staging_table
LEFT JOIN history_octane.loan history_table on staging_table.l_pid = history_table.l_pid and staging_table.l_version = history_table.l_version
WHERE history_table.l_pid is NULL
UNION ALL
SELECT history_table.l_pid, history_table.l_version+1, history_table.l_proposal_pid, history_table.l_offering_pid, history_table.l_product_terms_pid, history_table.l_mortgage_type, history_table.l_interest_only_type, history_table.l_buydown_schedule_type, history_table.l_prepay_penalty_schedule_type, history_table.l_aus_type, history_table.l_agency_case_id, history_table.l_arm_index_datetime, history_table.l_arm_index_current_value_percent, history_table.l_arm_margin_percent, history_table.l_base_loan_amount, history_table.l_buydown_contributor_type, history_table.l_target_cash_out_amount, history_table.l_heloc_maximum_balance_amount, history_table.l_note_rate_percent, history_table.l_initial_note_rate_percent, history_table.l_lien_priority_type, history_table.l_loan_amount, history_table.l_financed_amount, history_table.l_ltv_ratio_percent, history_table.l_base_loan_amount_ltv_ratio_percent, history_table.l_mi_requirement_ltv_ratio_percent, history_table.l_mi_auto_compute, history_table.l_mi_no_mi_product, history_table.l_mi_input_type, history_table.l_mi_company_name_type, history_table.l_mi_certificate_id, history_table.l_mi_premium_refundable_type, history_table.l_mi_initial_calculation_type, history_table.l_mi_renewal_calculation_type, history_table.l_mi_payer_type, history_table.l_mi_coverage_percent, history_table.l_mi_ltv_cutoff_percent, history_table.l_mi_midpoint_cutoff_required, history_table.l_mi_required_monthly_payment_count, history_table.l_mi_actual_monthly_payment_count, history_table.l_mi_payment_type, history_table.l_mi_upfront_amount, history_table.l_mi_upfront_percent, history_table.l_mi_initial_monthly_payment_amount, history_table.l_mi_renewal_monthly_payment_annual_percent, history_table.l_mi_renewal_monthly_payment_amount, history_table.l_mi_initial_duration_months, history_table.l_mi_initial_monthly_payment_annual_percent, history_table.l_mi_initial_calculated_rate_type, history_table.l_mi_renewal_calculated_rate_type, history_table.l_mi_base_rate_label, history_table.l_mi_base_monthly_payment_annual_percent, history_table.l_mi_base_upfront_percent, history_table.l_mi_base_monthly_payment_amount, history_table.l_mi_base_upfront_payment_amount, history_table.l_qualifying_rate_type, history_table.l_qualifying_rate_input_percent, history_table.l_qualifying_rate_percent, history_table.l_fha_program_code_type, history_table.l_fha_principal_write_down, history_table.l_fhac_case_assignment_messages, history_table.l_initial_pi_amount, history_table.l_qualifying_pi_amount, history_table.l_base_note_rate_percent, history_table.l_base_arm_margin_percent, history_table.l_base_price_percent, history_table.l_lock_price_percent, history_table.l_lock_duration_days, history_table.l_lock_commitment_type, history_table.l_product_choice_datetime, history_table.l_hmda_purchaser_of_loan_2017_type, history_table.l_hmda_purchaser_of_loan_2018_type, history_table.l_texas_equity, history_table.l_texas_equity_auto, history_table.l_fnm_mbs_investor_contract_id, history_table.l_base_guaranty_fee_percent, history_table.l_guaranty_fee_percent, history_table.l_guaranty_fee_after_alternate_payment_method_percent, history_table.l_fnm_investor_product_plan_id, history_table.l_uldd_loan_comment, history_table.l_principal_curtailment_amount, history_table.l_agency_case_id_assigned_date, history_table.l_mi_lender_paid_rate_adjustment_percent, history_table.l_apr, history_table.l_finance_charge_amount, history_table.l_apor_percent, history_table.l_apor_date, history_table.l_hmda_rate_spread_percent, history_table.l_hoepa_apr, history_table.l_hoepa_rate_spread, history_table.l_hoepa_fees_dollar_amount, history_table.l_hmda_hoepa_status_type, history_table.l_rate_sheet_undiscounted_rate_percent, history_table.l_effective_undiscounted_rate_percent, history_table.l_last_unprocessed_changes_datetime, history_table.l_locked_price_change_percent, history_table.l_interest_rate_fee_change_amount, history_table.l_lender_concession_candidate, history_table.l_durp_eligibility_opt_out, history_table.l_qualified_mortgage_status_type, history_table.l_qualified_mortgage, history_table.l_lqa_purchase_eligibility_type, history_table.l_student_loan_cash_out_refinance, history_table.l_mi_rate_quote_id, history_table.l_mi_integration_vendor_request_pid, history_table.l_secondary_clear_to_commit, history_table.l_qm_eligible, history_table.l_fha_endorsement_date, history_table.l_va_guaranty_date, history_table.l_usda_guarantee_date, history_table.l_hpml, history_table.l_qualified_mortgage_rule_version_type, history_table.l_qualified_mortgage_apr, history_table.l_qualified_mortgage_max_allowed_rate_spread, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.loan history_table
LEFT JOIN staging_octane.loan staging_table on staging_table.l_pid = history_table.l_pid
WHERE staging_table.l_pid is NULL
  AND not exists (select 1 from history_octane.loan deleted_records where deleted_records.l_pid = history_table.l_pid and deleted_records.data_source_deleted_flag = True);')
)
   , updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql, mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)
SELECT 'Finished inserting metadata for new columns: loan.l_qualified_mortgage_rule_version_type, loan.l_qualified_mortgage_apr, loan.l_qualified_mortgage_max_allowed_rate_spread';

--Delete/Update metadata for dropped table: du_key_finding_type
WITH dropped_table_names (table_name) AS (
    VALUES ('du_key_finding_type')
)
   , dropped_table_processes AS (
    SELECT process.dwid AS process_dwid
         , process.name AS process_name
         , dropped_table_names.table_name
    FROM mdi.process
    JOIN mdi.table_output_step
         ON process.dwid = table_output_step.process_dwid
    JOIN dropped_table_names
         ON table_output_step.target_table = dropped_table_names.table_name
             AND table_output_step.target_schema = 'history_octane'
)
   , nullify_table_definition_source_table AS (
    UPDATE mdi.edw_table_definition
        SET primary_source_edw_table_definition_dwid = NULL
        FROM dropped_table_names
        WHERE edw_table_definition.table_name = dropped_table_names.table_name
            AND edw_table_definition.schema_name = 'history_octane'
)
   , nullify_field_definition_source_field AS (
    UPDATE mdi.edw_field_definition
        SET source_edw_field_definition_dwid = NULL
        FROM dropped_table_names, mdi.edw_table_definition
        WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
            AND edw_table_definition.table_name = dropped_table_names.table_name
            AND edw_table_definition.schema_name = 'history_octane'
)
   , delete_staging_field_definitions AS (
    DELETE FROM mdi.edw_field_definition
        USING mdi.edw_table_definition, dropped_table_names
        WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
            AND edw_table_definition.table_name = dropped_table_names.table_name
            AND edw_table_definition.schema_name = 'staging_octane'
)
   , delete_staging_table_definitions AS (
    DELETE FROM mdi.edw_table_definition
        USING dropped_table_names
        WHERE edw_table_definition.table_name = dropped_table_names.table_name
            AND edw_table_definition.schema_name = 'staging_octane'
)
   , delete_json_output_fields AS (
    DELETE FROM mdi.json_output_field
        USING dropped_table_processes
        WHERE json_output_field.process_dwid = dropped_table_processes.process_dwid
)
   , delete_state_machine_steps AS (
    DELETE FROM mdi.state_machine_step
        USING dropped_table_processes
        WHERE state_machine_step.process_dwid = dropped_table_processes.process_dwid
            OR state_machine_step.next_process_dwid = dropped_table_processes.process_dwid
)
   , delete_state_machine_definitions AS (
    DELETE FROM mdi.state_machine_definition
        USING dropped_table_processes
        WHERE state_machine_definition.process_dwid = dropped_table_processes.process_dwid
)
   , delete_table_output_fields AS (
    DELETE FROM mdi.table_output_field
        USING mdi.table_output_step, dropped_table_processes
        WHERE table_output_step.dwid = table_output_field.table_output_step_dwid
            AND table_output_step.process_dwid = dropped_table_processes.process_dwid
)
   , delete_table_output_steps AS (
    DELETE FROM mdi.table_output_step
        USING dropped_table_processes
        WHERE table_output_step.process_dwid = dropped_table_processes.process_dwid
)
   , delete_table_input_steps AS (
    DELETE FROM mdi.table_input_step
        USING dropped_table_processes
        WHERE table_input_step.process_dwid = dropped_table_processes.process_dwid
)
   , delete_processes AS (
    DELETE FROM mdi.process
        USING dropped_table_processes
        WHERE process.dwid = dropped_table_processes.process_dwid
)
SELECT 'Finished deleting/updating metadata for dropped table: du_key_finding_type';
