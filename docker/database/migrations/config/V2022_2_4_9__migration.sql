/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'smart_doc', 'sd_action_entity_referring_associate', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc', 'sd_action_entity_supplemental_originator', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_key_roles', 'dkrs_referring_associate_fmls', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_key_roles', 'dkrs_referring_associate_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'appraisal_order_request', 'aprq_appraisal_import_warnings', 'TEXT', NULL, NULL, NULL, NULL)
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

WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'smart_doc', 'sd_action_entity_referring_associate', 'BOOLEAN', 'staging', 'staging_octane', 'smart_doc', 'sd_action_entity_referring_associate')
         , ('staging', 'history_octane', 'smart_doc', 'sd_action_entity_supplemental_originator', 'BOOLEAN', 'staging', 'staging_octane', 'smart_doc', 'sd_action_entity_supplemental_originator')
         , ('staging', 'history_octane', 'deal_key_roles', 'dkrs_referring_associate_fmls', 'VARCHAR(128)', 'staging', 'staging_octane', 'deal_key_roles', 'dkrs_referring_associate_fmls')
         , ('staging', 'history_octane', 'deal_key_roles', 'dkrs_referring_associate_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'deal_key_roles', 'dkrs_referring_associate_lender_user_pid')
         , ('staging', 'history_octane', 'appraisal_order_request', 'aprq_appraisal_import_warnings', 'TEXT', 'staging', 'staging_octane', 'appraisal_order_request', 'aprq_appraisal_import_warnings')
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

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100333', 'sd_action_entity_referring_associate')
         , ('SP-100333', 'sd_action_entity_supplemental_originator')
         , ('SP-100017', 'dkrs_referring_associate_fmls')
         , ('SP-100017', 'dkrs_referring_associate_lender_user_pid')
         , ('SP-100302', 'aprq_appraisal_import_warnings')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid;


/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100333', 0, '--finding records to insert into history_octane.smart_doc
SELECT staging_table.sd_pid
     , staging_table.sd_version
     , staging_table.sd_account_pid
     , staging_table.sd_doc_set_type
     , staging_table.sd_custom_form_pid
     , staging_table.sd_doc_name
     , staging_table.sd_doc_number
     , staging_table.sd_doc_category_type
     , staging_table.sd_doc_file_source_type
     , staging_table.sd_doc_external_provider_type
     , staging_table.sd_broker_applicable_provider
     , staging_table.sd_action_entities_from_merge_field
     , staging_table.sd_action_entity_applicant
     , staging_table.sd_action_entity_non_applicant
     , staging_table.sd_action_entity_underwriter
     , staging_table.sd_action_entity_originator
     , staging_table.sd_doc_borrower_access_mode_type
     , staging_table.sd_borrower_explanation
     , staging_table.sd_deal_child_type
     , staging_table.sd_doc_fulfill_status_type_default
     , staging_table.sd_prior_to_type
     , staging_table.sd_doc_action_type
     , staging_table.sd_e_delivery
     , staging_table.sd_active
     , staging_table.sd_key_doc_type
     , staging_table.sd_key_doc_include_file
     , staging_table.sd_doc_approval_type
     , staging_table.sd_auto_approve
     , staging_table.sd_auto_include_on_request
     , staging_table.sd_poa_applicable
     , staging_table.sd_action_entity_hud_va_lender_officer
     , staging_table.sd_action_entity_collateral_underwriter
     , staging_table.sd_action_entity_wholesale_client_advocate
     , staging_table.sd_action_entity_correspondent_client_advocate
     , staging_table.sd_action_entity_government_insurance
     , staging_table.sd_action_entity_underwriting_manager
     , staging_table.sd_action_entity_effective_collateral_underwriter
     , staging_table.sd_document_explanation
     , staging_table.sd_document_explanation_reference
     , staging_table.sd_action_entity_supplemental_originator
     , staging_table.sd_action_entity_referring_associate
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc staging_table
LEFT JOIN history_octane.smart_doc history_table
          ON staging_table.sd_pid = history_table.sd_pid
              AND staging_table.sd_version = history_table.sd_version
WHERE history_table.sd_pid IS NULL
UNION ALL
SELECT history_table.sd_pid
     , history_table.sd_version + 1
     , history_table.sd_account_pid
     , history_table.sd_doc_set_type
     , history_table.sd_custom_form_pid
     , history_table.sd_doc_name
     , history_table.sd_doc_number
     , history_table.sd_doc_category_type
     , history_table.sd_doc_file_source_type
     , history_table.sd_doc_external_provider_type
     , history_table.sd_broker_applicable_provider
     , history_table.sd_action_entities_from_merge_field
     , history_table.sd_action_entity_applicant
     , history_table.sd_action_entity_non_applicant
     , history_table.sd_action_entity_underwriter
     , history_table.sd_action_entity_originator
     , history_table.sd_doc_borrower_access_mode_type
     , history_table.sd_borrower_explanation
     , history_table.sd_deal_child_type
     , history_table.sd_doc_fulfill_status_type_default
     , history_table.sd_prior_to_type
     , history_table.sd_doc_action_type
     , history_table.sd_e_delivery
     , history_table.sd_active
     , history_table.sd_key_doc_type
     , history_table.sd_key_doc_include_file
     , history_table.sd_doc_approval_type
     , history_table.sd_auto_approve
     , history_table.sd_auto_include_on_request
     , history_table.sd_poa_applicable
     , history_table.sd_action_entity_hud_va_lender_officer
     , history_table.sd_action_entity_collateral_underwriter
     , history_table.sd_action_entity_wholesale_client_advocate
     , history_table.sd_action_entity_correspondent_client_advocate
     , history_table.sd_action_entity_government_insurance
     , history_table.sd_action_entity_underwriting_manager
     , history_table.sd_action_entity_effective_collateral_underwriter
     , history_table.sd_document_explanation
     , history_table.sd_document_explanation_reference
     , history_table.sd_action_entity_supplemental_originator
     , history_table.sd_action_entity_referring_associate
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc history_table
LEFT JOIN staging_octane.smart_doc staging_table
          ON staging_table.sd_pid = history_table.sd_pid
WHERE staging_table.sd_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_doc deleted_records
    WHERE deleted_records.sd_pid = history_table.sd_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100017', 0, '--finding records to insert into history_octane.deal_key_roles
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
     , staging_table.dkrs_review_requester_1_lender_user_pid
     , staging_table.dkrs_review_requester_1_fmls
     , staging_table.dkrs_review_requester_2_lender_user_pid
     , staging_table.dkrs_review_requester_2_fmls
     , staging_table.dkrs_review_requester_3_lender_user_pid
     , staging_table.dkrs_review_requester_3_fmls
     , staging_table.dkrs_review_requester_4_lender_user_pid
     , staging_table.dkrs_review_requester_4_fmls
     , staging_table.dkrs_review_requester_5_lender_user_pid
     , staging_table.dkrs_review_requester_5_fmls
     , staging_table.dkrs_referring_associate_lender_user_pid
     , staging_table.dkrs_referring_associate_fmls
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_key_roles staging_table
LEFT JOIN history_octane.deal_key_roles history_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
              AND staging_table.dkrs_version = history_table.dkrs_version
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
     , history_table.dkrs_review_requester_1_lender_user_pid
     , history_table.dkrs_review_requester_1_fmls
     , history_table.dkrs_review_requester_2_lender_user_pid
     , history_table.dkrs_review_requester_2_fmls
     , history_table.dkrs_review_requester_3_lender_user_pid
     , history_table.dkrs_review_requester_3_fmls
     , history_table.dkrs_review_requester_4_lender_user_pid
     , history_table.dkrs_review_requester_4_fmls
     , history_table.dkrs_review_requester_5_lender_user_pid
     , history_table.dkrs_review_requester_5_fmls
     , history_table.dkrs_referring_associate_lender_user_pid
     , history_table.dkrs_referring_associate_fmls
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_key_roles history_table
LEFT JOIN staging_octane.deal_key_roles staging_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
WHERE staging_table.dkrs_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_key_roles deleted_records
    WHERE deleted_records.dkrs_pid = history_table.dkrs_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100302', 0, '--finding records to insert into history_octane.appraisal_order_request
SELECT staging_table.aprq_pid
     , staging_table.aprq_version
     , staging_table.aprq_deal_pid
     , staging_table.aprq_appraisal_pid
     , staging_table.aprq_mercury_network_status_request_pid
     , staging_table.aprq_appraisal_order_coarse_status_type
     , staging_table.aprq_order_id
     , staging_table.aprq_order_instructions
     , staging_table.aprq_address_street1
     , staging_table.aprq_address_street2
     , staging_table.aprq_address_city
     , staging_table.aprq_address_state
     , staging_table.aprq_address_postal_code
     , staging_table.aprq_order_request_date
     , staging_table.aprq_response_xml_deal_system_file_pid
     , staging_table.aprq_mismo_xml_deal_system_file_pid
     , staging_table.aprq_appraisal_order_request_type
     , staging_table.aprq_status_check_datetime
     , staging_table.aprq_appraisal_management_company_type
     , staging_table.aprq_requester_lender_user_pid
     , staging_table.aprq_requester_unparsed_name
     , staging_table.aprq_requester_agent_type
     , staging_table.aprq_vendor_status_unique_id
     , staging_table.aprq_appraisal_import_warnings
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.appraisal_order_request staging_table
LEFT JOIN history_octane.appraisal_order_request history_table
          ON staging_table.aprq_pid = history_table.aprq_pid
              AND staging_table.aprq_version = history_table.aprq_version
WHERE history_table.aprq_pid IS NULL
UNION ALL
SELECT history_table.aprq_pid
     , history_table.aprq_version + 1
     , history_table.aprq_deal_pid
     , history_table.aprq_appraisal_pid
     , history_table.aprq_mercury_network_status_request_pid
     , history_table.aprq_appraisal_order_coarse_status_type
     , history_table.aprq_order_id
     , history_table.aprq_order_instructions
     , history_table.aprq_address_street1
     , history_table.aprq_address_street2
     , history_table.aprq_address_city
     , history_table.aprq_address_state
     , history_table.aprq_address_postal_code
     , history_table.aprq_order_request_date
     , history_table.aprq_response_xml_deal_system_file_pid
     , history_table.aprq_mismo_xml_deal_system_file_pid
     , history_table.aprq_appraisal_order_request_type
     , history_table.aprq_status_check_datetime
     , history_table.aprq_appraisal_management_company_type
     , history_table.aprq_requester_lender_user_pid
     , history_table.aprq_requester_unparsed_name
     , history_table.aprq_requester_agent_type
     , history_table.aprq_vendor_status_unique_id
     , history_table.aprq_appraisal_import_warnings
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.appraisal_order_request history_table
LEFT JOIN staging_octane.appraisal_order_request staging_table
          ON staging_table.aprq_pid = history_table.aprq_pid
WHERE staging_table.aprq_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.appraisal_order_request deleted_records
    WHERE deleted_records.aprq_pid = history_table.aprq_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;
