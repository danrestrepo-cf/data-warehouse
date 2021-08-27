--
-- EDW | Incorrect metadata in table input SQL queries: SP-100017 (deal_key_roles ETL)
-- https://app.asana.com/0/0/1200866427041002
--

UPDATE mdi.table_input_step
    SET sql = '--finding records to insert into history_octane.deal_key_roles
SELECT staging_table.dkrs_pid
, staging_table.dkrs_version
, staging_table.dkrs_deal_pid
, staging_table.dkrs_originator_lender_user_pid
, staging_table.dkrs_originator_first_name
, staging_table.dkrs_originator_last_name
, staging_table.dkrs_originator_middle_name
, staging_table.dkrs_originator_fmls_basic
, staging_table.dkrs_originator_nmls_id
, staging_table.dkrs_supplemental_originator_lender_user_pid
, staging_table.dkrs_supplemental_originator_fmls
, staging_table.dkrs_account_executive_lender_user_pid
, staging_table.dkrs_account_executive_fmls
, staging_table.dkrs_investor_conditions_lender_user_pid
, staging_table.dkrs_investor_conditions_fmls
, staging_table.dkrs_investor_stack_to_investor_lender_user_pid
, staging_table.dkrs_investor_stack_to_investor_fmls
, staging_table.dkrs_collateral_to_custodian_lender_user_pid
, staging_table.dkrs_collateral_to_custodian_fmls
, staging_table.dkrs_collateral_to_investor_lender_user_pid
, staging_table.dkrs_collateral_to_investor_fmls
, staging_table.dkrs_transaction_assistant_lender_user_pid
, staging_table.dkrs_transaction_assistant_fmls
, staging_table.dkrs_final_documents_to_investor_lender_user_pid
, staging_table.dkrs_final_documents_to_investor_fmls
, staging_table.dkrs_government_insurance_lender_user_pid
, staging_table.dkrs_government_insurance_fmls
, staging_table.dkrs_funder_lender_user_pid
, staging_table.dkrs_funder_fmls
, staging_table.dkrs_processor_lender_user_pid
, staging_table.dkrs_processor_fmls
, staging_table.dkrs_underwriter_lender_user_pid
, staging_table.dkrs_underwriter_fmls
, staging_table.dkrs_project_underwriter_lender_user_pid
, staging_table.dkrs_project_underwriter_fmls
, staging_table.dkrs_closing_doc_specialist_lender_user_pid
, staging_table.dkrs_closing_doc_specialist_fmls
, staging_table.dkrs_wholesale_client_advocate_lender_user_pid
, staging_table.dkrs_wholesale_client_advocate_fmls
, staging_table.dkrs_closing_scheduler_lender_user_pid
, staging_table.dkrs_closing_scheduler_fmls
, staging_table.dkrs_collateral_underwriter_lender_user_pid
, staging_table.dkrs_collateral_underwriter_fmls
, staging_table.dkrs_correspondent_client_advocate_lender_user_pid
, staging_table.dkrs_correspondent_client_advocate_fmls
, staging_table.dkrs_flood_insurance_specialist_lender_user_pid
, staging_table.dkrs_flood_insurance_specialist_fmls
, staging_table.dkrs_hoa_specialist_lender_user_pid
, staging_table.dkrs_hoa_specialist_fmls
, staging_table.dkrs_hoi_specialist_lender_user_pid
, staging_table.dkrs_hoi_specialist_fmls
, staging_table.dkrs_ho6_specialist_lender_user_pid
, staging_table.dkrs_ho6_specialist_fmls
, staging_table.dkrs_hud_va_lender_officer_lender_user_pid
, staging_table.dkrs_hud_va_lender_officer_fmls
, staging_table.dkrs_loan_officer_assistant_lender_user_pid
, staging_table.dkrs_loan_officer_assistant_fmls
, staging_table.dkrs_loan_payoff_specialist_lender_user_pid
, staging_table.dkrs_loan_payoff_specialist_fmls
, staging_table.dkrs_subordination_specialist_lender_user_pid
, staging_table.dkrs_subordination_specialist_fmls
, staging_table.dkrs_title_specialist_lender_user_pid
, staging_table.dkrs_title_specialist_fmls
, staging_table.dkrs_underwriting_manager_lender_user_pid
, staging_table.dkrs_underwriting_manager_fmls
, staging_table.dkrs_va_specialist_lender_user_pid
, staging_table.dkrs_va_specialist_fmls
, staging_table.dkrs_verbal_voe_specialist_lender_user_pid
, staging_table.dkrs_verbal_voe_specialist_fmls
, staging_table.dkrs_voe_specialist_lender_user_pid
, staging_table.dkrs_voe_specialist_fmls
, staging_table.dkrs_wire_specialist_lender_user_pid
, staging_table.dkrs_wire_specialist_fmls
, staging_table.dkrs_internal_construction_manager_lender_user_pid
, staging_table.dkrs_internal_construction_manager_fmls
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_key_roles staging_table
LEFT JOIN history_octane.deal_key_roles history_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid AND staging_table.dkrs_version = history_table.dkrs_version
WHERE history_table.dkrs_pid IS NULL
UNION ALL
SELECT history_table.dkrs_pid
, history_table.dkrs_version + 1
, history_table.dkrs_deal_pid
, history_table.dkrs_originator_lender_user_pid
, history_table.dkrs_originator_first_name
, history_table.dkrs_originator_last_name
, history_table.dkrs_originator_middle_name
, history_table.dkrs_originator_fmls_basic
, history_table.dkrs_originator_nmls_id
, history_table.dkrs_supplemental_originator_lender_user_pid
, history_table.dkrs_supplemental_originator_fmls
, history_table.dkrs_account_executive_lender_user_pid
, history_table.dkrs_account_executive_fmls
, history_table.dkrs_investor_conditions_lender_user_pid
, history_table.dkrs_investor_conditions_fmls
, history_table.dkrs_investor_stack_to_investor_lender_user_pid
, history_table.dkrs_investor_stack_to_investor_fmls
, history_table.dkrs_collateral_to_custodian_lender_user_pid
, history_table.dkrs_collateral_to_custodian_fmls
, history_table.dkrs_collateral_to_investor_lender_user_pid
, history_table.dkrs_collateral_to_investor_fmls
, history_table.dkrs_transaction_assistant_lender_user_pid
, history_table.dkrs_transaction_assistant_fmls
, history_table.dkrs_final_documents_to_investor_lender_user_pid
, history_table.dkrs_final_documents_to_investor_fmls
, history_table.dkrs_government_insurance_lender_user_pid
, history_table.dkrs_government_insurance_fmls
, history_table.dkrs_funder_lender_user_pid
, history_table.dkrs_funder_fmls
, history_table.dkrs_processor_lender_user_pid
, history_table.dkrs_processor_fmls
, history_table.dkrs_underwriter_lender_user_pid
, history_table.dkrs_underwriter_fmls
, history_table.dkrs_project_underwriter_lender_user_pid
, history_table.dkrs_project_underwriter_fmls
, history_table.dkrs_closing_doc_specialist_lender_user_pid
, history_table.dkrs_closing_doc_specialist_fmls
, history_table.dkrs_wholesale_client_advocate_lender_user_pid
, history_table.dkrs_wholesale_client_advocate_fmls
, history_table.dkrs_closing_scheduler_lender_user_pid
, history_table.dkrs_closing_scheduler_fmls
, history_table.dkrs_collateral_underwriter_lender_user_pid
, history_table.dkrs_collateral_underwriter_fmls
, history_table.dkrs_correspondent_client_advocate_lender_user_pid
, history_table.dkrs_correspondent_client_advocate_fmls
, history_table.dkrs_flood_insurance_specialist_lender_user_pid
, history_table.dkrs_flood_insurance_specialist_fmls
, history_table.dkrs_hoa_specialist_lender_user_pid
, history_table.dkrs_hoa_specialist_fmls
, history_table.dkrs_hoi_specialist_lender_user_pid
, history_table.dkrs_hoi_specialist_fmls
, history_table.dkrs_ho6_specialist_lender_user_pid
, history_table.dkrs_ho6_specialist_fmls
, history_table.dkrs_hud_va_lender_officer_lender_user_pid
, history_table.dkrs_hud_va_lender_officer_fmls
, history_table.dkrs_loan_officer_assistant_lender_user_pid
, history_table.dkrs_loan_officer_assistant_fmls
, history_table.dkrs_loan_payoff_specialist_lender_user_pid
, history_table.dkrs_loan_payoff_specialist_fmls
, history_table.dkrs_subordination_specialist_lender_user_pid
, history_table.dkrs_subordination_specialist_fmls
, history_table.dkrs_title_specialist_lender_user_pid
, history_table.dkrs_title_specialist_fmls
, history_table.dkrs_underwriting_manager_lender_user_pid
, history_table.dkrs_underwriting_manager_fmls
, history_table.dkrs_va_specialist_lender_user_pid
, history_table.dkrs_va_specialist_fmls
, history_table.dkrs_verbal_voe_specialist_lender_user_pid
, history_table.dkrs_verbal_voe_specialist_fmls
, history_table.dkrs_voe_specialist_lender_user_pid
, history_table.dkrs_voe_specialist_fmls
, history_table.dkrs_wire_specialist_lender_user_pid
, history_table.dkrs_wire_specialist_fmls
, history_table.dkrs_internal_construction_manager_lender_user_pid
, history_table.dkrs_internal_construction_manager_fmls
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_key_roles history_table
LEFT JOIN staging_octane.deal_key_roles staging_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
WHERE staging_table.dkrs_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.deal_key_roles deleted_records
                  WHERE deleted_records.dkrs_pid = history_table.dkrs_pid AND deleted_records.data_source_deleted_flag = TRUE );'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = 'deal_key_roles'
    );
