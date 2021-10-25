--
-- Main | EDW - Octane schemas from prod-release to v2021.10.4.2 on uat
-- https://app.asana.com/0/0/1201270648418743
--

/*
Insert metadata for new columns
    - deal_key_roles.dkrs_review_requester_1_lender_user_pid
    - deal_key_roles.dkrs_review_requester_1_fmls
    - deal_key_roles.dkrs_review_requester_2_lender_user_pid
    - deal_key_roles.dkrs_review_requester_2_fmls
    - deal_key_roles.dkrs_review_requester_3_lender_user_pid
    - deal_key_roles.dkrs_review_requester_3_fmls
    - deal_key_roles.dkrs_review_requester_4_lender_user_pid
    - deal_key_roles.dkrs_review_requester_4_fmls
    - deal_key_roles.dkrs_review_requester_5_lender_user_pid
    - deal_key_roles.dkrs_review_requester_5_fmls
    - proposal_req.prpr_proposal_review_pid
    - proposal_doc.prpd_proposal_review_pid
*/

WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('deal_key_roles', 'dkrs_review_requester_1_lender_user_pid', 77)
    , ('deal_key_roles', 'dkrs_review_requester_1_fmls', 78)
    , ('deal_key_roles', 'dkrs_review_requester_2_lender_user_pid', 79)
    , ('deal_key_roles', 'dkrs_review_requester_2_fmls', 80)
    , ('deal_key_roles', 'dkrs_review_requester_3_lender_user_pid', 81)
    , ('deal_key_roles', 'dkrs_review_requester_3_fmls', 82)
    , ('deal_key_roles', 'dkrs_review_requester_4_lender_user_pid', 83)
    , ('deal_key_roles', 'dkrs_review_requester_4_fmls', 84)
    , ('deal_key_roles', 'dkrs_review_requester_5_lender_user_pid', 85)
    , ('deal_key_roles', 'dkrs_review_requester_5_fmls', 86)
    , ('proposal_req', 'prpr_proposal_review_pid', 47)
    , ('proposal_doc', 'prpd_proposal_review_pid', 56)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , FALSE
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'staging_octane'
                AND new_fields.table_name = edw_table_definition.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , FALSE
             , new_staging_field_definitions.dwid
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'history_octane'
                AND new_fields.table_name = edw_table_definition.table_name
            JOIN mdi.edw_table_definition AS source_table_definition ON source_table_definition.schema_name = 'staging_octane'
                AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                AND new_staging_field_definitions.field_name = new_fields.field_name
)

, new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_fields
            JOIN mdi.table_output_step ON table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = new_fields.table_name
)

, updated_table_input_sql (table_name, sql) AS (
    VALUES ('deal_key_roles', '--finding records to insert into history_octane.deal_key_roles
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
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_key_roles history_table
LEFT JOIN staging_octane.deal_key_roles staging_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
WHERE staging_table.dkrs_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.deal_key_roles deleted_records
                  WHERE deleted_records.dkrs_pid = history_table.dkrs_pid AND deleted_records.data_source_deleted_flag = TRUE );')
        , ('proposal_doc', '--finding records to insert into history_octane.proposal_doc
SELECT staging_table.prpd_pid
, staging_table.prpd_version
, staging_table.prpd_doc_name
, staging_table.prpd_doc_number
, staging_table.prpd_borrower_access
, staging_table.prpd_deal_child_type
, staging_table.prpd_deal_child_name
, staging_table.prpd_deal_pid
, staging_table.prpd_proposal_pid
, staging_table.prpd_loan_pid
, staging_table.prpd_borrower_pid
, staging_table.prpd_borrower_income_pid
, staging_table.prpd_job_income_pid
, staging_table.prpd_borrower_job_gap_pid
, staging_table.prpd_other_income_pid
, staging_table.prpd_business_income_pid
, staging_table.prpd_rental_income_pid
, staging_table.prpd_asset_pid
, staging_table.prpd_asset_large_deposit_pid
, staging_table.prpd_liability_pid
, staging_table.prpd_reo_place_pid
, staging_table.prpd_property_place_pid
, staging_table.prpd_residence_place_pid
, staging_table.prpd_borrower_residence_pid
, staging_table.prpd_application_pid
, staging_table.prpd_credit_inquiry_pid
, staging_table.prpd_appraisal_pid
, staging_table.prpd_appraisal_form_pid
, staging_table.prpd_tax_transcript_request_pid
, staging_table.prpd_trash
, staging_table.prpd_smart_doc_pid
, staging_table.prpd_proposal_doc_set_pid
, staging_table.prpd_doc_fulfill_status_type
, staging_table.prpd_status_unparsed_name
, staging_table.prpd_status_datetime
, staging_table.prpd_status_reason
, staging_table.prpd_doc_excluded
, staging_table.prpd_doc_excluded_reason
, staging_table.prpd_doc_excluded_unparsed_name
, staging_table.prpd_doc_excluded_datetime
, staging_table.prpd_doc_approval_type
, staging_table.prpd_borrower_edit
, staging_table.prpd_borrower_associated_address_pid
, staging_table.prpd_construction_cost_pid
, staging_table.prpd_construction_draw_pid
, staging_table.prpd_proposal_contractor_pid
, staging_table.prpd_doc_provider_group_type
, staging_table.prpd_doc_req_fulfill_status_type
, staging_table.prpd_doc_req_decision_status_type
, staging_table.prpd_doc_status_type
, staging_table.prpd_proposal_review_pid
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.proposal_doc staging_table
         LEFT JOIN history_octane.proposal_doc history_table on staging_table.prpd_pid = history_table.prpd_pid and staging_table.prpd_version = history_table.prpd_version
WHERE history_table.prpd_pid is NULL
UNION ALL
SELECT history_table.prpd_pid
, history_table.prpd_version+1
, history_table.prpd_doc_name
, history_table.prpd_doc_number
, history_table.prpd_borrower_access
, history_table.prpd_deal_child_type
, history_table.prpd_deal_child_name
, history_table.prpd_deal_pid
, history_table.prpd_proposal_pid
, history_table.prpd_loan_pid
, history_table.prpd_borrower_pid
, history_table.prpd_borrower_income_pid
, history_table.prpd_job_income_pid
, history_table.prpd_borrower_job_gap_pid
, history_table.prpd_other_income_pid
, history_table.prpd_business_income_pid
, history_table.prpd_rental_income_pid
, history_table.prpd_asset_pid
, history_table.prpd_asset_large_deposit_pid
, history_table.prpd_liability_pid
, history_table.prpd_reo_place_pid
, history_table.prpd_property_place_pid
, history_table.prpd_residence_place_pid
, history_table.prpd_borrower_residence_pid
, history_table.prpd_application_pid
, history_table.prpd_credit_inquiry_pid
, history_table.prpd_appraisal_pid
, history_table.prpd_appraisal_form_pid
, history_table.prpd_tax_transcript_request_pid
, history_table.prpd_trash
, history_table.prpd_smart_doc_pid
, history_table.prpd_proposal_doc_set_pid
, history_table.prpd_doc_fulfill_status_type
, history_table.prpd_status_unparsed_name
, history_table.prpd_status_datetime
, history_table.prpd_status_reason
, history_table.prpd_doc_excluded
, history_table.prpd_doc_excluded_reason
, history_table.prpd_doc_excluded_unparsed_name
, history_table.prpd_doc_excluded_datetime
, history_table.prpd_doc_approval_type
, history_table.prpd_borrower_edit
, history_table.prpd_borrower_associated_address_pid
, history_table.prpd_construction_cost_pid
, history_table.prpd_construction_draw_pid
, history_table.prpd_proposal_contractor_pid
, history_table.prpd_doc_provider_group_type
, history_table.prpd_doc_req_fulfill_status_type
, history_table.prpd_doc_req_decision_status_type
, history_table.prpd_doc_status_type
, history_table.prpd_proposal_review_pid
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.proposal_doc history_table
         LEFT JOIN staging_octane.proposal_doc staging_table on staging_table.prpd_pid = history_table.prpd_pid
WHERE staging_table.prpd_pid is NULL
  AND not exists (select 1 from history_octane.proposal_doc deleted_records where deleted_records.prpd_pid = history_table.prpd_pid and deleted_records.data_source_deleted_flag = True)')
        , ('proposal_req', '--finding records to insert into history_octane.proposal_req
SELECT staging_table.prpr_pid
, staging_table.prpr_version
, staging_table.prpr_proposal_doc_pid
, staging_table.prpr_req_name
, staging_table.prpr_borrower_access
, staging_table.prpr_req_id
, staging_table.prpr_req_fulfill_status_type
, staging_table.prpr_fulfill_status_unparsed_name
, staging_table.prpr_fulfill_status_reason
, staging_table.prpr_fulfill_status_datetime
, staging_table.prpr_req_decision_status_type
, staging_table.prpr_decision_status_unparsed_name
, staging_table.prpr_decision_status_reason
, staging_table.prpr_decision_status_datetime
, staging_table.prpr_deal_pid
, staging_table.prpr_proposal_pid
, staging_table.prpr_loan_pid
, staging_table.prpr_borrower_pid
, staging_table.prpr_borrower_income_pid
, staging_table.prpr_job_income_pid
, staging_table.prpr_borrower_job_gap_pid
, staging_table.prpr_other_income_pid
, staging_table.prpr_business_income_pid
, staging_table.prpr_rental_income_pid
, staging_table.prpr_asset_pid
, staging_table.prpr_asset_large_deposit_pid
, staging_table.prpr_liability_pid
, staging_table.prpr_reo_place_pid
, staging_table.prpr_property_place_pid
, staging_table.prpr_residence_place_pid
, staging_table.prpr_borrower_residence_pid
, staging_table.prpr_application_pid
, staging_table.prpr_credit_inquiry_pid
, staging_table.prpr_appraisal_pid
, staging_table.prpr_appraisal_form_pid
, staging_table.prpr_tax_transcript_request_pid
, staging_table.prpr_deal_child_type
, staging_table.prpr_deal_child_name
, staging_table.prpr_smart_req
, staging_table.prpr_smart_req_criteria_html
, staging_table.prpr_trash
, staging_table.prpr_borrower_associated_address_pid
, staging_table.prpr_construction_cost_pid
, staging_table.prpr_construction_draw_pid
, staging_table.prpr_proposal_contractor_pid
, staging_table.prpr_proposal_review_pid
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.proposal_req staging_table
LEFT JOIN history_octane.proposal_req history_table on staging_table.prpr_pid = history_table.prpr_pid and staging_table.prpr_version = history_table.prpr_version
WHERE history_table.prpr_pid is NULL
UNION ALL
SELECT history_table.prpr_pid
, history_table.prpr_version+1
, history_table.prpr_proposal_doc_pid
, history_table.prpr_req_name
, history_table.prpr_borrower_access
, history_table.prpr_req_id
, history_table.prpr_req_fulfill_status_type
, history_table.prpr_fulfill_status_unparsed_name
, history_table.prpr_fulfill_status_reason
, history_table.prpr_fulfill_status_datetime
, history_table.prpr_req_decision_status_type
, history_table.prpr_decision_status_unparsed_name
, history_table.prpr_decision_status_reason
, history_table.prpr_decision_status_datetime
, history_table.prpr_deal_pid
, history_table.prpr_proposal_pid
, history_table.prpr_loan_pid
, history_table.prpr_borrower_pid
, history_table.prpr_borrower_income_pid
, history_table.prpr_job_income_pid
, history_table.prpr_borrower_job_gap_pid
, history_table.prpr_other_income_pid
, history_table.prpr_business_income_pid
, history_table.prpr_rental_income_pid
, history_table.prpr_asset_pid
, history_table.prpr_asset_large_deposit_pid
, history_table.prpr_liability_pid
, history_table.prpr_reo_place_pid
, history_table.prpr_property_place_pid
, history_table.prpr_residence_place_pid
, history_table.prpr_borrower_residence_pid
, history_table.prpr_application_pid
, history_table.prpr_credit_inquiry_pid
, history_table.prpr_appraisal_pid
, history_table.prpr_appraisal_form_pid
, history_table.prpr_tax_transcript_request_pid
, history_table.prpr_deal_child_type
, history_table.prpr_deal_child_name
, history_table.prpr_smart_req
, history_table.prpr_smart_req_criteria_html
, history_table.prpr_trash
, history_table.prpr_borrower_associated_address_pid
, history_table.prpr_construction_cost_pid
, history_table.prpr_construction_draw_pid
, history_table.prpr_proposal_contractor_pid
, history_table.prpr_proposal_review_pid
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.proposal_req history_table
LEFT JOIN staging_octane.proposal_req staging_table on staging_table.prpr_pid = history_table.prpr_pid
WHERE staging_table.prpr_pid is NULL
    AND not exists (select 1 from history_octane.proposal_req deleted_records where deleted_records.prpr_pid = history_table.prpr_pid and deleted_records.data_source_deleted_flag = True)')
)

, updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql
            , mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)

SELECT 'Finished inserting metadata for new columns: deal_key_roles.dkrs_review_requester_1_lender_user_pid, ' ||
       'deal_key_roles.dkrs_review_requester_1_fmls, deal_key_roles.dkrs_review_requester_2_lender_user_pid, ' ||
       'deal_key_roles.dkrs_review_requester_2_fmls, deal_key_roles.dkrs_review_requester_3_lender_user_pid, ' ||
       'deal_key_roles.dkrs_review_requester_3_fmls, deal_key_roles.dkrs_review_requester_4_lender_user_pid, ' ||
       'deal_key_roles.dkrs_review_requester_4_fmls, deal_key_roles.dkrs_review_requester_5_lender_user_pid, ' ||
       'deal_key_roles.dkrs_review_requester_5_fmls, proposal_req.prpr_proposal_review_pid, ' ||
       'proposal_doc.prpd_proposal_review_pid';

--
-- EDW | star_loan: prevent non-unique dimension insert/update ETLs from performing unnecessary updates
-- https://app.asana.com/0/0/1201178687342618
--

-- loan_fact
UPDATE mdi.table_input_step
    SET sql = 'SELECT loan_fact_incl_new_records.edw_created_datetime
    , loan_fact_incl_new_records.edw_modified_datetime
    , loan_fact_incl_new_records.data_source_integration_columns
    , loan_fact_incl_new_records.data_source_integration_id
    , loan_fact_incl_new_records.data_source_modified_datetime
    , loan_fact_incl_new_records.loan_pid
    , loan_fact_incl_new_records.loan_dwid
    , loan_fact_incl_new_records.loan_junk_dwid
    , loan_fact_incl_new_records.product_choice_dwid
    , loan_fact_incl_new_records.transaction_dwid
    , loan_fact_incl_new_records.transaction_junk_dwid
    , loan_fact_incl_new_records.current_loan_beneficiary_dwid
    , loan_fact_incl_new_records.active_loan_funding_dwid
    , loan_fact_incl_new_records.b1_borrower_dwid
    , loan_fact_incl_new_records.b2_borrower_dwid
    , loan_fact_incl_new_records.b3_borrower_dwid
    , loan_fact_incl_new_records.b4_borrower_dwid
    , loan_fact_incl_new_records.b5_borrower_dwid
    , loan_fact_incl_new_records.c1_borrower_dwid
    , loan_fact_incl_new_records.c2_borrower_dwid
    , loan_fact_incl_new_records.c3_borrower_dwid
    , loan_fact_incl_new_records.c4_borrower_dwid
    , loan_fact_incl_new_records.c5_borrower_dwid
    , loan_fact_incl_new_records.n1_borrower_dwid
    , loan_fact_incl_new_records.n2_borrower_dwid
    , loan_fact_incl_new_records.n3_borrower_dwid
    , loan_fact_incl_new_records.n4_borrower_dwid
    , loan_fact_incl_new_records.n5_borrower_dwid
    , loan_fact_incl_new_records.n6_borrower_dwid
    , loan_fact_incl_new_records.n7_borrower_dwid
    , loan_fact_incl_new_records.n8_borrower_dwid
    , loan_fact_incl_new_records.b1_borrower_demographics_dwid
    , loan_fact_incl_new_records.b1_borrower_lending_profile_dwid
    , loan_fact_incl_new_records.primary_application_dwid
    , loan_fact_incl_new_records.collateral_to_custodian_lender_user_dwid
    , loan_fact_incl_new_records.interim_funder_dwid
    , loan_fact_incl_new_records.product_terms_dwid
    , loan_fact_incl_new_records.product_dwid
    , loan_fact_incl_new_records.product_investor_dwid
    , loan_fact_incl_new_records.hmda_purchaser_of_loan_dwid
    , loan_fact_incl_new_records.apr
    , loan_fact_incl_new_records.base_loan_amount
    , loan_fact_incl_new_records.financed_amount
    , loan_fact_incl_new_records.loan_amount
    , loan_fact_incl_new_records.ltv_ratio_percent
    , loan_fact_incl_new_records.note_rate_percent
    , loan_fact_incl_new_records.purchase_advice_amount
    , loan_fact_incl_new_records.finance_charge_amount
    , loan_fact_incl_new_records.hoepa_fees_dollar_amount
    , loan_fact_incl_new_records.interest_rate_fee_change_amount
    , loan_fact_incl_new_records.principal_curtailment_amount
    , loan_fact_incl_new_records.qualifying_pi_amount
    , loan_fact_incl_new_records.target_cash_out_amount
    , loan_fact_incl_new_records.heloc_maximum_balance_amount
    , loan_fact_incl_new_records.agency_case_id_assigned_date_dwid
    , loan_fact_incl_new_records.apor_date_dwid
    , loan_fact_incl_new_records.application_signed_date_dwid
    , loan_fact_incl_new_records.approved_with_conditions_date_dwid
    , loan_fact_incl_new_records.beneficiary_from_date_dwid
    , loan_fact_incl_new_records.beneficiary_through_date_dwid
    , loan_fact_incl_new_records.collateral_sent_date_dwid
    , loan_fact_incl_new_records.disbursement_date_dwid
    , loan_fact_incl_new_records.early_funding_date_dwid
    , loan_fact_incl_new_records.effective_funding_date_dwid
    , loan_fact_incl_new_records.fha_endorsement_date_dwid
    , loan_fact_incl_new_records.estimated_funding_date_dwid
    , loan_fact_incl_new_records.intent_to_proceed_date_dwid
    , loan_fact_incl_new_records.funding_date_dwid
    , loan_fact_incl_new_records.funding_requested_date_dwid
    , loan_fact_incl_new_records.loan_file_ship_date_dwid
    , loan_fact_incl_new_records.mers_transfer_creation_date_dwid
    , loan_fact_incl_new_records.pending_wire_date_dwid
    , loan_fact_incl_new_records.rejected_date_dwid
    , loan_fact_incl_new_records.return_confirmed_date_dwid
    , loan_fact_incl_new_records.return_request_date_dwid
    , loan_fact_incl_new_records.scheduled_release_date_dwid
    , loan_fact_incl_new_records.usda_guarantee_date_dwid
    , loan_fact_incl_new_records.va_guaranty_date_dwid
    , loan_fact_incl_new_records.account_executive_lender_user_dwid
    , loan_fact_incl_new_records.closing_doc_specialist_lender_user_dwid
    , loan_fact_incl_new_records.closing_scheduler_lender_user_dwid
    , loan_fact_incl_new_records.collateral_to_investor_lender_user_dwid
    , loan_fact_incl_new_records.collateral_underwriter_lender_user_dwid
    , loan_fact_incl_new_records.correspondent_client_advocate_lender_user_dwid
    , loan_fact_incl_new_records.final_documents_to_investor_lender_user_dwid
    , loan_fact_incl_new_records.flood_insurance_specialist_lender_user_dwid
    , loan_fact_incl_new_records.funder_lender_user_dwid
    , loan_fact_incl_new_records.government_insurance_lender_user_dwid
    , loan_fact_incl_new_records.ho6_specialist_lender_user_dwid
    , loan_fact_incl_new_records.hoa_specialist_lender_user_dwid
    , loan_fact_incl_new_records.hoi_specialist_lender_user_dwid
    , loan_fact_incl_new_records.hud_va_lender_officer_lender_user_dwid
    , loan_fact_incl_new_records.internal_construction_manager_lender_user_dwid
    , loan_fact_incl_new_records.investor_conditions_lender_user_dwid
    , loan_fact_incl_new_records.investor_stack_to_investor_lender_user_dwid
    , loan_fact_incl_new_records.loan_officer_assistant_lender_user_dwid
    , loan_fact_incl_new_records.loan_payoff_specialist_lender_user_dwid
    , loan_fact_incl_new_records.originator_lender_user_dwid
    , loan_fact_incl_new_records.processor_lender_user_dwid
    , loan_fact_incl_new_records.project_underwriter_lender_user_dwid
    , loan_fact_incl_new_records.subordination_specialist_lender_user_dwid
    , loan_fact_incl_new_records.supplemental_originator_lender_user_dwid
    , loan_fact_incl_new_records.title_specialist_lender_user_dwid
    , loan_fact_incl_new_records.transaction_assistant_lender_user_dwid
    , loan_fact_incl_new_records.underwriter_lender_user_dwid
    , loan_fact_incl_new_records.underwriting_manager_lender_user_dwid
    , loan_fact_incl_new_records.va_specialist_lender_user_dwid
    , loan_fact_incl_new_records.verbal_voe_specialist_lender_user_dwid
    , loan_fact_incl_new_records.voe_specialist_lender_user_dwid
    , loan_fact_incl_new_records.wholesale_client_advocate_lender_user_dwid
    , loan_fact_incl_new_records.wire_specialist_lender_user_dwid
    , loan_fact_incl_new_records.initial_beneficiary_investor_dwid
    , loan_fact_incl_new_records.first_beneficiary_after_initial_investor_dwid
    , loan_fact_incl_new_records.most_recent_purchasing_beneficiary_investor_dwid
    , loan_fact_incl_new_records.current_beneficiary_investor_dwid
FROM (
SELECT COALESCE(loan_fact.edw_created_datetime, NOW()) AS edw_created_datetime
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
    , COALESCE(current_loan_beneficiary_dim.dwid, 0) AS current_loan_beneficiary_dwid
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
    , COALESCE(collateral_to_custodian.dwid, 0) AS collateral_to_custodian_lender_user_dwid
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
    , COALESCE(account_executive.dwid, 0) AS account_executive_lender_user_dwid
    , COALESCE(closing_doc_specialist.dwid, 0) AS closing_doc_specialist_lender_user_dwid
    , COALESCE(closing_scheduler.dwid, 0) AS closing_scheduler_lender_user_dwid
    , COALESCE(collateral_to_investor.dwid, 0) AS collateral_to_investor_lender_user_dwid
    , COALESCE(collateral_underwriter.dwid, 0) AS collateral_underwriter_lender_user_dwid
    , COALESCE(correspondent_client_advocate.dwid, 0) AS correspondent_client_advocate_lender_user_dwid
    , COALESCE(final_documents_to_investor.dwid, 0) AS final_documents_to_investor_lender_user_dwid
    , COALESCE(flood_insurance_specialist.dwid, 0) AS flood_insurance_specialist_lender_user_dwid
    , COALESCE(funder.dwid, 0) AS funder_lender_user_dwid
    , COALESCE(government_insurance.dwid, 0) AS government_insurance_lender_user_dwid
    , COALESCE(ho6_specialist.dwid, 0) AS ho6_specialist_lender_user_dwid
    , COALESCE(hoa_specialist.dwid, 0) AS hoa_specialist_lender_user_dwid
    , COALESCE(hoi_specialist.dwid, 0) AS hoi_specialist_lender_user_dwid
    , COALESCE(hud_va_lender_officer.dwid, 0) AS hud_va_lender_officer_lender_user_dwid
    , COALESCE(internal_construction_manager.dwid, 0) AS internal_construction_manager_lender_user_dwid
    , COALESCE(investor_conditions.dwid, 0) AS investor_conditions_lender_user_dwid
    , COALESCE(investor_stack_to_investor.dwid, 0) AS investor_stack_to_investor_lender_user_dwid
    , COALESCE(loan_officer_assistant.dwid, 0) AS loan_officer_assistant_lender_user_dwid
    , COALESCE(loan_payoff_specialist.dwid, 0) AS loan_payoff_specialist_lender_user_dwid
    , COALESCE(originator.dwid, 0) AS originator_lender_user_dwid
    , COALESCE(processor.dwid, 0) AS processor_lender_user_dwid
    , COALESCE(project_underwriter.dwid, 0) AS project_underwriter_lender_user_dwid
    , COALESCE(subordination_specialist.dwid, 0) AS subordination_specialist_lender_user_dwid
    , COALESCE(supplemental_originator.dwid, 0) AS supplemental_originator_lender_user_dwid
    , COALESCE(title_specialist.dwid, 0) AS title_specialist_lender_user_dwid
    , COALESCE(transaction_assistant.dwid, 0) AS transaction_assistant_lender_user_dwid
    , COALESCE(underwriter.dwid, 0) AS underwriter_lender_user_dwid
    , COALESCE(underwriting_manager.dwid, 0) AS underwriting_manager_lender_user_dwid
    , COALESCE(va_specialist.dwid, 0) AS va_specialist_lender_user_dwid
    , COALESCE(verbal_voe_specialist.dwid, 0) AS verbal_voe_specialist_lender_user_dwid
    , COALESCE(voe_specialist.dwid, 0) AS voe_specialist_lender_user_dwid
    , COALESCE(wholesale_client_advocate.dwid, 0) AS wholesale_client_advocate_lender_user_dwid
    , COALESCE(wire_specialist.dwid, 0) AS wire_specialist_lender_user_dwid
    , COALESCE(current_beneficiary_investor_dim.dwid, 0) AS current_beneficiary_investor_dwid
    , COALESCE(initial_beneficiary_investor_dim.dwid, 0) AS initial_beneficiary_investor_dwid
    , COALESCE(first_beneficiary_after_initial_investor_dim.dwid, 0) AS
        first_beneficiary_after_initial_investor_dwid
    , COALESCE(most_recent_purchasing_beneficiary_investor_dim.dwid, 0) AS
        most_recent_purchasing_beneficiary_investor_dwid
FROM
    -- history_octane deal
    (
        SELECT deal.*
             , <<deal_partial_load_condition>> AS include_record
        FROM history_octane.deal
        LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
            AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE deal.data_source_deleted_flag IS FALSE
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
        AND borrower_b3.b_borrower_tiny_id_type = ''B3''
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
    -- history_octane.loan_beneficiary: current
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
    -- history_octane.loan_beneficiary: initial beneficiary
    LEFT JOIN (
        SELECT loan_beneficiary.*
            , <<loan_beneficiary_partial_load_condition>> AS include_record
        FROM history_octane.loan_beneficiary
                 LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid =
                                                                                 history_records.lb_pid
            AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
          AND history_records.lb_pid IS NULL
    ) AS initial_loan_beneficiary ON loan.l_pid = initial_loan_beneficiary.lb_loan_pid
        AND initial_loan_beneficiary.lb_initial IS TRUE
    -- history_octane.loan_beneficiary: first beneficiary after initial
    LEFT JOIN (
        SELECT loan_beneficiary.*
            , <<loan_beneficiary_partial_load_condition>> AS include_record
        FROM (
            SELECT loan_beneficiary.*
            FROM history_octane.loan_beneficiary
                JOIN (
                    SELECT loan_beneficiary.lb_loan_pid
                        , MIN(loan_beneficiary.lb_pid) AS min_lb_pid
                    FROM history_octane.loan_beneficiary
                    WHERE loan_beneficiary.lb_initial IS FALSE
                    GROUP BY loan_beneficiary.lb_loan_pid
                ) AS min_lb_pid_per_loan ON loan_beneficiary.lb_pid = min_lb_pid_per_loan.min_lb_pid
            ) AS loan_beneficiary
                LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid = history_records.lb_pid
                    AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
            AND history_records.lb_pid IS NULL
    ) AS first_loan_beneficiary_after_initial ON loan.l_pid = first_loan_beneficiary_after_initial.lb_loan_pid
    -- history_octane.loan_beneficiary: most recent purchasing beneficiary
    LEFT JOIN (
        SELECT loan_beneficiary.*
            , <<loan_beneficiary_partial_load_condition>> AS include_record
        FROM (
            SELECT loan_beneficiary.*
            FROM history_octane.loan_beneficiary
                JOIN (
                    SELECT loan_beneficiary.lb_loan_pid
                        , MAX(loan_beneficiary.lb_pid) AS max_lb_pid
                    FROM history_octane.loan_beneficiary
                    WHERE loan_beneficiary.lb_loan_benef_transfer_status_type IN (''SHIPPED'', ''APPROVED_WITH_CONDITIONS'', ''PENDING_WIRE'', ''PENDING'', ''PURCHASED'')
                    GROUP BY loan_beneficiary.lb_loan_pid
                ) AS max_lb_pid_per_loan ON loan_beneficiary.lb_pid = max_lb_pid_per_loan.max_lb_pid
        ) AS loan_beneficiary
            LEFT JOIN history_octane.loan_beneficiary AS history_records
                ON loan_beneficiary.lb_pid = history_records.lb_pid
                AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
            AND history_records.lb_pid IS NULL
    ) AS most_recent_purchasing_beneficiary ON loan.l_pid = most_recent_purchasing_beneficiary.lb_loan_pid
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
    LEFT JOIN (
        SELECT loan_junk_dim.*
            , <<loan_junk_dim_partial_load_condition>> AS include_record
        FROM star_loan.loan_junk_dim
    ) AS loan_junk_dim ON loan.l_buydown_contributor_type IS NOT DISTINCT FROM loan_junk_dim.buydown_contributor_code
        AND loan.l_fha_program_code_type IS NOT DISTINCT FROM loan_junk_dim.fha_program_code
        AND loan.l_hmda_hoepa_status_type IS NOT DISTINCT FROM loan_junk_dim.hmda_hoepa_status_code
        AND loan.l_durp_eligibility_opt_out IS NOT DISTINCT FROM loan_junk_dim.durp_eligibility_opt_out_flag
        AND loan.l_fha_principal_write_down IS NOT DISTINCT FROM loan_junk_dim.fha_principal_write_down_flag
        AND loan.l_hpml IS NOT DISTINCT FROM loan_junk_dim.hpml_flag
        AND loan.l_lender_concession_candidate IS NOT DISTINCT FROM loan_junk_dim.lender_concession_candidate_flag
        AND proposal.prp_mi_required IS NOT DISTINCT FROM loan_junk_dim.mi_required_flag
        AND (CASE WHEN (loan.l_lien_priority_type IS NULL OR proposal.prp_structure_type IS NULL) THEN NULL
                  WHEN (loan.l_lien_priority_type = ''FIRST'' OR proposal.prp_structure_type = ''STANDALONE_2ND'') THEN FALSE
                  ELSE TRUE END) IS NOT DISTINCT FROM loan_junk_dim.piggyback_flag
        AND loan.l_qm_eligible IS NOT DISTINCT FROM loan_junk_dim.qm_eligible_flag
        AND loan.l_qualified_mortgage IS NOT DISTINCT FROM loan_junk_dim.qualified_mortgage_flag
        AND loan.l_secondary_clear_to_commit IS NOT DISTINCT FROM loan_junk_dim.secondary_clear_to_commit_flag
        AND loan.l_student_loan_cash_out_refinance IS NOT DISTINCT FROM loan_junk_dim.student_loan_cash_out_refinance_flag
        AND loan.l_lien_priority_type IS NOT DISTINCT FROM loan_junk_dim.lien_priority_code
        AND loan.l_lqa_purchase_eligibility_type IS NOT DISTINCT FROM loan_junk_dim.lqa_purchase_eligibility_code
        AND loan.l_qualified_mortgage_status_type IS NOT DISTINCT FROM loan_junk_dim.qualified_mortgage_status_code
        AND loan.l_qualifying_rate_type IS NOT DISTINCT FROM loan_junk_dim.qualifying_rate_code
        AND loan.l_texas_equity_auto IS NOT DISTINCT FROM loan_junk_dim.texas_equity_auto_code
        AND loan.l_texas_equity IS NOT DISTINCT FROM loan_junk_dim.texas_equity_code
        AND loan_junk_dim.data_source_dwid = 1
    -- star_loan.product_choice_dim
    LEFT JOIN (
        SELECT product_choice_dim.*
            , <<product_choice_dim_partial_load_condition>> AS include_record
        FROM star_loan.product_choice_dim
    ) AS product_choice_dim ON loan.l_aus_type IS NOT DISTINCT FROM product_choice_dim.aus_code
        AND loan.l_buydown_schedule_type IS NOT DISTINCT FROM product_choice_dim.buydown_schedule_code
        AND loan.l_interest_only_type IS NOT DISTINCT FROM product_choice_dim.interest_only_code
        AND loan.l_mortgage_type IS NOT DISTINCT FROM product_choice_dim.mortgage_type_code
        AND loan.l_prepay_penalty_schedule_type IS NOT DISTINCT FROM product_choice_dim.prepay_penalty_schedule_code
        AND product_choice_dim.data_source_dwid = 1
    -- star_loan.transaction_junk_dim
    LEFT JOIN (
        SELECT transaction_junk_dim.*
            , <<transaction_junk_dim_partial_load_condition>> AS include_record
        FROM star_loan.transaction_junk_dim
    ) AS transaction_junk_dim ON (CASE WHEN proposal.prp_structure_type = ''COMBO'' THEN TRUE ELSE FALSE
        END) IS NOT DISTINCT FROM transaction_junk_dim.piggyback_flag
        AND proposal.prp_mi_required IS NOT DISTINCT FROM transaction_junk_dim.mi_required_flag
        AND deal.d_test_loan IS NOT DISTINCT FROM transaction_junk_dim.is_test_loan_flag
        AND proposal.prp_structure_type IS NOT DISTINCT FROM transaction_junk_dim.structure_code
        AND proposal.prp_loan_purpose_type IS NOT DISTINCT FROM transaction_junk_dim.loan_purpose_code
        AND transaction_junk_dim.data_source_dwid = 1
    -- star_loan.transaction_dim
    LEFT JOIN (
        SELECT transaction_dim.*
             , <<transaction_dim_partial_load_condition>> AS include_record
        FROM star_loan.transaction_dim
    ) AS transaction_dim ON deal.d_pid = transaction_dim.deal_pid
        AND transaction_dim.data_source_dwid = 1
    -- star_loan.loan_beneficiary_dim: current beneficiary
    LEFT JOIN (
        SELECT loan_beneficiary_dim.*
             , <<loan_beneficiary_dim_partial_load_condition>> AS include_record
        FROM star_loan.loan_beneficiary_dim
    ) AS current_loan_beneficiary_dim
        ON current_loan_beneficiary.lb_pid = current_loan_beneficiary_dim.loan_beneficiary_pid
        AND current_loan_beneficiary_dim.data_source_dwid = 1
    -- star_loan.investor_dim: current beneficiary investor
    LEFT JOIN (
        SELECT investor_dim.*
            , <<investor_dim_partial_load_condition>> AS include_record
        FROM star_loan.investor_dim
    ) AS current_beneficiary_investor_dim
        ON current_loan_beneficiary.lb_investor_pid = current_beneficiary_investor_dim.investor_pid
        AND current_beneficiary_investor_dim.data_source_dwid = 1
    -- star_loan.investor_dim: initial beneficiary investor
    LEFT JOIN (
        SELECT investor_dim.*
            , <<investor_dim_partial_load_condition>> AS include_record
        FROM star_loan.investor_dim
    ) AS initial_beneficiary_investor_dim
        ON initial_loan_beneficiary.lb_investor_pid = initial_beneficiary_investor_dim.investor_pid
        AND initial_beneficiary_investor_dim.data_source_dwid = 1
    -- star_loan.investor_dim: first beneficiary after initial investor
    LEFT JOIN (
        SELECT investor_dim.*
            , <<investor_dim_partial_load_condition>> AS include_record
        FROM star_loan.investor_dim
    ) AS first_beneficiary_after_initial_investor_dim
        ON first_loan_beneficiary_after_initial.lb_investor_pid = first_beneficiary_after_initial_investor_dim.investor_pid
        AND first_beneficiary_after_initial_investor_dim.data_source_dwid = 1
    -- star_loan.investor_dim: most recent purchasing beneficiary investor
    LEFT JOIN (
        SELECT investor_dim.*
            , <<investor_dim_partial_load_condition>> AS include_record
        FROM star_loan.investor_dim
    ) AS most_recent_purchasing_beneficiary_investor_dim
        ON most_recent_purchasing_beneficiary.lb_investor_pid = most_recent_purchasing_beneficiary_investor_dim.investor_pid
        AND most_recent_purchasing_beneficiary_investor_dim.data_source_dwid = 1
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
    LEFT JOIN (
        SELECT borrower_demographics_dim.*
            , <<borrower_demographics_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_demographics_dim
    ) AS borrower_demographics_dim ON borrower_b1.b_ethnicity_collected_visual_or_surname IS NOT DISTINCT FROM
                                                     borrower_demographics_dim.ethnicity_collected_visual_or_surname_code
        AND borrower_b1.b_ethnicity_refused IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_refused_code
        AND (CASE WHEN borrower_b1.b_ethnicity_other_hispanic_or_latino_description <> ''''
            AND borrower_b1.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
            borrower_demographics_dim.ethnicity_other_hispanic_or_latino_description_flag
        AND (CASE WHEN borrower_b1.b_other_race_national_origin_description <> ''''
            AND borrower_b1.b_other_race_national_origin_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
            borrower_demographics_dim.other_race_national_origin_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_american_indian_or_alaska_native_description <> ''''
            AND borrower_b1.b_race_other_american_indian_or_alaska_native_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
            borrower_demographics_dim.race_other_american_indian_or_alaska_native_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_asian_description <> ''''
            AND borrower_b1.b_race_other_asian_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
            borrower_demographics_dim.race_other_asian_description_flag
        AND (CASE WHEN borrower_b1.b_race_other_pacific_islander_description <> ''''
            AND borrower_b1.b_race_other_pacific_islander_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
            borrower_demographics_dim.race_other_pacific_islander_description_flag
        AND borrower_b1.b_ethnicity_cuban IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_cuban_flag
        AND borrower_b1.b_ethnicity_hispanic_or_latino IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_hispanic_or_latino_flag
        AND borrower_b1.b_ethnicity_mexican IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_mexican_flag
        AND borrower_b1.b_ethnicity_not_hispanic_or_latino IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_not_hispanic_or_latino_flag
        AND borrower_b1.b_ethnicity_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_not_obtainable_flag
        AND borrower_b1.b_ethnicity_other_hispanic_or_latino IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_other_hispanic_or_latino_flag
        AND borrower_b1.b_ethnicity_puerto_rican IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_puerto_rican_flag
        AND borrower_b1.b_race_american_indian_or_alaska_native IS NOT DISTINCT FROM borrower_demographics_dim.race_american_indian_or_alaska_native_flag
        AND borrower_b1.b_race_asian IS NOT DISTINCT FROM borrower_demographics_dim.race_asian_flag
        AND borrower_b1.b_race_asian_indian IS NOT DISTINCT FROM borrower_demographics_dim.race_asian_indian_flag
        AND borrower_b1.b_race_black_or_african_american IS NOT DISTINCT FROM borrower_demographics_dim.race_black_or_african_american_flag
        AND borrower_b1.b_race_chinese IS NOT DISTINCT FROM borrower_demographics_dim.race_chinese_flag
        AND borrower_b1.b_race_filipino IS NOT DISTINCT FROM borrower_demographics_dim.race_filipino_flag
        AND borrower_b1.b_race_guamanian_or_chamorro IS NOT DISTINCT FROM borrower_demographics_dim.race_guamanian_or_chamorro_flag
        AND borrower_b1.b_race_information_not_provided IS NOT DISTINCT FROM borrower_demographics_dim.race_information_not_provided_flag
        AND borrower_b1.b_race_japanese IS NOT DISTINCT FROM borrower_demographics_dim.race_japanese_flag
        AND borrower_b1.b_race_korean IS NOT DISTINCT FROM borrower_demographics_dim.race_korean_flag
        AND borrower_b1.b_race_national_origin_refusal IS NOT DISTINCT FROM borrower_demographics_dim.race_national_origin_refusal_flag
        AND borrower_b1.b_race_native_hawaiian IS NOT DISTINCT FROM borrower_demographics_dim.race_native_hawaiian_flag
        AND borrower_b1.b_race_native_hawaiian_or_other_pacific_islander IS NOT DISTINCT FROM borrower_demographics_dim.race_native_hawaiian_or_other_pacific_islander_flag
        AND borrower_b1.b_race_not_applicable IS NOT DISTINCT FROM borrower_demographics_dim.race_not_applicable_flag
        AND borrower_b1.b_race_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.race_not_obtainable_flag
        AND borrower_b1.b_race_other_asian IS NOT DISTINCT FROM borrower_demographics_dim.race_other_asian_flag
        AND borrower_b1.b_race_other_pacific_islander IS NOT DISTINCT FROM borrower_demographics_dim.race_other_pacific_islander_flag
        AND borrower_b1.b_race_samoan IS NOT DISTINCT FROM borrower_demographics_dim.race_samoan_flag
        AND borrower_b1.b_race_vietnamese IS NOT DISTINCT FROM borrower_demographics_dim.race_vietnamese_flag
        AND borrower_b1.b_race_white IS NOT DISTINCT FROM borrower_demographics_dim.race_white_flag
        AND borrower_b1.b_sex_female IS NOT DISTINCT FROM borrower_demographics_dim.sex_female_flag
        AND borrower_b1.b_sex_male IS NOT DISTINCT FROM borrower_demographics_dim.sex_male_flag
        AND borrower_b1.b_sex_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.sex_not_obtainable_flag
        AND borrower_b1.b_marital_status_type IS NOT DISTINCT FROM borrower_demographics_dim.marital_status_code
        AND borrower_b1.b_race_collected_visual_or_surname IS NOT DISTINCT FROM borrower_demographics_dim.race_collected_visual_or_surname_code
        AND borrower_b1.b_race_refused IS NOT DISTINCT FROM borrower_demographics_dim.race_refused_code
        AND borrower_b1.b_schooling_years IS NOT DISTINCT FROM borrower_demographics_dim.schooling_years
        AND borrower_b1.b_sex_collected_visual_or_surname IS NOT DISTINCT FROM borrower_demographics_dim.sex_collected_visual_or_surname_code
        AND borrower_b1.b_sex_refused IS NOT DISTINCT FROM borrower_demographics_dim.sex_refused_code
        AND borrower_demographics_dim.data_source_dwid = 1
    -- star_loan.borrower_lending_profile_dim
    LEFT JOIN (
        SELECT borrower_lending_profile_dim.*
            , <<borrower_lending_profile_dim_partial_load_condition>> AS include_record
        FROM star_loan.borrower_lending_profile_dim
    ) AS borrower_lending_profile_dim ON borrower_b1.b_alimony_child_support IS NOT DISTINCT FROM
                                                        borrower_lending_profile_dim.alimony_child_support_code
        AND borrower_b1.b_bankruptcy IS NOT DISTINCT FROM borrower_lending_profile_dim.bankruptcy_code
        AND borrower_b1.b_borrowed_down_payment IS NOT DISTINCT FROM borrower_lending_profile_dim.borrowed_down_payment_code
        AND borrower_b1.b_citizenship_residency_type IS NOT DISTINCT FROM borrower_lending_profile_dim.citizenship_residency_code
        AND borrower_b1.b_disabled IS NOT DISTINCT FROM borrower_lending_profile_dim.disabled_code
        AND borrower_b1.b_domestic_relationship_state_type IS NOT DISTINCT FROM borrower_lending_profile_dim.domestic_relationship_state_code
        AND borrower_b1.b_has_dependents IS NOT DISTINCT FROM borrower_lending_profile_dim.dependents_code
        AND borrower_b1.b_homeowner_past_three_years IS NOT DISTINCT FROM borrower_lending_profile_dim.homeowner_past_three_years_code
        AND borrower_b1.b_homeownership_education_agency_type IS NOT DISTINCT FROM borrower_lending_profile_dim
            .homeownership_education_agency_code
        AND borrower_b1.b_homeownership_education_type IS NOT DISTINCT FROM borrower_lending_profile_dim.homeownership_education_code
        AND borrower_b1.b_intend_to_occupy IS NOT DISTINCT FROM borrower_lending_profile_dim.intend_to_occupy_code
        AND borrower_b1.b_first_time_homebuyer IS NOT DISTINCT FROM borrower_lending_profile_dim.first_time_homebuyer_flag
        AND borrower_b1.b_first_time_home_buyer_auto_compute IS NOT DISTINCT FROM borrower_lending_profile_dim.first_time_homebuyer_auto_compute_flag
        AND borrower_b1.b_hud_employee IS NOT DISTINCT FROM borrower_lending_profile_dim.hud_employee_flag
        AND borrower_b1.b_lender_employee_status_confirmed IS NOT DISTINCT FROM borrower_lending_profile_dim.lender_employee_status_confirmed_flag
        AND borrower_b1.b_lender_employee IS NOT DISTINCT FROM borrower_lending_profile_dim.lender_employee_code
        AND borrower_b1.b_note_endorser IS NOT DISTINCT FROM borrower_lending_profile_dim.note_endorser_code
        AND borrower_b1.b_obligated_loan_foreclosure IS NOT DISTINCT FROM borrower_lending_profile_dim.obligated_loan_foreclosure_code
        AND borrower_b1.b_on_gsa_list IS NOT DISTINCT FROM borrower_lending_profile_dim.on_gsa_list_code
        AND borrower_b1.b_on_ldp_list IS NOT DISTINCT FROM borrower_lending_profile_dim.on_ldp_list_code
        AND borrower_b1.b_outstanding_judgements IS NOT DISTINCT FROM borrower_lending_profile_dim.outstanding_judgements_code
        AND borrower_b1.b_party_to_lawsuit IS NOT DISTINCT FROM borrower_lending_profile_dim.party_to_lawsuit_code
        AND borrower_b1.b_presently_delinquent IS NOT DISTINCT FROM borrower_lending_profile_dim.presently_delinquent_code
        AND borrower_b1.b_property_foreclosure IS NOT DISTINCT FROM borrower_lending_profile_dim.property_foreclosure_code
        AND borrower_b1.b_spousal_homestead IS NOT DISTINCT FROM borrower_lending_profile_dim.spousal_homestead_code
        AND borrower_b1.b_titleholder IS NOT DISTINCT FROM borrower_lending_profile_dim.titleholder_code
        AND borrower_lending_profile_dim.data_source_dwid = 1
    -- star_loan.lender_user_dim: collateral_to_custodian
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS collateral_to_custodian
        ON deal_key_roles.dkrs_collateral_to_custodian_lender_user_pid = collateral_to_custodian.lender_user_pid
        AND collateral_to_custodian.data_source_dwid = 1
    -- star_loan.lender_user_dim: account_executive
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS account_executive
        ON deal_key_roles.dkrs_account_executive_lender_user_pid = account_executive.lender_user_pid
        AND account_executive.data_source_dwid = 1
    -- star_loan.lender_user_dim: closing_doc_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS closing_doc_specialist
        ON deal_key_roles.dkrs_closing_doc_specialist_lender_user_pid = closing_doc_specialist.lender_user_pid
        AND closing_doc_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: closing_scheduler
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS closing_scheduler
        ON deal_key_roles.dkrs_closing_scheduler_lender_user_pid = closing_scheduler.lender_user_pid
        AND closing_scheduler.data_source_dwid = 1
    -- star_loan.lender_user_dim: collateral_to_investor
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS collateral_to_investor
        ON deal_key_roles.dkrs_collateral_to_investor_lender_user_pid = collateral_to_investor.lender_user_pid
        AND collateral_to_investor.data_source_dwid = 1
    -- star_loan.lender_user_dim: collateral_underwriter
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS collateral_underwriter
        ON deal_key_roles.dkrs_collateral_underwriter_lender_user_pid = collateral_underwriter.lender_user_pid
        AND collateral_underwriter.data_source_dwid = 1
    -- star_loan.lender_user_dim: correspondent_client_advocate
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS correspondent_client_advocate
        ON deal_key_roles.dkrs_correspondent_client_advocate_lender_user_pid = correspondent_client_advocate.lender_user_pid
        AND correspondent_client_advocate.data_source_dwid = 1
    -- star_loan.lender_user_dim: final_documents_to_investor
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS final_documents_to_investor
        ON deal_key_roles.dkrs_final_documents_to_investor_lender_user_pid = final_documents_to_investor.lender_user_pid
        AND final_documents_to_investor.data_source_dwid = 1
    -- star_loan.lender_user_dim: flood_insurance_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS flood_insurance_specialist
        ON deal_key_roles.dkrs_flood_insurance_specialist_lender_user_pid = flood_insurance_specialist.lender_user_pid
        AND flood_insurance_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: funder
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS funder
        ON deal_key_roles.dkrs_funder_lender_user_pid = funder.lender_user_pid
        AND funder.data_source_dwid = 1
    -- star_loan.lender_user_dim: government_insurance
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS government_insurance
        ON deal_key_roles.dkrs_government_insurance_lender_user_pid = government_insurance.lender_user_pid
        AND government_insurance.data_source_dwid = 1
    -- star_loan.lender_user_dim: ho6_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS ho6_specialist
        ON deal_key_roles.dkrs_ho6_specialist_lender_user_pid = ho6_specialist.lender_user_pid
        AND ho6_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: hoa_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS hoa_specialist
        ON deal_key_roles.dkrs_hoa_specialist_lender_user_pid = hoa_specialist.lender_user_pid
        AND hoa_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: hoi_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS hoi_specialist
        ON deal_key_roles.dkrs_hoi_specialist_lender_user_pid = hoi_specialist.lender_user_pid
        AND hoi_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: hud_va_lender_officer
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS hud_va_lender_officer
        ON deal_key_roles.dkrs_hud_va_lender_officer_lender_user_pid = hud_va_lender_officer.lender_user_pid
        AND hud_va_lender_officer.data_source_dwid = 1
    -- star_loan.lender_user_dim: internal_construction_manager
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS internal_construction_manager
        ON deal_key_roles.dkrs_internal_construction_manager_lender_user_pid = internal_construction_manager.lender_user_pid
        AND internal_construction_manager.data_source_dwid = 1
    -- star_loan.lender_user_dim: investor_conditions
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS investor_conditions
        ON deal_key_roles.dkrs_investor_conditions_lender_user_pid = investor_conditions.lender_user_pid
        AND investor_conditions.data_source_dwid = 1
    -- star_loan.lender_user_dim: investor_stack_to_investor
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS investor_stack_to_investor
        ON deal_key_roles.dkrs_investor_stack_to_investor_lender_user_pid = investor_stack_to_investor.lender_user_pid
        AND investor_stack_to_investor.data_source_dwid = 1
    -- star_loan.lender_user_dim: loan_officer_assistant
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS loan_officer_assistant
        ON deal_key_roles.dkrs_loan_officer_assistant_lender_user_pid = loan_officer_assistant.lender_user_pid
        AND loan_officer_assistant.data_source_dwid = 1
    -- star_loan.lender_user_dim: loan_payoff_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS loan_payoff_specialist
        ON deal_key_roles.dkrs_loan_payoff_specialist_lender_user_pid = loan_payoff_specialist.lender_user_pid
        AND loan_payoff_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: originator
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS originator
        ON deal_key_roles.dkrs_originator_lender_user_pid = originator.lender_user_pid
        AND originator.data_source_dwid = 1
    -- star_loan.lender_user_dim: processor
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS processor
        ON deal_key_roles.dkrs_processor_lender_user_pid = processor.lender_user_pid
        AND processor.data_source_dwid = 1
    -- star_loan.lender_user_dim: project_underwriter
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS project_underwriter
        ON deal_key_roles.dkrs_project_underwriter_lender_user_pid = project_underwriter.lender_user_pid
        AND project_underwriter.data_source_dwid = 1
    -- star_loan.lender_user_dim: subordination_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS subordination_specialist
        ON deal_key_roles.dkrs_subordination_specialist_lender_user_pid = subordination_specialist.lender_user_pid
        AND subordination_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: supplemental_originator
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS supplemental_originator
              ON deal_key_roles.dkrs_supplemental_originator_lender_user_pid = supplemental_originator.lender_user_pid
                  AND supplemental_originator.data_source_dwid = 1
    -- star_loan.lender_user_dim: title_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS title_specialist
        ON deal_key_roles.dkrs_title_specialist_lender_user_pid = title_specialist.lender_user_pid
        AND title_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: transaction_assistant
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS transaction_assistant
        ON deal_key_roles.dkrs_transaction_assistant_lender_user_pid = transaction_assistant.lender_user_pid
        AND transaction_assistant.data_source_dwid = 1
    -- star_loan.lender_user_dim: underwriter
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS underwriter
        ON deal_key_roles.dkrs_underwriter_lender_user_pid = underwriter.lender_user_pid
        AND underwriter.data_source_dwid = 1
    -- star_loan.lender_user_dim: underwriting_manager
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS underwriting_manager
        ON deal_key_roles.dkrs_underwriting_manager_lender_user_pid = underwriting_manager.lender_user_pid
        AND underwriting_manager.data_source_dwid = 1
    -- star_loan.lender_user_dim: va_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS va_specialist
        ON deal_key_roles.dkrs_va_specialist_lender_user_pid = va_specialist.lender_user_pid
        AND va_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: verbal_voe_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS verbal_voe_specialist
        ON deal_key_roles.dkrs_verbal_voe_specialist_lender_user_pid = verbal_voe_specialist.lender_user_pid
        AND verbal_voe_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: voe_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS voe_specialist
        ON deal_key_roles.dkrs_voe_specialist_lender_user_pid = voe_specialist.lender_user_pid
        AND voe_specialist.data_source_dwid = 1
    -- star_loan.lender_user_dim: wholesale_client_advocate
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS wholesale_client_advocate
        ON deal_key_roles.dkrs_wholesale_client_advocate_lender_user_pid = wholesale_client_advocate.lender_user_pid
        AND wholesale_client_advocate.data_source_dwid = 1
    -- star_loan.lender_user_dim: wire_specialist
    LEFT JOIN (
        SELECT lender_user_dim.*
             , <<lender_user_dim_partial_load_condition>> AS include_record
        FROM star_loan.lender_user_dim
    ) AS wire_specialist
        ON deal_key_roles.dkrs_wire_specialist_lender_user_pid = wire_specialist.lender_user_pid
        AND wire_specialist.data_source_dwid = 1
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
    ) AS product_dim ON product.p_pid = product_dim.product_pid
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
    ) AS hmda_purchaser_of_loan_dim ON hmda_purchaser_of_loan_2017_type.code IS NOT DISTINCT FROM hmda_purchaser_of_loan_dim.code_2017
        AND hmda_purchaser_of_loan_2018_type.code IS NOT DISTINCT FROM hmda_purchaser_of_loan_dim.code_2018
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
               deal_key_roles.include_record, borrower_b1.include_record, borrower_b2.include_record,
               borrower_b3.include_record,
               borrower_b4.include_record, borrower_b5.include_record, borrower_c1.include_record,
               borrower_c2.include_record,
               borrower_c3.include_record, borrower_c4.include_record, borrower_c5.include_record,
               borrower_n1.include_record,
               borrower_n2.include_record, borrower_n3.include_record, borrower_n4.include_record,
               borrower_n5.include_record,
               borrower_n6.include_record, borrower_n7.include_record, borrower_n8.include_record,
               current_loan_beneficiary.include_record, initial_loan_beneficiary.include_record,
               first_loan_beneficiary_after_initial.include_record, most_recent_purchasing_beneficiary.include_record,
               active_loan_funding.include_record, interim_funder.include_record, product_terms.include_record,
               product.include_record, product_investor.include_record, application_dim.include_record,
               loan_junk_dim.include_record, product_choice_dim.include_record, transaction_junk_dim.include_record,
               borrower_b1_dim.include_record, borrower_b2_dim.include_record, borrower_b3_dim.include_record,
               borrower_b4_dim.include_record, borrower_b5_dim.include_record,
               borrower_c1_dim.include_record, borrower_c2_dim.include_record, borrower_c3_dim.include_record,
               borrower_c4_dim.include_record, borrower_c5_dim.include_record, borrower_n1_dim.include_record,
               borrower_n2_dim.include_record, borrower_n3_dim.include_record, borrower_n4_dim.include_record,
               borrower_n5_dim.include_record, borrower_n6_dim.include_record, borrower_n7_dim.include_record,
               borrower_n8_dim.include_record, borrower_demographics_dim.include_record,
               borrower_lending_profile_dim.include_record, hmda_purchaser_of_loan_dim.include_record,
               interim_funder_dim.include_record,
               investor_dim.include_record, collateral_to_custodian.include_record, account_executive.include_record,
               closing_doc_specialist.include_record, closing_scheduler.include_record,
               collateral_to_investor.include_record,
               collateral_underwriter.include_record, correspondent_client_advocate.include_record,
               final_documents_to_investor.include_record, flood_insurance_specialist.include_record,
               funder.include_record,
               government_insurance.include_record, ho6_specialist.include_record, hoa_specialist.include_record,
               hoi_specialist.include_record, hud_va_lender_officer.include_record,
               internal_construction_manager.include_record, investor_conditions.include_record,
               investor_stack_to_investor.include_record, loan_officer_assistant.include_record,
               loan_payoff_specialist.include_record,
               originator.include_record, processor.include_record, project_underwriter.include_record,
               subordination_specialist.include_record,
               supplemental_originator.include_record, title_specialist.include_record,
               transaction_assistant.include_record,
               underwriter.include_record, underwriting_manager.include_record, va_specialist.include_record,
               verbal_voe_specialist.include_record, voe_specialist.include_record,
               wholesale_client_advocate.include_record,
               wire_specialist.include_record,
               current_loan_beneficiary_dim.include_record, current_beneficiary_investor_dim.include_record,
               initial_beneficiary_investor_dim.include_record,
               first_beneficiary_after_initial_investor_dim.include_record,
               most_recent_purchasing_beneficiary_investor_dim.include_record,
               loan_dim.include_record, loan_funding_dim.include_record, product_dim.include_record,
               product_terms_dim.include_record, transaction_dim.include_record) IS TRUE
) AS loan_fact_incl_new_records
    LEFT JOIN star_loan.loan_fact ON loan_fact_incl_new_records.data_source_integration_id =
                                     loan_fact.data_source_integration_id
        AND loan_fact_incl_new_records.loan_junk_dwid = loan_fact.loan_junk_dwid
        AND loan_fact_incl_new_records.product_choice_dwid = loan_fact.product_choice_dwid
        AND loan_fact_incl_new_records.transaction_dwid = loan_fact.transaction_dwid
        AND loan_fact_incl_new_records.transaction_junk_dwid = loan_fact.transaction_junk_dwid
        AND loan_fact_incl_new_records.current_loan_beneficiary_dwid = loan_fact.current_loan_beneficiary_dwid
        AND loan_fact_incl_new_records.active_loan_funding_dwid = loan_fact.active_loan_funding_dwid
        AND loan_fact_incl_new_records.b1_borrower_dwid = loan_fact.b1_borrower_dwid
        AND loan_fact_incl_new_records.b2_borrower_dwid = loan_fact.b2_borrower_dwid
        AND loan_fact_incl_new_records.b3_borrower_dwid = loan_fact.b3_borrower_dwid
        AND loan_fact_incl_new_records.b4_borrower_dwid = loan_fact.b4_borrower_dwid
        AND loan_fact_incl_new_records.b5_borrower_dwid = loan_fact.b5_borrower_dwid
        AND loan_fact_incl_new_records.c1_borrower_dwid = loan_fact.c1_borrower_dwid
        AND loan_fact_incl_new_records.c2_borrower_dwid = loan_fact.c2_borrower_dwid
        AND loan_fact_incl_new_records.c3_borrower_dwid = loan_fact.c3_borrower_dwid
        AND loan_fact_incl_new_records.c4_borrower_dwid = loan_fact.c4_borrower_dwid
        AND loan_fact_incl_new_records.c5_borrower_dwid = loan_fact.c5_borrower_dwid
        AND loan_fact_incl_new_records.n1_borrower_dwid = loan_fact.n1_borrower_dwid
        AND loan_fact_incl_new_records.n2_borrower_dwid = loan_fact.n2_borrower_dwid
        AND loan_fact_incl_new_records.n3_borrower_dwid = loan_fact.n3_borrower_dwid
        AND loan_fact_incl_new_records.n4_borrower_dwid = loan_fact.n4_borrower_dwid
        AND loan_fact_incl_new_records.n5_borrower_dwid = loan_fact.n5_borrower_dwid
        AND loan_fact_incl_new_records.n6_borrower_dwid = loan_fact.n6_borrower_dwid
        AND loan_fact_incl_new_records.n7_borrower_dwid = loan_fact.n7_borrower_dwid
        AND loan_fact_incl_new_records.n8_borrower_dwid = loan_fact.n8_borrower_dwid
        AND loan_fact_incl_new_records.b1_borrower_demographics_dwid = loan_fact.b1_borrower_demographics_dwid
        AND loan_fact_incl_new_records.b1_borrower_lending_profile_dwid = loan_fact.b1_borrower_lending_profile_dwid
        AND loan_fact_incl_new_records.primary_application_dwid = loan_fact.primary_application_dwid
        AND loan_fact_incl_new_records.collateral_to_custodian_lender_user_dwid =
            loan_fact.collateral_to_custodian_lender_user_dwid
        AND loan_fact_incl_new_records.interim_funder_dwid = loan_fact.interim_funder_dwid
        AND loan_fact_incl_new_records.product_terms_dwid = loan_fact.product_terms_dwid
        AND loan_fact_incl_new_records.product_dwid = loan_fact.product_dwid
        AND loan_fact_incl_new_records.product_investor_dwid = loan_fact.product_investor_dwid
        AND loan_fact_incl_new_records.hmda_purchaser_of_loan_dwid = loan_fact.hmda_purchaser_of_loan_dwid
        AND loan_fact_incl_new_records.apr IS NOT DISTINCT FROM loan_fact.apr
        AND loan_fact_incl_new_records.base_loan_amount IS NOT DISTINCT FROM loan_fact.base_loan_amount
        AND loan_fact_incl_new_records.financed_amount IS NOT DISTINCT FROM loan_fact.financed_amount
        AND loan_fact_incl_new_records.loan_amount IS NOT DISTINCT FROM loan_fact.loan_amount
        AND loan_fact_incl_new_records.ltv_ratio_percent IS NOT DISTINCT FROM loan_fact.ltv_ratio_percent
        AND loan_fact_incl_new_records.note_rate_percent IS NOT DISTINCT FROM loan_fact.note_rate_percent
        AND loan_fact_incl_new_records.purchase_advice_amount IS NOT DISTINCT FROM loan_fact.purchase_advice_amount
        AND loan_fact_incl_new_records.finance_charge_amount IS NOT DISTINCT FROM loan_fact.finance_charge_amount
        AND loan_fact_incl_new_records.hoepa_fees_dollar_amount IS NOT DISTINCT FROM loan_fact.hoepa_fees_dollar_amount
        AND loan_fact_incl_new_records.interest_rate_fee_change_amount IS NOT DISTINCT FROM loan_fact.interest_rate_fee_change_amount
        AND loan_fact_incl_new_records.principal_curtailment_amount IS NOT DISTINCT FROM loan_fact.principal_curtailment_amount
        AND loan_fact_incl_new_records.qualifying_pi_amount IS NOT DISTINCT FROM loan_fact.qualifying_pi_amount
        AND loan_fact_incl_new_records.target_cash_out_amount IS NOT DISTINCT FROM loan_fact.target_cash_out_amount
        AND loan_fact_incl_new_records.heloc_maximum_balance_amount IS NOT DISTINCT FROM loan_fact.heloc_maximum_balance_amount
        AND loan_fact_incl_new_records.agency_case_id_assigned_date_dwid = loan_fact.agency_case_id_assigned_date_dwid
        AND loan_fact_incl_new_records.apor_date_dwid = loan_fact.apor_date_dwid
        AND loan_fact_incl_new_records.application_signed_date_dwid = loan_fact.application_signed_date_dwid
        AND loan_fact_incl_new_records.approved_with_conditions_date_dwid = loan_fact.approved_with_conditions_date_dwid
        AND loan_fact_incl_new_records.beneficiary_from_date_dwid = loan_fact.beneficiary_from_date_dwid
        AND loan_fact_incl_new_records.beneficiary_through_date_dwid = loan_fact.beneficiary_through_date_dwid
        AND loan_fact_incl_new_records.collateral_sent_date_dwid = loan_fact.collateral_sent_date_dwid
        AND loan_fact_incl_new_records.disbursement_date_dwid = loan_fact.disbursement_date_dwid
        AND loan_fact_incl_new_records.early_funding_date_dwid = loan_fact.early_funding_date_dwid
        AND loan_fact_incl_new_records.effective_funding_date_dwid = loan_fact.effective_funding_date_dwid
        AND loan_fact_incl_new_records.fha_endorsement_date_dwid = loan_fact.fha_endorsement_date_dwid
        AND loan_fact_incl_new_records.estimated_funding_date_dwid = loan_fact.estimated_funding_date_dwid
        AND loan_fact_incl_new_records.intent_to_proceed_date_dwid = loan_fact.intent_to_proceed_date_dwid
        AND loan_fact_incl_new_records.funding_date_dwid = loan_fact.funding_date_dwid
        AND loan_fact_incl_new_records.funding_requested_date_dwid = loan_fact.funding_requested_date_dwid
        AND loan_fact_incl_new_records.loan_file_ship_date_dwid = loan_fact.loan_file_ship_date_dwid
        AND loan_fact_incl_new_records.mers_transfer_creation_date_dwid = loan_fact.mers_transfer_creation_date_dwid
        AND loan_fact_incl_new_records.pending_wire_date_dwid = loan_fact.pending_wire_date_dwid
        AND loan_fact_incl_new_records.rejected_date_dwid = loan_fact.rejected_date_dwid
        AND loan_fact_incl_new_records.return_confirmed_date_dwid = loan_fact.return_confirmed_date_dwid
        AND loan_fact_incl_new_records.return_request_date_dwid = loan_fact.return_request_date_dwid
        AND loan_fact_incl_new_records.scheduled_release_date_dwid = loan_fact.scheduled_release_date_dwid
        AND loan_fact_incl_new_records.usda_guarantee_date_dwid = loan_fact.usda_guarantee_date_dwid
        AND loan_fact_incl_new_records.va_guaranty_date_dwid = loan_fact.va_guaranty_date_dwid
        AND loan_fact_incl_new_records.account_executive_lender_user_dwid = loan_fact.account_executive_lender_user_dwid
        AND loan_fact_incl_new_records.closing_doc_specialist_lender_user_dwid =
            loan_fact.closing_doc_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.closing_scheduler_lender_user_dwid = loan_fact.closing_scheduler_lender_user_dwid
        AND loan_fact_incl_new_records.collateral_to_investor_lender_user_dwid =
            loan_fact.collateral_to_investor_lender_user_dwid
        AND loan_fact_incl_new_records.collateral_underwriter_lender_user_dwid =
            loan_fact.collateral_underwriter_lender_user_dwid
        AND loan_fact_incl_new_records.correspondent_client_advocate_lender_user_dwid =
            loan_fact.correspondent_client_advocate_lender_user_dwid
        AND loan_fact_incl_new_records.final_documents_to_investor_lender_user_dwid = loan_fact
            .final_documents_to_investor_lender_user_dwid
        AND loan_fact_incl_new_records.flood_insurance_specialist_lender_user_dwid = loan_fact
            .flood_insurance_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.funder_lender_user_dwid = loan_fact.funder_lender_user_dwid
        AND loan_fact_incl_new_records.government_insurance_lender_user_dwid = loan_fact
            .government_insurance_lender_user_dwid
        AND loan_fact_incl_new_records.ho6_specialist_lender_user_dwid = loan_fact.ho6_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.hoa_specialist_lender_user_dwid = loan_fact.hoa_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.hoi_specialist_lender_user_dwid = loan_fact.hoi_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.hud_va_lender_officer_lender_user_dwid = loan_fact
            .hud_va_lender_officer_lender_user_dwid
        AND loan_fact_incl_new_records.internal_construction_manager_lender_user_dwid = loan_fact
            .internal_construction_manager_lender_user_dwid
        AND loan_fact_incl_new_records.investor_conditions_lender_user_dwid = loan_fact
            .investor_conditions_lender_user_dwid
        AND loan_fact_incl_new_records.investor_stack_to_investor_lender_user_dwid = loan_fact
            .investor_stack_to_investor_lender_user_dwid
        AND loan_fact_incl_new_records.loan_officer_assistant_lender_user_dwid = loan_fact
            .loan_officer_assistant_lender_user_dwid
        AND loan_fact_incl_new_records.loan_payoff_specialist_lender_user_dwid = loan_fact
            .loan_payoff_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.originator_lender_user_dwid = loan_fact.originator_lender_user_dwid
        AND loan_fact_incl_new_records.processor_lender_user_dwid = loan_fact.processor_lender_user_dwid
        AND loan_fact_incl_new_records.project_underwriter_lender_user_dwid = loan_fact
            .project_underwriter_lender_user_dwid
        AND loan_fact_incl_new_records.subordination_specialist_lender_user_dwid = loan_fact
            .subordination_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.supplemental_originator_lender_user_dwid = loan_fact
            .supplemental_originator_lender_user_dwid
        AND loan_fact_incl_new_records.title_specialist_lender_user_dwid = loan_fact.title_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.transaction_assistant_lender_user_dwid = loan_fact
            .transaction_assistant_lender_user_dwid
        AND loan_fact_incl_new_records.underwriter_lender_user_dwid = loan_fact.underwriter_lender_user_dwid
        AND loan_fact_incl_new_records.underwriting_manager_lender_user_dwid = loan_fact
            .underwriting_manager_lender_user_dwid
        AND loan_fact_incl_new_records.va_specialist_lender_user_dwid = loan_fact.va_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.verbal_voe_specialist_lender_user_dwid = loan_fact
            .verbal_voe_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.voe_specialist_lender_user_dwid = loan_fact.voe_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.wholesale_client_advocate_lender_user_dwid = loan_fact
            .wholesale_client_advocate_lender_user_dwid
        AND loan_fact_incl_new_records.wire_specialist_lender_user_dwid = loan_fact.wire_specialist_lender_user_dwid
        AND loan_fact_incl_new_records.initial_beneficiary_investor_dwid = loan_fact.initial_beneficiary_investor_dwid
        AND loan_fact_incl_new_records.first_beneficiary_after_initial_investor_dwid = loan_fact
            .first_beneficiary_after_initial_investor_dwid
        AND loan_fact_incl_new_records.most_recent_purchasing_beneficiary_investor_dwid = loan_fact
            .most_recent_purchasing_beneficiary_investor_dwid
        AND loan_fact_incl_new_records.current_beneficiary_investor_dwid = loan_fact.current_beneficiary_investor_dwid
WHERE loan_fact.loan_dwid IS NULL
;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'loan_fact'
        );


-- application_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT application_dim_incl_new_records.data_source_integration_columns
     , application_dim_incl_new_records.data_source_integration_id
     , application_dim_incl_new_records.edw_created_datetime
     , application_dim_incl_new_records.edw_modified_datetime
     , application_dim_incl_new_records.data_source_modified_datetime
     , application_dim_incl_new_records.application_pid
     , application_dim_incl_new_records.proposal_pid
FROM (
         SELECT
                     ''application_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
                     COALESCE(CAST(primary_table.apl_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
                     now() as edw_created_datetime,
                     now() as edw_modified_datetime,
                     primary_table.data_source_updated_datetime as data_source_modified_datetime,
                     primary_table.apl_pid as application_pid,
                     primary_table.apl_proposal_pid as proposal_pid
         FROM (
                  SELECT
                      <<application_partial_load_condition>> as include_record,
                      application.*
                  FROM history_octane.application
                    LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
                        AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                  WHERE history_records.apl_pid IS NULL
              ) AS primary_table
         WHERE
             GREATEST(primary_table.include_record) IS TRUE
         ORDER BY
             primary_table.data_source_updated_datetime ASC
     ) AS application_dim_incl_new_records
    LEFT JOIN star_loan.application_dim ON application_dim_incl_new_records.data_source_integration_id =
                                     application_dim.data_source_integration_id
        AND application_dim_incl_new_records.proposal_pid IS NOT DISTINCT FROM application_dim.proposal_pid
WHERE application_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'application_dim'
        );


-- borrower_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT borrower_dim_incl_new_records.data_source_integration_columns
    , borrower_dim_incl_new_records.data_source_integration_id
    , borrower_dim_incl_new_records.edw_created_datetime
    , borrower_dim_incl_new_records.edw_modified_datetime
    , borrower_dim_incl_new_records.data_source_modified_datetime
    , borrower_dim_incl_new_records.applicant_role
    , borrower_dim_incl_new_records.application_taken_method
    , borrower_dim_incl_new_records.borrower_pid
    , borrower_dim_incl_new_records.alimony_child_support_explanation
    , borrower_dim_incl_new_records.application_taken_method_code
    , borrower_dim_incl_new_records.bankruptcy_explanation
    , borrower_dim_incl_new_records.birth_date
    , borrower_dim_incl_new_records.borrowed_down_payment_explanation
    , borrower_dim_incl_new_records.applicant_role_code
    , borrower_dim_incl_new_records.required_to_sign_flag
    , borrower_dim_incl_new_records.has_no_ssn_flag
    , borrower_dim_incl_new_records.credit_report_identifier
    , borrower_dim_incl_new_records.credit_report_authorization_flag
    , borrower_dim_incl_new_records.dependent_count
    , borrower_dim_incl_new_records.dependents_age_years
    , borrower_dim_incl_new_records.email
    , borrower_dim_incl_new_records.fax
    , borrower_dim_incl_new_records.first_name
    , borrower_dim_incl_new_records.nickname
    , borrower_dim_incl_new_records.ethnicity_other_hispanic_or_latino_description
    , borrower_dim_incl_new_records.home_phone
    , borrower_dim_incl_new_records.last_name
    , borrower_dim_incl_new_records.middle_name
    , borrower_dim_incl_new_records.name_suffix
    , borrower_dim_incl_new_records.note_endorser_explanation
    , borrower_dim_incl_new_records.obligated_loan_foreclosure_explanation
    , borrower_dim_incl_new_records.office_phone
    , borrower_dim_incl_new_records.office_phone_extension
    , borrower_dim_incl_new_records.other_race_national_origin_description
    , borrower_dim_incl_new_records.outstanding_judgments_explanation
    , borrower_dim_incl_new_records.party_to_lawsuit_explanation
    , borrower_dim_incl_new_records.power_of_attorney_code
    , borrower_dim_incl_new_records.power_of_attorney_signing_capacity
    , borrower_dim_incl_new_records.power_of_attorney_first_name
    , borrower_dim_incl_new_records.power_of_attorney_last_name
    , borrower_dim_incl_new_records.power_of_attorney_middle_name
    , borrower_dim_incl_new_records.power_of_attorney_name_suffix
    , borrower_dim_incl_new_records.power_of_attorney_company_name
    , borrower_dim_incl_new_records.power_of_attorney_title
    , borrower_dim_incl_new_records.power_of_attorney_office_phone
    , borrower_dim_incl_new_records.power_of_attorney_office_phone_extension
    , borrower_dim_incl_new_records.power_of_attorney_mobile_phone
    , borrower_dim_incl_new_records.power_of_attorney_email
    , borrower_dim_incl_new_records.power_of_attorney_fax
    , borrower_dim_incl_new_records.power_of_attorney_city
    , borrower_dim_incl_new_records.power_of_attorney_country_code
    , borrower_dim_incl_new_records.power_of_attorney_postal_code
    , borrower_dim_incl_new_records.power_of_attorney_state
    , borrower_dim_incl_new_records.power_of_attorney_street1
    , borrower_dim_incl_new_records.power_of_attorney_street2
    , borrower_dim_incl_new_records.presently_delinquent_explanation
    , borrower_dim_incl_new_records.prior_property_title_code
    , borrower_dim_incl_new_records.prior_property_usage_code
    , borrower_dim_incl_new_records.property_foreclosure_explanation
    , borrower_dim_incl_new_records.race_other_american_indian_or_alaska_native_description
    , borrower_dim_incl_new_records.race_other_asian_description
    , borrower_dim_incl_new_records.race_other_pacific_islander_description
    , borrower_dim_incl_new_records.experian_credit_score
    , borrower_dim_incl_new_records.equifax_credit_score
    , borrower_dim_incl_new_records.trans_union_credit_score
    , borrower_dim_incl_new_records.decision_credit_score
    , borrower_dim_incl_new_records.tiny_id_code
    , borrower_dim_incl_new_records.first_time_homebuyer_explain
    , borrower_dim_incl_new_records.caivrs_id
    , borrower_dim_incl_new_records.caivrs_messages
    , borrower_dim_incl_new_records.monthly_job_federal_tax_amount
    , borrower_dim_incl_new_records.monthly_job_state_tax_amount
    , borrower_dim_incl_new_records.monthly_job_retirement_tax_amount
    , borrower_dim_incl_new_records.monthly_job_medicare_tax_amount
    , borrower_dim_incl_new_records.monthly_job_state_disability_insurance_amount
    , borrower_dim_incl_new_records.monthly_job_other_tax_1_amount
    , borrower_dim_incl_new_records.monthly_job_other_tax_1_description
    , borrower_dim_incl_new_records.monthly_job_other_tax_2_amount
    , borrower_dim_incl_new_records.monthly_job_other_tax_2_description
    , borrower_dim_incl_new_records.monthly_job_other_tax_3_amount
    , borrower_dim_incl_new_records.monthly_job_other_tax_3_description
    , borrower_dim_incl_new_records.monthly_job_total_tax_amount
    , borrower_dim_incl_new_records.homeownership_education_id
    , borrower_dim_incl_new_records.homeownership_education_name
    , borrower_dim_incl_new_records.housing_counseling_code
    , borrower_dim_incl_new_records.housing_counseling_agency_code
    , borrower_dim_incl_new_records.housing_counseling_id
    , borrower_dim_incl_new_records.housing_counseling_name
    , borrower_dim_incl_new_records.housing_counseling_complete_date
    , borrower_dim_incl_new_records.legal_entity_code
    , borrower_dim_incl_new_records.credit_report_authorization_datetime
    , borrower_dim_incl_new_records.credit_report_authorization_method_code
    , borrower_dim_incl_new_records.credit_report_authorization_obtained_by_unparsed_name
    , borrower_dim_incl_new_records.usda_annual_child_care_expenses
    , borrower_dim_incl_new_records.usda_disability_expenses
    , borrower_dim_incl_new_records.usda_medical_expenses
    , borrower_dim_incl_new_records.usda_income_from_assets
    , borrower_dim_incl_new_records.usda_moderate_income_limit
    , borrower_dim_incl_new_records.relationship_to_primary_borrower_code
    , borrower_dim_incl_new_records.relationship_to_seller_code
    , borrower_dim_incl_new_records.preferred_first_name
    , borrower_dim_incl_new_records.application_pid
    , borrower_dim_incl_new_records.relationship_to_primary_borrower
    , borrower_dim_incl_new_records.relationship_to_seller
    , borrower_dim_incl_new_records.tiny_id
    , borrower_dim_incl_new_records.power_of_attorney_country
    , borrower_dim_incl_new_records.credit_report_authorization_method
    , borrower_dim_incl_new_records.housing_counseling_agency
    , borrower_dim_incl_new_records.housing_counseling
    , borrower_dim_incl_new_records.legal_entity
    , borrower_dim_incl_new_records.prior_property_title
    , borrower_dim_incl_new_records.prior_property_usage
    , borrower_dim_incl_new_records.power_of_attorney
FROM (
SELECT ''borrower_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.b_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        borrower.*
    FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid = history_records.b_pid
            AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<applicant_role_type_partial_load_condition>> as include_record,
            applicant_role_type.*
            FROM history_octane.applicant_role_type
                LEFT JOIN history_octane.applicant_role_type AS history_records ON applicant_role_type.code = history_records.code
                AND applicant_role_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t114 ON primary_table.b_applicant_role_type = t114.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<application_taken_method_type_partial_load_condition>> as include_record,
            application_taken_method_type.*
            FROM history_octane.application_taken_method_type
                LEFT JOIN history_octane.application_taken_method_type AS history_records ON application_taken_method_type.code = history_records.code
                AND application_taken_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t115 ON primary_table.b_application_taken_method_type = t115.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_relationship_type_partial_load_condition>> as include_record,
            borrower_relationship_type.*
            FROM history_octane.borrower_relationship_type
                LEFT JOIN history_octane.borrower_relationship_type AS history_records ON borrower_relationship_type.code = history_records.code
                AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t149 ON primary_table.b_relationship_to_primary_borrower_type = t149.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_relationship_type_partial_load_condition>> as include_record,
            borrower_relationship_type.*
            FROM history_octane.borrower_relationship_type
                LEFT JOIN history_octane.borrower_relationship_type AS history_records ON borrower_relationship_type.code = history_records.code
                AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t150 ON primary_table.b_relationship_to_seller_type = t150.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_tiny_id_type_partial_load_condition>> as include_record,
            borrower_tiny_id_type.*
            FROM history_octane.borrower_tiny_id_type
                LEFT JOIN history_octane.borrower_tiny_id_type AS history_records ON borrower_tiny_id_type.code = history_records.code
                AND borrower_tiny_id_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t118 ON primary_table.b_borrower_tiny_id_type = t118.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t142 ON primary_table.b_power_of_attorney_country = t142.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_authorization_method_type_partial_load_condition>> as include_record,
            credit_authorization_method_type.*
            FROM history_octane.credit_authorization_method_type
                LEFT JOIN history_octane.credit_authorization_method_type AS history_records ON credit_authorization_method_type.code = history_records.code
                AND credit_authorization_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t120 ON primary_table.b_credit_report_authorization_method = t120.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_agency_type_partial_load_condition>> as include_record,
            housing_counseling_agency_type.*
            FROM history_octane.housing_counseling_agency_type
                LEFT JOIN history_octane.housing_counseling_agency_type AS history_records ON housing_counseling_agency_type.code = history_records.code
                AND housing_counseling_agency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t129 ON primary_table.b_housing_counseling_agency_type = t129.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_type_partial_load_condition>> as include_record,
            housing_counseling_type.*
            FROM history_octane.housing_counseling_type
                LEFT JOIN history_octane.housing_counseling_type AS history_records ON housing_counseling_type.code = history_records.code
                AND housing_counseling_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t130 ON primary_table.b_housing_counseling_type = t130.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<legal_entity_type_partial_load_condition>> as include_record,
            legal_entity_type.*
            FROM history_octane.legal_entity_type
                LEFT JOIN history_octane.legal_entity_type AS history_records ON legal_entity_type.code = history_records.code
                AND legal_entity_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t132 ON primary_table.b_legal_entity_type = t132.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prior_property_title_type_partial_load_condition>> as include_record,
            prior_property_title_type.*
            FROM history_octane.prior_property_title_type
                LEFT JOIN history_octane.prior_property_title_type AS history_records ON prior_property_title_type.code = history_records.code
                AND prior_property_title_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t144 ON primary_table.b_prior_property_title_type = t144.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<property_usage_type_partial_load_condition>> as include_record,
            property_usage_type.*
            FROM history_octane.property_usage_type
                LEFT JOIN history_octane.property_usage_type AS history_records ON property_usage_type.code = history_records.code
                AND property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t145 ON primary_table.b_prior_property_usage_type = t145.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t141 ON primary_table.b_power_of_attorney = t141.code
 WHERE
    GREATEST(primary_table.include_record, t114.include_record, t115.include_record, t149.include_record, t150.include_record, t118.include_record, t142.include_record, t120.include_record, t129.include_record, t130.include_record, t132.include_record, t144.include_record, t145.include_record, t141.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS borrower_dim_incl_new_records
    LEFT JOIN star_loan.borrower_dim ON borrower_dim_incl_new_records.data_source_integration_id = borrower_dim.data_source_integration_id
        AND borrower_dim_incl_new_records.application_pid = borrower_dim.application_pid
        AND borrower_dim_incl_new_records.alimony_child_support_explanation IS NOT DISTINCT FROM borrower_dim.alimony_child_support_explanation
        AND borrower_dim_incl_new_records.applicant_role IS NOT DISTINCT FROM borrower_dim.applicant_role
        AND borrower_dim_incl_new_records.applicant_role_code IS NOT DISTINCT FROM borrower_dim.applicant_role_code
        AND borrower_dim_incl_new_records.application_taken_method IS NOT DISTINCT FROM borrower_dim.application_taken_method
        AND borrower_dim_incl_new_records.application_taken_method_code IS NOT DISTINCT FROM borrower_dim.application_taken_method_code
        AND borrower_dim_incl_new_records.bankruptcy_explanation IS NOT DISTINCT FROM borrower_dim.bankruptcy_explanation
        AND borrower_dim_incl_new_records.birth_date IS NOT DISTINCT FROM borrower_dim.birth_date
        AND borrower_dim_incl_new_records.borrowed_down_payment_explanation IS NOT DISTINCT FROM borrower_dim.borrowed_down_payment_explanation
        AND borrower_dim_incl_new_records.caivrs_id IS NOT DISTINCT FROM borrower_dim.caivrs_id
        AND borrower_dim_incl_new_records.caivrs_messages IS NOT DISTINCT FROM borrower_dim.caivrs_messages
        AND borrower_dim_incl_new_records.credit_report_authorization_datetime IS NOT DISTINCT FROM borrower_dim
            .credit_report_authorization_datetime
        AND borrower_dim_incl_new_records.credit_report_authorization_method IS NOT DISTINCT FROM borrower_dim
            .credit_report_authorization_method
        AND borrower_dim_incl_new_records.credit_report_authorization_method_code IS NOT DISTINCT FROM borrower_dim
            .credit_report_authorization_method_code
        AND borrower_dim_incl_new_records.credit_report_authorization_obtained_by_unparsed_name IS NOT DISTINCT FROM borrower_dim
            .credit_report_authorization_obtained_by_unparsed_name
        AND borrower_dim_incl_new_records.credit_report_identifier IS NOT DISTINCT FROM borrower_dim.credit_report_identifier
        AND borrower_dim_incl_new_records.decision_credit_score IS NOT DISTINCT FROM borrower_dim.decision_credit_score
        AND borrower_dim_incl_new_records.dependent_count IS NOT DISTINCT FROM borrower_dim.dependent_count
        AND borrower_dim_incl_new_records.dependents_age_years IS NOT DISTINCT FROM borrower_dim.dependents_age_years
        AND borrower_dim_incl_new_records.email IS NOT DISTINCT FROM borrower_dim.email
        AND borrower_dim_incl_new_records.equifax_credit_score IS NOT DISTINCT FROM borrower_dim.equifax_credit_score
        AND borrower_dim_incl_new_records.ethnicity_other_hispanic_or_latino_description IS NOT DISTINCT FROM borrower_dim
            .ethnicity_other_hispanic_or_latino_description
        AND borrower_dim_incl_new_records.experian_credit_score IS NOT DISTINCT FROM borrower_dim.experian_credit_score
        AND borrower_dim_incl_new_records.fax IS NOT DISTINCT FROM borrower_dim.fax
        AND borrower_dim_incl_new_records.first_name IS NOT DISTINCT FROM borrower_dim.first_name
        AND borrower_dim_incl_new_records.first_time_homebuyer_explain IS NOT DISTINCT FROM borrower_dim.first_time_homebuyer_explain
        AND borrower_dim_incl_new_records.credit_report_authorization_flag IS NOT DISTINCT FROM borrower_dim
            .credit_report_authorization_flag
        AND borrower_dim_incl_new_records.has_no_ssn_flag IS NOT DISTINCT FROM borrower_dim.has_no_ssn_flag
        AND borrower_dim_incl_new_records.power_of_attorney IS NOT DISTINCT FROM borrower_dim.power_of_attorney
        AND borrower_dim_incl_new_records.power_of_attorney_code IS NOT DISTINCT FROM borrower_dim.power_of_attorney_code
        AND borrower_dim_incl_new_records.home_phone IS NOT DISTINCT FROM borrower_dim.home_phone
        AND borrower_dim_incl_new_records.homeownership_education_id IS NOT DISTINCT FROM borrower_dim.homeownership_education_id
        AND borrower_dim_incl_new_records.homeownership_education_name IS NOT DISTINCT FROM borrower_dim.homeownership_education_name
        AND borrower_dim_incl_new_records.housing_counseling IS NOT DISTINCT FROM borrower_dim.housing_counseling
        AND borrower_dim_incl_new_records.housing_counseling_agency IS NOT DISTINCT FROM borrower_dim.housing_counseling_agency
        AND borrower_dim_incl_new_records.housing_counseling_agency_code IS NOT DISTINCT FROM borrower_dim.housing_counseling_agency_code
        AND borrower_dim_incl_new_records.housing_counseling_code IS NOT DISTINCT FROM borrower_dim.housing_counseling_code
        AND borrower_dim_incl_new_records.housing_counseling_complete_date IS NOT DISTINCT FROM borrower_dim
            .housing_counseling_complete_date
        AND borrower_dim_incl_new_records.housing_counseling_id IS NOT DISTINCT FROM borrower_dim.housing_counseling_id
        AND borrower_dim_incl_new_records.housing_counseling_name IS NOT DISTINCT FROM borrower_dim.housing_counseling_name
        AND borrower_dim_incl_new_records.required_to_sign_flag IS NOT DISTINCT FROM borrower_dim.required_to_sign_flag
        AND borrower_dim_incl_new_records.last_name IS NOT DISTINCT FROM borrower_dim.last_name
        AND borrower_dim_incl_new_records.legal_entity IS NOT DISTINCT FROM borrower_dim.legal_entity
        AND borrower_dim_incl_new_records.legal_entity_code IS NOT DISTINCT FROM borrower_dim.legal_entity_code
        AND borrower_dim_incl_new_records.middle_name IS NOT DISTINCT FROM borrower_dim.middle_name
        AND borrower_dim_incl_new_records.monthly_job_federal_tax_amount IS NOT DISTINCT FROM borrower_dim.monthly_job_federal_tax_amount
        AND borrower_dim_incl_new_records.monthly_job_medicare_tax_amount IS NOT DISTINCT FROM borrower_dim
            .monthly_job_medicare_tax_amount
        AND borrower_dim_incl_new_records.monthly_job_other_tax_1_amount IS NOT DISTINCT FROM borrower_dim.monthly_job_other_tax_1_amount
        AND borrower_dim_incl_new_records.monthly_job_other_tax_1_description IS NOT DISTINCT FROM borrower_dim
            .monthly_job_other_tax_1_description
        AND borrower_dim_incl_new_records.monthly_job_other_tax_2_amount IS NOT DISTINCT FROM borrower_dim.monthly_job_other_tax_2_amount
        AND borrower_dim_incl_new_records.monthly_job_other_tax_2_description IS NOT DISTINCT FROM borrower_dim
            .monthly_job_other_tax_2_description
        AND borrower_dim_incl_new_records.monthly_job_other_tax_3_amount IS NOT DISTINCT FROM borrower_dim.monthly_job_other_tax_3_amount
        AND borrower_dim_incl_new_records.monthly_job_other_tax_3_description IS NOT DISTINCT FROM borrower_dim
            .monthly_job_other_tax_3_description
        AND borrower_dim_incl_new_records.monthly_job_retirement_tax_amount IS NOT DISTINCT FROM borrower_dim
            .monthly_job_retirement_tax_amount
        AND borrower_dim_incl_new_records.monthly_job_state_disability_insurance_amount IS NOT DISTINCT FROM borrower_dim
            .monthly_job_state_disability_insurance_amount
        AND borrower_dim_incl_new_records.monthly_job_state_tax_amount IS NOT DISTINCT FROM borrower_dim.monthly_job_state_tax_amount
        AND borrower_dim_incl_new_records.monthly_job_total_tax_amount IS NOT DISTINCT FROM borrower_dim.monthly_job_total_tax_amount
        AND borrower_dim_incl_new_records.name_suffix IS NOT DISTINCT FROM borrower_dim.name_suffix
        AND borrower_dim_incl_new_records.nickname IS NOT DISTINCT FROM borrower_dim.nickname
        AND borrower_dim_incl_new_records.note_endorser_explanation IS NOT DISTINCT FROM borrower_dim.note_endorser_explanation
        AND borrower_dim_incl_new_records.obligated_loan_foreclosure_explanation IS NOT DISTINCT FROM borrower_dim
            .obligated_loan_foreclosure_explanation
        AND borrower_dim_incl_new_records.office_phone IS NOT DISTINCT FROM borrower_dim.office_phone
        AND borrower_dim_incl_new_records.office_phone_extension IS NOT DISTINCT FROM borrower_dim.office_phone_extension
        AND borrower_dim_incl_new_records.other_race_national_origin_description IS NOT DISTINCT FROM borrower_dim
            .other_race_national_origin_description
        AND borrower_dim_incl_new_records.outstanding_judgments_explanation IS NOT DISTINCT FROM borrower_dim
            .outstanding_judgments_explanation
        AND borrower_dim_incl_new_records.party_to_lawsuit_explanation IS NOT DISTINCT FROM borrower_dim.party_to_lawsuit_explanation
        AND borrower_dim_incl_new_records.power_of_attorney_city IS NOT DISTINCT FROM borrower_dim.power_of_attorney_city
        AND borrower_dim_incl_new_records.power_of_attorney_company_name IS NOT DISTINCT FROM borrower_dim.power_of_attorney_company_name
        AND borrower_dim_incl_new_records.power_of_attorney_country IS NOT DISTINCT FROM borrower_dim.power_of_attorney_country
        AND borrower_dim_incl_new_records.power_of_attorney_country_code IS NOT DISTINCT FROM borrower_dim.power_of_attorney_country_code
        AND borrower_dim_incl_new_records.power_of_attorney_email IS NOT DISTINCT FROM borrower_dim.power_of_attorney_email
        AND borrower_dim_incl_new_records.power_of_attorney_fax IS NOT DISTINCT FROM borrower_dim.power_of_attorney_fax
        AND borrower_dim_incl_new_records.power_of_attorney_first_name IS NOT DISTINCT FROM borrower_dim.power_of_attorney_first_name
        AND borrower_dim_incl_new_records.power_of_attorney_last_name IS NOT DISTINCT FROM borrower_dim.power_of_attorney_last_name
        AND borrower_dim_incl_new_records.power_of_attorney_middle_name IS NOT DISTINCT FROM borrower_dim.power_of_attorney_middle_name
        AND borrower_dim_incl_new_records.power_of_attorney_mobile_phone IS NOT DISTINCT FROM borrower_dim.power_of_attorney_mobile_phone
        AND borrower_dim_incl_new_records.power_of_attorney_name_suffix IS NOT DISTINCT FROM borrower_dim.power_of_attorney_name_suffix
        AND borrower_dim_incl_new_records.power_of_attorney_office_phone IS NOT DISTINCT FROM borrower_dim.power_of_attorney_office_phone
        AND borrower_dim_incl_new_records.power_of_attorney_office_phone_extension IS NOT DISTINCT FROM borrower_dim
            .power_of_attorney_office_phone_extension
        AND borrower_dim_incl_new_records.power_of_attorney_postal_code IS NOT DISTINCT FROM borrower_dim.power_of_attorney_postal_code
        AND borrower_dim_incl_new_records.power_of_attorney_signing_capacity IS NOT DISTINCT FROM borrower_dim
            .power_of_attorney_signing_capacity
        AND borrower_dim_incl_new_records.power_of_attorney_state IS NOT DISTINCT FROM borrower_dim.power_of_attorney_state
        AND borrower_dim_incl_new_records.power_of_attorney_street1 IS NOT DISTINCT FROM borrower_dim.power_of_attorney_street1
        AND borrower_dim_incl_new_records.power_of_attorney_street2 IS NOT DISTINCT FROM borrower_dim.power_of_attorney_street2
        AND borrower_dim_incl_new_records.power_of_attorney_title IS NOT DISTINCT FROM borrower_dim.power_of_attorney_title
        AND borrower_dim_incl_new_records.preferred_first_name IS NOT DISTINCT FROM borrower_dim.preferred_first_name
        AND borrower_dim_incl_new_records.presently_delinquent_explanation IS NOT DISTINCT FROM borrower_dim
            .presently_delinquent_explanation
        AND borrower_dim_incl_new_records.prior_property_title IS NOT DISTINCT FROM borrower_dim.prior_property_title
        AND borrower_dim_incl_new_records.prior_property_title_code IS NOT DISTINCT FROM borrower_dim.prior_property_title_code
        AND borrower_dim_incl_new_records.prior_property_usage IS NOT DISTINCT FROM borrower_dim.prior_property_usage
        AND borrower_dim_incl_new_records.prior_property_usage_code IS NOT DISTINCT FROM borrower_dim.prior_property_usage_code
        AND borrower_dim_incl_new_records.property_foreclosure_explanation IS NOT DISTINCT FROM borrower_dim
            .property_foreclosure_explanation
        AND borrower_dim_incl_new_records.race_other_american_indian_or_alaska_native_description IS NOT DISTINCT FROM borrower_dim
            .race_other_american_indian_or_alaska_native_description
        AND borrower_dim_incl_new_records.race_other_asian_description IS NOT DISTINCT FROM borrower_dim.race_other_asian_description
        AND borrower_dim_incl_new_records.race_other_pacific_islander_description IS NOT DISTINCT FROM borrower_dim
            .race_other_pacific_islander_description
        AND borrower_dim_incl_new_records.relationship_to_primary_borrower IS NOT DISTINCT FROM borrower_dim
            .relationship_to_primary_borrower
        AND borrower_dim_incl_new_records.relationship_to_primary_borrower_code IS NOT DISTINCT FROM borrower_dim
            .relationship_to_primary_borrower_code
        AND borrower_dim_incl_new_records.relationship_to_seller IS NOT DISTINCT FROM borrower_dim.relationship_to_seller
        AND borrower_dim_incl_new_records.relationship_to_seller_code IS NOT DISTINCT FROM borrower_dim.relationship_to_seller_code
        AND borrower_dim_incl_new_records.tiny_id IS NOT DISTINCT FROM borrower_dim.tiny_id
        AND borrower_dim_incl_new_records.tiny_id_code IS NOT DISTINCT FROM borrower_dim.tiny_id_code
        AND borrower_dim_incl_new_records.trans_union_credit_score IS NOT DISTINCT FROM borrower_dim.trans_union_credit_score
        AND borrower_dim_incl_new_records.usda_annual_child_care_expenses IS NOT DISTINCT FROM borrower_dim.usda_annual_child_care_expenses
        AND borrower_dim_incl_new_records.usda_disability_expenses IS NOT DISTINCT FROM borrower_dim.usda_disability_expenses
        AND borrower_dim_incl_new_records.usda_income_from_assets IS NOT DISTINCT FROM borrower_dim.usda_income_from_assets
        AND borrower_dim_incl_new_records.usda_medical_expenses IS NOT DISTINCT FROM borrower_dim.usda_medical_expenses
        AND borrower_dim_incl_new_records.usda_moderate_income_limit IS NOT DISTINCT FROM borrower_dim.usda_moderate_income_limit
WHERE borrower_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'borrower_dim'
        );


-- interim_funder_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT interim_funder_dim_incl_new_records.data_source_integration_columns
    , interim_funder_dim_incl_new_records.data_source_integration_id
    , interim_funder_dim_incl_new_records.edw_created_datetime
    , interim_funder_dim_incl_new_records.edw_modified_datetime
    , interim_funder_dim_incl_new_records.data_source_modified_datetime
    , interim_funder_dim_incl_new_records.address_country
    , interim_funder_dim_incl_new_records.interim_funder_pid
    , interim_funder_dim_incl_new_records.name
    , interim_funder_dim_incl_new_records.contact_unparsed_name
    , interim_funder_dim_incl_new_records.address_street1
    , interim_funder_dim_incl_new_records.address_street2
    , interim_funder_dim_incl_new_records.address_city
    , interim_funder_dim_incl_new_records.address_state
    , interim_funder_dim_incl_new_records.address_postal_code
    , interim_funder_dim_incl_new_records.address_country_code
    , interim_funder_dim_incl_new_records.office_phone
    , interim_funder_dim_incl_new_records.office_phone_extension
    , interim_funder_dim_incl_new_records.email
    , interim_funder_dim_incl_new_records.fax
    , interim_funder_dim_incl_new_records.mers_org_id
    , interim_funder_dim_incl_new_records.remarks
    , interim_funder_dim_incl_new_records.from_date
    , interim_funder_dim_incl_new_records.through_date
    , interim_funder_dim_incl_new_records.remibursement_wire_credit_to_name
    , interim_funder_dim_incl_new_records.reimbursement_wire_attention_unparsed_name
    , interim_funder_dim_incl_new_records.reimbursement_wire_authorized_signer_unparsed_name
    , interim_funder_dim_incl_new_records.return_wire_credit_to_name
    , interim_funder_dim_incl_new_records.return_wire_authorized_signer_unparsed_name
    , interim_funder_dim_incl_new_records.fnm_payee_id
    , interim_funder_dim_incl_new_records.mers_registration_code
    , interim_funder_dim_incl_new_records.fnm_warehouse_lender_id
    , interim_funder_dim_incl_new_records.fre_warehouse_lender_id
    , interim_funder_dim_incl_new_records.id
    , interim_funder_dim_incl_new_records.return_wire_attention_unparsed_name
    , interim_funder_dim_incl_new_records.mers_registration

FROM (
SELECT ''interim_funder_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.if_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        interim_funder.*
    FROM history_octane.interim_funder
        LEFT JOIN history_octane.interim_funder AS history_records ON interim_funder.if_pid = history_records.if_pid
            AND interim_funder.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.if_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t309 ON primary_table.if_company_address_country = t309.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<interim_funder_mers_registration_type_partial_load_condition>> as include_record,
            interim_funder_mers_registration_type.*
            FROM history_octane.interim_funder_mers_registration_type
                LEFT JOIN history_octane.interim_funder_mers_registration_type AS history_records ON interim_funder_mers_registration_type.code = history_records.code
                AND interim_funder_mers_registration_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t310 ON primary_table.if_interim_funder_mers_registration_type = t310.code
 WHERE
    GREATEST(primary_table.include_record, t309.include_record, t310.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS interim_funder_dim_incl_new_records
    LEFT JOIN star_loan.interim_funder_dim ON interim_funder_dim_incl_new_records.data_source_integration_id =
                                          interim_funder_dim.data_source_integration_id
        AND interim_funder_dim_incl_new_records.address_city IS NOT DISTINCT FROM interim_funder_dim.address_city
        AND interim_funder_dim_incl_new_records.address_country IS NOT DISTINCT FROM interim_funder_dim.address_country
        AND interim_funder_dim_incl_new_records.address_country_code IS NOT DISTINCT FROM interim_funder_dim.address_country_code
        AND interim_funder_dim_incl_new_records.address_postal_code IS NOT DISTINCT FROM interim_funder_dim.address_postal_code
        AND interim_funder_dim_incl_new_records.address_state IS NOT DISTINCT FROM interim_funder_dim.address_state
        AND interim_funder_dim_incl_new_records.address_street1 IS NOT DISTINCT FROM interim_funder_dim.address_street1
        AND interim_funder_dim_incl_new_records.address_street2 IS NOT DISTINCT FROM interim_funder_dim.address_street2
        AND interim_funder_dim_incl_new_records.contact_unparsed_name IS NOT DISTINCT FROM interim_funder_dim.contact_unparsed_name
        AND interim_funder_dim_incl_new_records.email IS NOT DISTINCT FROM interim_funder_dim.email
        AND interim_funder_dim_incl_new_records.fax IS NOT DISTINCT FROM interim_funder_dim.fax
        AND interim_funder_dim_incl_new_records.fnm_payee_id IS NOT DISTINCT FROM interim_funder_dim.fnm_payee_id
        AND interim_funder_dim_incl_new_records.fnm_warehouse_lender_id IS NOT DISTINCT FROM interim_funder_dim.fnm_warehouse_lender_id
        AND interim_funder_dim_incl_new_records.fre_warehouse_lender_id IS NOT DISTINCT FROM interim_funder_dim.fre_warehouse_lender_id
        AND interim_funder_dim_incl_new_records.id IS NOT DISTINCT FROM interim_funder_dim.id
        AND interim_funder_dim_incl_new_records.mers_org_id IS NOT DISTINCT FROM interim_funder_dim.mers_org_id
        AND interim_funder_dim_incl_new_records.mers_registration IS NOT DISTINCT FROM interim_funder_dim.mers_registration
        AND interim_funder_dim_incl_new_records.mers_registration_code IS NOT DISTINCT FROM interim_funder_dim.mers_registration_code
        AND interim_funder_dim_incl_new_records.name IS NOT DISTINCT FROM interim_funder_dim.name
        AND interim_funder_dim_incl_new_records.office_phone IS NOT DISTINCT FROM interim_funder_dim.office_phone
        AND interim_funder_dim_incl_new_records.office_phone_extension IS NOT DISTINCT FROM interim_funder_dim.office_phone_extension
        AND interim_funder_dim_incl_new_records.reimbursement_wire_attention_unparsed_name IS NOT DISTINCT FROM interim_funder_dim
            .reimbursement_wire_attention_unparsed_name
        AND interim_funder_dim_incl_new_records.reimbursement_wire_authorized_signer_unparsed_name IS NOT DISTINCT FROM
            interim_funder_dim.reimbursement_wire_authorized_signer_unparsed_name
        AND interim_funder_dim_incl_new_records.remarks IS NOT DISTINCT FROM interim_funder_dim.remarks
        AND interim_funder_dim_incl_new_records.remibursement_wire_credit_to_name IS NOT DISTINCT FROM interim_funder_dim
            .remibursement_wire_credit_to_name
        AND interim_funder_dim_incl_new_records.return_wire_attention_unparsed_name IS NOT DISTINCT FROM interim_funder_dim
            .return_wire_attention_unparsed_name
        AND interim_funder_dim_incl_new_records.return_wire_authorized_signer_unparsed_name IS NOT DISTINCT FROM interim_funder_dim
            .return_wire_authorized_signer_unparsed_name
        AND interim_funder_dim_incl_new_records.return_wire_credit_to_name IS NOT DISTINCT FROM interim_funder_dim
            .return_wire_credit_to_name
        AND interim_funder_dim_incl_new_records.from_date IS NOT DISTINCT FROM interim_funder_dim.from_date
        AND interim_funder_dim_incl_new_records.through_date IS NOT DISTINCT FROM interim_funder_dim.through_date
WHERE interim_funder_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'interim_funder_dim'
        );


-- investor_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT investor_dim_incl_new_records.data_source_integration_columns
    , investor_dim_incl_new_records.data_source_integration_id
    , investor_dim_incl_new_records.edw_created_datetime
    , investor_dim_incl_new_records.edw_modified_datetime
    , investor_dim_incl_new_records.data_source_modified_datetime
    , investor_dim_incl_new_records.beneficiary_country
    , investor_dim_incl_new_records.file_delivery_address_country
    , investor_dim_incl_new_records.investor_country
    , investor_dim_incl_new_records.loss_payee_country
    , investor_dim_incl_new_records.servicer_address_country
    , investor_dim_incl_new_records.sub_servicer_address_country
    , investor_dim_incl_new_records.when_recorded_mail_to_country
    , investor_dim_incl_new_records.fnm_investor_remittance
    , investor_dim_incl_new_records.fnm_mbs_loan_default_loss_party
    , investor_dim_incl_new_records.fnm_mbs_reo_marketing_party
    , investor_dim_incl_new_records.secondary_financing_source
    , investor_dim_incl_new_records.investor_country_code
    , investor_dim_incl_new_records.investor_postal_code
    , investor_dim_incl_new_records.investor_state
    , investor_dim_incl_new_records.investor_street1
    , investor_dim_incl_new_records.investor_street2
    , investor_dim_incl_new_records.secondary_financing_source_code
    , investor_dim_incl_new_records.ein
    , investor_dim_incl_new_records.loss_payee_state
    , investor_dim_incl_new_records.loss_payee_postal_code
    , investor_dim_incl_new_records.when_recorded_mail_to_country_code
    , investor_dim_incl_new_records.when_recorded_mail_to_postal_code
    , investor_dim_incl_new_records.when_recorded_mail_to_state
    , investor_dim_incl_new_records.when_recorded_mail_to_street1
    , investor_dim_incl_new_records.when_recorded_mail_to_street2
    , investor_dim_incl_new_records.servicer_name
    , investor_dim_incl_new_records.servicer_address_street1
    , investor_dim_incl_new_records.servicer_address_street2
    , investor_dim_incl_new_records.servicer_address_city
    , investor_dim_incl_new_records.servicer_address_state
    , investor_dim_incl_new_records.servicer_address_postal_code
    , investor_dim_incl_new_records.servicer_address_country_code
    , investor_dim_incl_new_records.sub_servicer_name
    , investor_dim_incl_new_records.sub_servicer_address_street1
    , investor_dim_incl_new_records.sub_servicer_address_street2
    , investor_dim_incl_new_records.sub_servicer_address_city
    , investor_dim_incl_new_records.sub_servicer_address_state
    , investor_dim_incl_new_records.sub_servicer_address_postal_code
    , investor_dim_incl_new_records.sub_servicer_address_country_code
    , investor_dim_incl_new_records.sub_servicer_mers_org_id
    , investor_dim_incl_new_records.file_delivery_name
    , investor_dim_incl_new_records.file_delivery_address_street1
    , investor_dim_incl_new_records.file_delivery_address_street2
    , investor_dim_incl_new_records.file_delivery_address_city
    , investor_dim_incl_new_records.file_delivery_address_state
    , investor_dim_incl_new_records.file_delivery_address_postal_code
    , investor_dim_incl_new_records.file_delivery_address_country_code
    , investor_dim_incl_new_records.initial_beneficiary_candidate_flag
    , investor_dim_incl_new_records.initial_servicer_candidate_flag
    , investor_dim_incl_new_records.mers_org_member
    , investor_dim_incl_new_records.mers_org_id
    , investor_dim_incl_new_records.allonge_transfer_to_name
    , investor_dim_incl_new_records.lock_expiration_delivery_subtrahend_days
    , investor_dim_incl_new_records.loss_payee_country_code
    , investor_dim_incl_new_records.loss_payee_city
    , investor_dim_incl_new_records.loss_payee_name
    , investor_dim_incl_new_records.investor_pid
    , investor_dim_incl_new_records.investor_id
    , investor_dim_incl_new_records.website_url
    , investor_dim_incl_new_records.investor_name
    , investor_dim_incl_new_records.investor_city
    , investor_dim_incl_new_records.when_recorded_mail_to_city
    , investor_dim_incl_new_records.maximum_lock_extensions_allowed
    , investor_dim_incl_new_records.maximum_lock_extension_days_allowed
    , investor_dim_incl_new_records.mortech_investor_id
    , investor_dim_incl_new_records.fnma_servicer_id
    , investor_dim_incl_new_records.loan_file_delivery_method_code
    , investor_dim_incl_new_records.mbs_investor_flag
    , investor_dim_incl_new_records.investor_hmda_purchaser_of_loan_code
    , investor_dim_incl_new_records.investor_lock_disable_time
    , investor_dim_incl_new_records.allows_weekend_holiday_locks_flag
    , investor_dim_incl_new_records.nmls_id
    , investor_dim_incl_new_records.nmls_id_applicable
    , investor_dim_incl_new_records.fnm_investor_remittance_code
    , investor_dim_incl_new_records.fnm_mbs_investor_remittance_day_of_month
    , investor_dim_incl_new_records.fnm_mbs_loan_default_loss_party_code
    , investor_dim_incl_new_records.fnm_mbs_reo_marketing_party_code
    , investor_dim_incl_new_records.offers_secondary_financing_flag
    , investor_dim_incl_new_records.beneficiary_street2
    , investor_dim_incl_new_records.beneficiary_street1
    , investor_dim_incl_new_records.beneficiary_state
    , investor_dim_incl_new_records.beneficiary_postal_code
    , investor_dim_incl_new_records.beneficiary_country_code
    , investor_dim_incl_new_records.beneficiary_city
    , investor_dim_incl_new_records.loss_payee_street1
    , investor_dim_incl_new_records.loss_payee_street2
    , investor_dim_incl_new_records.beneficiary_name
    , investor_dim_incl_new_records.loss_payee_assignee_name
    , investor_dim_incl_new_records.when_recorded_mail_to_name
    , investor_dim_incl_new_records.investor_hmda_purchaser_of_loan
    , investor_dim_incl_new_records.loan_file_delivery_method
FROM (
SELECT ''investor_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.i_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        investor.*
    FROM history_octane.investor
        LEFT JOIN history_octane.investor AS history_records ON investor.i_pid = history_records.i_pid
            AND investor.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.i_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t318 ON primary_table.i_beneficiary_country = t318.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t319 ON primary_table.i_file_delivery_address_country = t319.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t323 ON primary_table.i_investor_country = t323.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t326 ON primary_table.i_loss_payee_country = t326.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t330 ON primary_table.i_servicer_address_country = t330.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t331 ON primary_table.i_sub_servicer_address_country = t331.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t332 ON primary_table.i_when_recorded_mail_to_country = t332.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_investor_remittance_type_partial_load_condition>> as include_record,
            fnm_investor_remittance_type.*
            FROM history_octane.fnm_investor_remittance_type
                LEFT JOIN history_octane.fnm_investor_remittance_type AS history_records ON fnm_investor_remittance_type.code = history_records.code
                AND fnm_investor_remittance_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t320 ON primary_table.i_fnm_investor_remittance_type = t320.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_mbs_loan_default_loss_party_type_partial_load_condition>> as include_record,
            fnm_mbs_loan_default_loss_party_type.*
            FROM history_octane.fnm_mbs_loan_default_loss_party_type
                LEFT JOIN history_octane.fnm_mbs_loan_default_loss_party_type AS history_records ON fnm_mbs_loan_default_loss_party_type.code = history_records.code
                AND fnm_mbs_loan_default_loss_party_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t321 ON primary_table.i_fnm_mbs_loan_default_loss_party_type = t321.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_mbs_reo_marketing_party_type_partial_load_condition>> as include_record,
            fnm_mbs_reo_marketing_party_type.*
            FROM history_octane.fnm_mbs_reo_marketing_party_type
                LEFT JOIN history_octane.fnm_mbs_reo_marketing_party_type AS history_records ON fnm_mbs_reo_marketing_party_type.code = history_records.code
                AND fnm_mbs_reo_marketing_party_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t322 ON primary_table.i_fnm_mbs_reo_marketing_party_type = t322.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<gift_funds_type_partial_load_condition>> as include_record,
            gift_funds_type.*
            FROM history_octane.gift_funds_type
                LEFT JOIN history_octane.gift_funds_type AS history_records ON gift_funds_type.code = history_records.code
                AND gift_funds_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t329 ON primary_table.i_secondary_financing_source_type = t329.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<investor_hmda_purchaser_of_loan_type_partial_load_condition>> as include_record,
            investor_hmda_purchaser_of_loan_type.*
            FROM history_octane.investor_hmda_purchaser_of_loan_type
                LEFT JOIN history_octane.investor_hmda_purchaser_of_loan_type AS history_records ON investor_hmda_purchaser_of_loan_type.code = history_records.code
                AND investor_hmda_purchaser_of_loan_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t324 ON primary_table.i_investor_hmda_purchaser_of_loan_type = t324.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<loan_file_delivery_method_type_partial_load_condition>> as include_record,
            loan_file_delivery_method_type.*
            FROM history_octane.loan_file_delivery_method_type
                LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records ON loan_file_delivery_method_type.code = history_records.code
                AND loan_file_delivery_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t325 ON primary_table.i_loan_file_delivery_method_type = t325.code
 WHERE
    GREATEST(primary_table.include_record, t318.include_record, t319.include_record, t323.include_record, t326.include_record, t330.include_record, t331.include_record, t332.include_record, t320.include_record, t321.include_record, t322.include_record, t329.include_record, t324.include_record, t325.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS investor_dim_incl_new_records
    LEFT JOIN star_loan.investor_dim ON investor_dim_incl_new_records.data_source_integration_id =
                              investor_dim.data_source_integration_id
        AND investor_dim_incl_new_records.allonge_transfer_to_name IS NOT DISTINCT FROM investor_dim.allonge_transfer_to_name
        AND investor_dim_incl_new_records.allows_weekend_holiday_locks_flag IS NOT DISTINCT FROM investor_dim.allows_weekend_holiday_locks_flag
        AND investor_dim_incl_new_records.beneficiary_city IS NOT DISTINCT FROM investor_dim.beneficiary_city
        AND investor_dim_incl_new_records.beneficiary_country IS NOT DISTINCT FROM investor_dim.beneficiary_country
        AND investor_dim_incl_new_records.beneficiary_country_code IS NOT DISTINCT FROM investor_dim.beneficiary_country_code
        AND investor_dim_incl_new_records.beneficiary_name IS NOT DISTINCT FROM investor_dim.beneficiary_name
        AND investor_dim_incl_new_records.beneficiary_postal_code IS NOT DISTINCT FROM investor_dim.beneficiary_postal_code
        AND investor_dim_incl_new_records.beneficiary_state IS NOT DISTINCT FROM investor_dim.beneficiary_state
        AND investor_dim_incl_new_records.beneficiary_street1 IS NOT DISTINCT FROM investor_dim.beneficiary_street1
        AND investor_dim_incl_new_records.beneficiary_street2 IS NOT DISTINCT FROM investor_dim.beneficiary_street2
        AND investor_dim_incl_new_records.ein IS NOT DISTINCT FROM investor_dim.ein
        AND investor_dim_incl_new_records.file_delivery_address_city IS NOT DISTINCT FROM investor_dim.file_delivery_address_city
        AND investor_dim_incl_new_records.file_delivery_address_country IS NOT DISTINCT FROM investor_dim.file_delivery_address_country
        AND investor_dim_incl_new_records.file_delivery_address_country_code IS NOT DISTINCT FROM investor_dim.file_delivery_address_country_code
        AND investor_dim_incl_new_records.file_delivery_address_postal_code IS NOT DISTINCT FROM investor_dim.file_delivery_address_postal_code
        AND investor_dim_incl_new_records.file_delivery_address_state IS NOT DISTINCT FROM investor_dim.file_delivery_address_state
        AND investor_dim_incl_new_records.file_delivery_address_street1 IS NOT DISTINCT FROM investor_dim.file_delivery_address_street1
        AND investor_dim_incl_new_records.file_delivery_address_street2 IS NOT DISTINCT FROM investor_dim.file_delivery_address_street2
        AND investor_dim_incl_new_records.file_delivery_name IS NOT DISTINCT FROM investor_dim.file_delivery_name
        AND investor_dim_incl_new_records.fnm_investor_remittance IS NOT DISTINCT FROM investor_dim.fnm_investor_remittance
        AND investor_dim_incl_new_records.fnm_investor_remittance_code IS NOT DISTINCT FROM investor_dim.fnm_investor_remittance_code
        AND investor_dim_incl_new_records.fnm_mbs_investor_remittance_day_of_month IS NOT DISTINCT FROM investor_dim.fnm_mbs_investor_remittance_day_of_month
        AND investor_dim_incl_new_records.fnm_mbs_loan_default_loss_party IS NOT DISTINCT FROM investor_dim.fnm_mbs_loan_default_loss_party
        AND investor_dim_incl_new_records.fnm_mbs_loan_default_loss_party_code IS NOT DISTINCT FROM investor_dim.fnm_mbs_loan_default_loss_party_code
        AND investor_dim_incl_new_records.fnm_mbs_reo_marketing_party IS NOT DISTINCT FROM investor_dim.fnm_mbs_reo_marketing_party
        AND investor_dim_incl_new_records.fnm_mbs_reo_marketing_party_code IS NOT DISTINCT FROM investor_dim.fnm_mbs_reo_marketing_party_code
        AND investor_dim_incl_new_records.fnma_servicer_id IS NOT DISTINCT FROM investor_dim.fnma_servicer_id
        AND investor_dim_incl_new_records.investor_city IS NOT DISTINCT FROM investor_dim.investor_city
        AND investor_dim_incl_new_records.investor_country IS NOT DISTINCT FROM investor_dim.investor_country
        AND investor_dim_incl_new_records.investor_country_code IS NOT DISTINCT FROM investor_dim.investor_country_code
        AND investor_dim_incl_new_records.investor_hmda_purchaser_of_loan IS NOT DISTINCT FROM investor_dim.investor_hmda_purchaser_of_loan
        AND investor_dim_incl_new_records.investor_hmda_purchaser_of_loan_code IS NOT DISTINCT FROM investor_dim.investor_hmda_purchaser_of_loan_code
        AND investor_dim_incl_new_records.investor_id IS NOT DISTINCT FROM investor_dim.investor_id
        AND investor_dim_incl_new_records.investor_lock_disable_time IS NOT DISTINCT FROM investor_dim.investor_lock_disable_time
        AND investor_dim_incl_new_records.investor_name IS NOT DISTINCT FROM investor_dim.investor_name
        AND investor_dim_incl_new_records.investor_postal_code IS NOT DISTINCT FROM investor_dim.investor_postal_code
        AND investor_dim_incl_new_records.investor_state IS NOT DISTINCT FROM investor_dim.investor_state
        AND investor_dim_incl_new_records.investor_street1 IS NOT DISTINCT FROM investor_dim.investor_street1
        AND investor_dim_incl_new_records.investor_street2 IS NOT DISTINCT FROM investor_dim.investor_street2
        AND investor_dim_incl_new_records.initial_beneficiary_candidate_flag IS NOT DISTINCT FROM investor_dim.initial_beneficiary_candidate_flag
        AND investor_dim_incl_new_records.initial_servicer_candidate_flag IS NOT DISTINCT FROM investor_dim.initial_servicer_candidate_flag
        AND investor_dim_incl_new_records.mbs_investor_flag IS NOT DISTINCT FROM investor_dim.mbs_investor_flag
        AND investor_dim_incl_new_records.loan_file_delivery_method IS NOT DISTINCT FROM investor_dim.loan_file_delivery_method
        AND investor_dim_incl_new_records.loan_file_delivery_method_code IS NOT DISTINCT FROM investor_dim.loan_file_delivery_method_code
        AND investor_dim_incl_new_records.lock_expiration_delivery_subtrahend_days IS NOT DISTINCT FROM investor_dim.lock_expiration_delivery_subtrahend_days
        AND investor_dim_incl_new_records.loss_payee_assignee_name IS NOT DISTINCT FROM investor_dim.loss_payee_assignee_name
        AND investor_dim_incl_new_records.loss_payee_city IS NOT DISTINCT FROM investor_dim.loss_payee_city
        AND investor_dim_incl_new_records.loss_payee_country IS NOT DISTINCT FROM investor_dim.loss_payee_country
        AND investor_dim_incl_new_records.loss_payee_country_code IS NOT DISTINCT FROM investor_dim.loss_payee_country_code
        AND investor_dim_incl_new_records.loss_payee_name IS NOT DISTINCT FROM investor_dim.loss_payee_name
        AND investor_dim_incl_new_records.loss_payee_postal_code IS NOT DISTINCT FROM investor_dim.loss_payee_postal_code
        AND investor_dim_incl_new_records.loss_payee_state IS NOT DISTINCT FROM investor_dim.loss_payee_state
        AND investor_dim_incl_new_records.loss_payee_street1 IS NOT DISTINCT FROM investor_dim.loss_payee_street1
        AND investor_dim_incl_new_records.loss_payee_street2 IS NOT DISTINCT FROM investor_dim.loss_payee_street2
        AND investor_dim_incl_new_records.maximum_lock_extension_days_allowed IS NOT DISTINCT FROM investor_dim.maximum_lock_extension_days_allowed
        AND investor_dim_incl_new_records.maximum_lock_extensions_allowed IS NOT DISTINCT FROM investor_dim.maximum_lock_extensions_allowed
        AND investor_dim_incl_new_records.mers_org_id IS NOT DISTINCT FROM investor_dim.mers_org_id
        AND investor_dim_incl_new_records.mers_org_member IS NOT DISTINCT FROM investor_dim.mers_org_member
        AND investor_dim_incl_new_records.mortech_investor_id IS NOT DISTINCT FROM investor_dim.mortech_investor_id
        AND investor_dim_incl_new_records.nmls_id IS NOT DISTINCT FROM investor_dim.nmls_id
        AND investor_dim_incl_new_records.nmls_id_applicable IS NOT DISTINCT FROM investor_dim.nmls_id_applicable
        AND investor_dim_incl_new_records.offers_secondary_financing_flag IS NOT DISTINCT FROM investor_dim.offers_secondary_financing_flag
        AND investor_dim_incl_new_records.secondary_financing_source IS NOT DISTINCT FROM investor_dim.secondary_financing_source
        AND investor_dim_incl_new_records.secondary_financing_source_code IS NOT DISTINCT FROM investor_dim.secondary_financing_source_code
        AND investor_dim_incl_new_records.servicer_address_city IS NOT DISTINCT FROM investor_dim.servicer_address_city
        AND investor_dim_incl_new_records.servicer_address_country IS NOT DISTINCT FROM investor_dim.servicer_address_country
        AND investor_dim_incl_new_records.servicer_address_country_code IS NOT DISTINCT FROM investor_dim.servicer_address_country_code
        AND investor_dim_incl_new_records.servicer_address_postal_code IS NOT DISTINCT FROM investor_dim.servicer_address_postal_code
        AND investor_dim_incl_new_records.servicer_address_state IS NOT DISTINCT FROM investor_dim.servicer_address_state
        AND investor_dim_incl_new_records.servicer_address_street1 IS NOT DISTINCT FROM investor_dim.servicer_address_street1
        AND investor_dim_incl_new_records.servicer_address_street2 IS NOT DISTINCT FROM investor_dim.servicer_address_street2
        AND investor_dim_incl_new_records.servicer_name IS NOT DISTINCT FROM investor_dim.servicer_name
        AND investor_dim_incl_new_records.sub_servicer_address_city IS NOT DISTINCT FROM investor_dim.sub_servicer_address_city
        AND investor_dim_incl_new_records.sub_servicer_address_country IS NOT DISTINCT FROM investor_dim.sub_servicer_address_country
        AND investor_dim_incl_new_records.sub_servicer_address_country_code IS NOT DISTINCT FROM investor_dim.sub_servicer_address_country_code
        AND investor_dim_incl_new_records.sub_servicer_address_postal_code IS NOT DISTINCT FROM investor_dim.sub_servicer_address_postal_code
        AND investor_dim_incl_new_records.sub_servicer_address_state IS NOT DISTINCT FROM investor_dim.sub_servicer_address_state
        AND investor_dim_incl_new_records.sub_servicer_address_street1 IS NOT DISTINCT FROM investor_dim.sub_servicer_address_street1
        AND investor_dim_incl_new_records.sub_servicer_address_street2 IS NOT DISTINCT FROM investor_dim.sub_servicer_address_street2
        AND investor_dim_incl_new_records.sub_servicer_mers_org_id IS NOT DISTINCT FROM investor_dim.sub_servicer_mers_org_id
        AND investor_dim_incl_new_records.sub_servicer_name IS NOT DISTINCT FROM investor_dim.sub_servicer_name
        AND investor_dim_incl_new_records.website_url IS NOT DISTINCT FROM investor_dim.website_url
        AND investor_dim_incl_new_records.when_recorded_mail_to_city IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_city
        AND investor_dim_incl_new_records.when_recorded_mail_to_country IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_country
        AND investor_dim_incl_new_records.when_recorded_mail_to_country_code IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_country_code
        AND investor_dim_incl_new_records.when_recorded_mail_to_name IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_name
        AND investor_dim_incl_new_records.when_recorded_mail_to_postal_code IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_postal_code
        AND investor_dim_incl_new_records.when_recorded_mail_to_state IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_state
        AND investor_dim_incl_new_records.when_recorded_mail_to_street1 IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_street1
        AND investor_dim_incl_new_records.when_recorded_mail_to_street2 IS NOT DISTINCT FROM investor_dim.when_recorded_mail_to_street2
WHERE investor_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'investor_dim'
        );


-- lender_user_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT lender_user_dim_incl_new_records.data_source_integration_columns
     , lender_user_dim_incl_new_records.data_source_integration_id
     , lender_user_dim_incl_new_records.edw_created_datetime
     , lender_user_dim_incl_new_records.edw_modified_datetime
     , lender_user_dim_incl_new_records.data_source_modified_datetime
     , lender_user_dim_incl_new_records.country
     , lender_user_dim_incl_new_records.default_credit_bureau
     , lender_user_dim_incl_new_records.username
     , lender_user_dim_incl_new_records.nmls_loan_originator_id
     , lender_user_dim_incl_new_records.fha_chums_id
     , lender_user_dim_incl_new_records.va_agent_id
     , lender_user_dim_incl_new_records.search_text
     , lender_user_dim_incl_new_records.company_user_id
     , lender_user_dim_incl_new_records.force_password_change_flag
     , lender_user_dim_incl_new_records.last_password_change_datetime
     , lender_user_dim_incl_new_records.allow_external_ip_flag
     , lender_user_dim_incl_new_records.total_workload_cap
     , lender_user_dim_incl_new_records.schedule_once_booking_page_id
     , lender_user_dim_incl_new_records.esign_only_flag
     , lender_user_dim_incl_new_records.work_step_start_notices_enabled_flag
     , lender_user_dim_incl_new_records.smart_app_enabled_flag
     , lender_user_dim_incl_new_records.default_credit_bureau_code
     , lender_user_dim_incl_new_records.originator_id
     , lender_user_dim_incl_new_records.name_qualifier
     , lender_user_dim_incl_new_records.training_mode_flag
     , lender_user_dim_incl_new_records.about_me
     , lender_user_dim_incl_new_records.type_code
     , lender_user_dim_incl_new_records.hire_date
     , lender_user_dim_incl_new_records.nickname
     , lender_user_dim_incl_new_records.preferred_first_name
     , lender_user_dim_incl_new_records.hub_directory_flag
     , lender_user_dim_incl_new_records.lender_user_pid
     , lender_user_dim_incl_new_records.account_owner_flag
     , lender_user_dim_incl_new_records.create_date
     , lender_user_dim_incl_new_records.first_name
     , lender_user_dim_incl_new_records.last_name
     , lender_user_dim_incl_new_records.middle_name
     , lender_user_dim_incl_new_records.name_suffix
     , lender_user_dim_incl_new_records.company_name
     , lender_user_dim_incl_new_records.title
     , lender_user_dim_incl_new_records.office_phone
     , lender_user_dim_incl_new_records.office_phone_extension
     , lender_user_dim_incl_new_records.email
     , lender_user_dim_incl_new_records.fax
     , lender_user_dim_incl_new_records.city
     , lender_user_dim_incl_new_records.country_code
     , lender_user_dim_incl_new_records.postal_code
     , lender_user_dim_incl_new_records.state
     , lender_user_dim_incl_new_records.street1
     , lender_user_dim_incl_new_records.street2
     , lender_user_dim_incl_new_records.office_phone_use_branch_flag
     , lender_user_dim_incl_new_records.fax_use_branch_flag
     , lender_user_dim_incl_new_records.address_use_branch_flag
     , lender_user_dim_incl_new_records.start_date
     , lender_user_dim_incl_new_records.through_date
     , lender_user_dim_incl_new_records.time_zone_code
     , lender_user_dim_incl_new_records.unparsed_name
     , lender_user_dim_incl_new_records.status_code
     , lender_user_dim_incl_new_records.status
     , lender_user_dim_incl_new_records.type
     , lender_user_dim_incl_new_records.time_zone
FROM (
       SELECT ''lender_user_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.lu_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        lender_user.*
    FROM history_octane.lender_user
        LEFT JOIN history_octane.lender_user AS history_records ON lender_user.lu_pid = history_records.lu_pid
            AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t454 ON primary_table.lu_country = t454.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_bureau_type_partial_load_condition>> as include_record,
            credit_bureau_type.*
            FROM history_octane.credit_bureau_type
                LEFT JOIN history_octane.credit_bureau_type AS history_records ON credit_bureau_type.code = history_records.code
                AND credit_bureau_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t455 ON primary_table.lu_default_credit_bureau_type = t455.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_status_type_partial_load_condition>> as include_record,
            lender_user_status_type.*
            FROM history_octane.lender_user_status_type
                LEFT JOIN history_octane.lender_user_status_type AS history_records ON lender_user_status_type.code = history_records.code
                AND lender_user_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t456 ON primary_table.lu_lender_user_status_type = t456.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_type_partial_load_condition>> as include_record,
            lender_user_type.*
            FROM history_octane.lender_user_type
                LEFT JOIN history_octane.lender_user_type AS history_records ON lender_user_type.code = history_records.code
                AND lender_user_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t457 ON primary_table.lu_lender_user_type = t457.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<time_zone_type_partial_load_condition>> as include_record,
            time_zone_type.*
            FROM history_octane.time_zone_type
                LEFT JOIN history_octane.time_zone_type AS history_records ON time_zone_type.code = history_records.code
                AND time_zone_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t458 ON primary_table.lu_time_zone = t458.code
 WHERE
    GREATEST(primary_table.include_record, t454.include_record, t455.include_record, t456.include_record, t457.include_record, t458.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS lender_user_dim_incl_new_records
    LEFT JOIN star_loan.lender_user_dim ON lender_user_dim_incl_new_records.data_source_integration_id =
                                           lender_user_dim.data_source_integration_id
        AND lender_user_dim_incl_new_records.create_date IS NOT DISTINCT FROM lender_user_dim.create_date
        AND lender_user_dim_incl_new_records.about_me IS NOT DISTINCT FROM lender_user_dim.about_me
        AND lender_user_dim_incl_new_records.city IS NOT DISTINCT FROM lender_user_dim.city
        AND lender_user_dim_incl_new_records.company_name IS NOT DISTINCT FROM lender_user_dim.company_name
        AND lender_user_dim_incl_new_records.company_user_id IS NOT DISTINCT FROM lender_user_dim.company_user_id
        AND lender_user_dim_incl_new_records.country IS NOT DISTINCT FROM lender_user_dim.country
        AND lender_user_dim_incl_new_records.country_code IS NOT DISTINCT FROM lender_user_dim.country_code
        AND lender_user_dim_incl_new_records.default_credit_bureau IS NOT DISTINCT FROM lender_user_dim.default_credit_bureau
        AND lender_user_dim_incl_new_records.default_credit_bureau_code IS NOT DISTINCT FROM lender_user_dim.default_credit_bureau_code
        AND lender_user_dim_incl_new_records.email IS NOT DISTINCT FROM lender_user_dim.email
        AND lender_user_dim_incl_new_records.fax IS NOT DISTINCT FROM lender_user_dim.fax
        AND lender_user_dim_incl_new_records.fha_chums_id IS NOT DISTINCT FROM lender_user_dim.fha_chums_id
        AND lender_user_dim_incl_new_records.first_name IS NOT DISTINCT FROM lender_user_dim.first_name
        AND lender_user_dim_incl_new_records.hire_date IS NOT DISTINCT FROM lender_user_dim.hire_date
        AND lender_user_dim_incl_new_records.account_owner_flag IS NOT DISTINCT FROM lender_user_dim.account_owner_flag
        AND lender_user_dim_incl_new_records.address_use_branch_flag IS NOT DISTINCT FROM lender_user_dim.address_use_branch_flag
        AND lender_user_dim_incl_new_records.allow_external_ip_flag IS NOT DISTINCT FROM lender_user_dim.allow_external_ip_flag
        AND lender_user_dim_incl_new_records.esign_only_flag IS NOT DISTINCT FROM lender_user_dim.esign_only_flag
        AND lender_user_dim_incl_new_records.fax_use_branch_flag IS NOT DISTINCT FROM lender_user_dim.fax_use_branch_flag
        AND lender_user_dim_incl_new_records.force_password_change_flag IS NOT DISTINCT FROM lender_user_dim.force_password_change_flag
        AND lender_user_dim_incl_new_records.hub_directory_flag IS NOT DISTINCT FROM lender_user_dim.hub_directory_flag
        AND lender_user_dim_incl_new_records.office_phone_use_branch_flag IS NOT DISTINCT FROM lender_user_dim.office_phone_use_branch_flag
        AND lender_user_dim_incl_new_records.smart_app_enabled_flag IS NOT DISTINCT FROM lender_user_dim.smart_app_enabled_flag
        AND lender_user_dim_incl_new_records.training_mode_flag IS NOT DISTINCT FROM lender_user_dim.training_mode_flag
        AND lender_user_dim_incl_new_records.work_step_start_notices_enabled_flag IS NOT DISTINCT FROM lender_user_dim.work_step_start_notices_enabled_flag
        AND lender_user_dim_incl_new_records.last_name IS NOT DISTINCT FROM lender_user_dim.last_name
        AND lender_user_dim_incl_new_records.last_password_change_datetime IS NOT DISTINCT FROM lender_user_dim.last_password_change_datetime
        AND lender_user_dim_incl_new_records.middle_name IS NOT DISTINCT FROM lender_user_dim.middle_name
        AND lender_user_dim_incl_new_records.name_qualifier IS NOT DISTINCT FROM lender_user_dim.name_qualifier
        AND lender_user_dim_incl_new_records.name_suffix IS NOT DISTINCT FROM lender_user_dim.name_suffix
        AND lender_user_dim_incl_new_records.nickname IS NOT DISTINCT FROM lender_user_dim.nickname
        AND lender_user_dim_incl_new_records.nmls_loan_originator_id IS NOT DISTINCT FROM lender_user_dim.nmls_loan_originator_id
        AND lender_user_dim_incl_new_records.office_phone IS NOT DISTINCT FROM lender_user_dim.office_phone
        AND lender_user_dim_incl_new_records.office_phone_extension IS NOT DISTINCT FROM lender_user_dim.office_phone_extension
        AND lender_user_dim_incl_new_records.originator_id IS NOT DISTINCT FROM lender_user_dim.originator_id
        AND lender_user_dim_incl_new_records.postal_code IS NOT DISTINCT FROM lender_user_dim.postal_code
        AND lender_user_dim_incl_new_records.preferred_first_name IS NOT DISTINCT FROM lender_user_dim.preferred_first_name
        AND lender_user_dim_incl_new_records.schedule_once_booking_page_id IS NOT DISTINCT FROM lender_user_dim.schedule_once_booking_page_id
        AND lender_user_dim_incl_new_records.search_text IS NOT DISTINCT FROM lender_user_dim.search_text
        AND lender_user_dim_incl_new_records.state IS NOT DISTINCT FROM lender_user_dim.state
        AND lender_user_dim_incl_new_records.status IS NOT DISTINCT FROM lender_user_dim.status
        AND lender_user_dim_incl_new_records.status_code IS NOT DISTINCT FROM lender_user_dim.status_code
        AND lender_user_dim_incl_new_records.street1 IS NOT DISTINCT FROM lender_user_dim.street1
        AND lender_user_dim_incl_new_records.street2 IS NOT DISTINCT FROM lender_user_dim.street2
        AND lender_user_dim_incl_new_records.time_zone IS NOT DISTINCT FROM lender_user_dim.time_zone
        AND lender_user_dim_incl_new_records.time_zone_code IS NOT DISTINCT FROM lender_user_dim.time_zone_code
        AND lender_user_dim_incl_new_records.title IS NOT DISTINCT FROM lender_user_dim.title
        AND lender_user_dim_incl_new_records.total_workload_cap IS NOT DISTINCT FROM lender_user_dim.total_workload_cap
        AND lender_user_dim_incl_new_records.type IS NOT DISTINCT FROM lender_user_dim.type
        AND lender_user_dim_incl_new_records.type_code IS NOT DISTINCT FROM lender_user_dim.type_code
        AND lender_user_dim_incl_new_records.unparsed_name IS NOT DISTINCT FROM lender_user_dim.unparsed_name
        AND lender_user_dim_incl_new_records.username IS NOT DISTINCT FROM lender_user_dim.username
        AND lender_user_dim_incl_new_records.va_agent_id IS NOT DISTINCT FROM lender_user_dim.va_agent_id
        AND lender_user_dim_incl_new_records.start_date IS NOT DISTINCT FROM lender_user_dim.start_date
        AND lender_user_dim_incl_new_records.through_date IS NOT DISTINCT FROM lender_user_dim.through_date
WHERE lender_user_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'lender_user_dim'
        );


-- loan_beneficiary_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT loan_beneficiary_dim_incl_new_records.data_source_integration_columns
     , loan_beneficiary_dim_incl_new_records.data_source_integration_id
     , loan_beneficiary_dim_incl_new_records.edw_created_datetime
     , loan_beneficiary_dim_incl_new_records.edw_modified_datetime
     , loan_beneficiary_dim_incl_new_records.data_source_modified_datetime
     , loan_beneficiary_dim_incl_new_records.collateral_courier
     , loan_beneficiary_dim_incl_new_records.loan_file_courier
     , loan_beneficiary_dim_incl_new_records.delivery_aus
     , loan_beneficiary_dim_incl_new_records.mers_mom_flag
     , loan_beneficiary_dim_incl_new_records.loan_beneficiary_pid
     , loan_beneficiary_dim_incl_new_records.mers_transfer_status_code
     , loan_beneficiary_dim_incl_new_records.mers_transfer_override_flag
     , loan_beneficiary_dim_incl_new_records.loan_file_courier_code
     , loan_beneficiary_dim_incl_new_records.collateral_courier_code
     , loan_beneficiary_dim_incl_new_records.loan_pid
     , loan_beneficiary_dim_incl_new_records.delivery_aus_code
     , loan_beneficiary_dim_incl_new_records.early_funding_code
     , loan_beneficiary_dim_incl_new_records.pool_id
     , loan_beneficiary_dim_incl_new_records.loan_file_delivery_method_code
     , loan_beneficiary_dim_incl_new_records.transfer_status_code
     , loan_beneficiary_dim_incl_new_records.initial_flag
     , loan_beneficiary_dim_incl_new_records.current_flag
     , loan_beneficiary_dim_incl_new_records.investor_loan_id
     , loan_beneficiary_dim_incl_new_records.transfer_status
     , loan_beneficiary_dim_incl_new_records.loan_file_delivery_method
     , loan_beneficiary_dim_incl_new_records.mers_transfer_status
     , loan_beneficiary_dim_incl_new_records.early_funding
FROM (
         SELECT ''loan_beneficiary_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
                COALESCE(CAST(primary_table.lb_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
                      loan_beneficiary.*
                  FROM history_octane.loan_beneficiary
                           LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid = history_records.lb_pid
                      AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
                  WHERE history_records.lb_pid IS NULL
              ) AS primary_table

                  INNER JOIN (
             SELECT * FROM (
                               SELECT     <<courier_type_partial_load_condition>> as include_record,
                                          courier_type.*
                               FROM history_octane.courier_type
                                        LEFT JOIN history_octane.courier_type AS history_records ON courier_type.code = history_records.code
                                   AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t347 ON primary_table.lb_collateral_courier_type = t347.code

                  INNER JOIN (
             SELECT * FROM (
                               SELECT     <<courier_type_partial_load_condition>> as include_record,
                                          courier_type.*
                               FROM history_octane.courier_type
                                        LEFT JOIN history_octane.courier_type AS history_records ON courier_type.code = history_records.code
                                   AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t351 ON primary_table.lb_loan_file_courier_type = t351.code

                  INNER JOIN (
             SELECT * FROM (
                               SELECT     <<delivery_aus_type_partial_load_condition>> as include_record,
                                          delivery_aus_type.*
                               FROM history_octane.delivery_aus_type
                                        LEFT JOIN history_octane.delivery_aus_type AS history_records ON delivery_aus_type.code = history_records.code
                                   AND delivery_aus_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t348 ON primary_table.lb_delivery_aus_type = t348.code

                  INNER JOIN (
             SELECT * FROM (
                               SELECT     <<loan_benef_transfer_status_type_partial_load_condition>> as include_record,
                                          loan_benef_transfer_status_type.*
                               FROM history_octane.loan_benef_transfer_status_type
                                        LEFT JOIN history_octane.loan_benef_transfer_status_type AS history_records ON loan_benef_transfer_status_type.code = history_records.code
                                   AND loan_benef_transfer_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t350 ON primary_table.lb_loan_benef_transfer_status_type = t350.code

                  LEFT JOIN (
             SELECT * FROM (
                               SELECT     <<loan_file_delivery_method_type_partial_load_condition>> as include_record,
                                          loan_file_delivery_method_type.*
                               FROM history_octane.loan_file_delivery_method_type
                                        LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records ON loan_file_delivery_method_type.code = history_records.code
                                   AND loan_file_delivery_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t352 ON primary_table.lb_loan_file_delivery_method_type = t352.code

                  INNER JOIN (
             SELECT * FROM (
                               SELECT     <<mers_transfer_status_type_partial_load_condition>> as include_record,
                                          mers_transfer_status_type.*
                               FROM history_octane.mers_transfer_status_type
                                        LEFT JOIN history_octane.mers_transfer_status_type AS history_records ON mers_transfer_status_type.code = history_records.code
                                   AND mers_transfer_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t353 ON primary_table.lb_mers_transfer_status_type = t353.code

                  INNER JOIN (
             SELECT * FROM (
                               SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
                                          yes_no_unknown_type.*
                               FROM history_octane.yes_no_unknown_type
                                        LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                                   AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                               WHERE history_records.code IS NULL
                           ) as primary_table

         ) AS t349 ON primary_table.lb_early_funding = t349.code
         WHERE
             GREATEST(primary_table.include_record, t347.include_record, t351.include_record, t348.include_record, t350.include_record, t352.include_record, t353.include_record, t349.include_record) IS TRUE
         ORDER BY
             primary_table.data_source_updated_datetime ASC
 ) AS loan_beneficiary_dim_incl_new_records
     LEFT JOIN star_loan.loan_beneficiary_dim ON loan_beneficiary_dim_incl_new_records.data_source_integration_id =
                                                 loan_beneficiary_dim.data_source_integration_id
        AND loan_beneficiary_dim_incl_new_records.loan_pid IS NOT DISTINCT FROM loan_beneficiary_dim.loan_pid
        AND loan_beneficiary_dim_incl_new_records.collateral_courier IS NOT DISTINCT FROM loan_beneficiary_dim.collateral_courier
        AND loan_beneficiary_dim_incl_new_records.collateral_courier_code IS NOT DISTINCT FROM loan_beneficiary_dim.collateral_courier_code
        AND loan_beneficiary_dim_incl_new_records.delivery_aus IS NOT DISTINCT FROM loan_beneficiary_dim.delivery_aus
        AND loan_beneficiary_dim_incl_new_records.delivery_aus_code IS NOT DISTINCT FROM loan_beneficiary_dim.delivery_aus_code
        AND loan_beneficiary_dim_incl_new_records.early_funding IS NOT DISTINCT FROM loan_beneficiary_dim.early_funding
        AND loan_beneficiary_dim_incl_new_records.early_funding_code IS NOT DISTINCT FROM loan_beneficiary_dim.early_funding_code
        AND loan_beneficiary_dim_incl_new_records.investor_loan_id IS NOT DISTINCT FROM loan_beneficiary_dim.investor_loan_id
        AND loan_beneficiary_dim_incl_new_records.current_flag IS NOT DISTINCT FROM loan_beneficiary_dim.current_flag
        AND loan_beneficiary_dim_incl_new_records.initial_flag IS NOT DISTINCT FROM loan_beneficiary_dim.initial_flag
        AND loan_beneficiary_dim_incl_new_records.mers_mom_flag IS NOT DISTINCT FROM loan_beneficiary_dim.mers_mom_flag
        AND loan_beneficiary_dim_incl_new_records.mers_transfer_override_flag IS NOT DISTINCT FROM loan_beneficiary_dim.mers_transfer_override_flag
        AND loan_beneficiary_dim_incl_new_records.loan_file_courier IS NOT DISTINCT FROM loan_beneficiary_dim.loan_file_courier
        AND loan_beneficiary_dim_incl_new_records.loan_file_courier_code IS NOT DISTINCT FROM loan_beneficiary_dim.loan_file_courier_code
        AND loan_beneficiary_dim_incl_new_records.loan_file_delivery_method IS NOT DISTINCT FROM loan_beneficiary_dim.loan_file_delivery_method
        AND loan_beneficiary_dim_incl_new_records.loan_file_delivery_method_code IS NOT DISTINCT FROM loan_beneficiary_dim.loan_file_delivery_method_code
        AND loan_beneficiary_dim_incl_new_records.mers_transfer_status IS NOT DISTINCT FROM loan_beneficiary_dim.mers_transfer_status
        AND loan_beneficiary_dim_incl_new_records.mers_transfer_status_code IS NOT DISTINCT FROM loan_beneficiary_dim.mers_transfer_status_code
        AND loan_beneficiary_dim_incl_new_records.pool_id IS NOT DISTINCT FROM loan_beneficiary_dim.pool_id
        AND loan_beneficiary_dim_incl_new_records.transfer_status IS NOT DISTINCT FROM loan_beneficiary_dim.transfer_status
        AND loan_beneficiary_dim_incl_new_records.transfer_status_code IS NOT DISTINCT FROM loan_beneficiary_dim.transfer_status_code
WHERE loan_beneficiary_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'loan_beneficiary_dim'
        );


-- loan_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT loan_dim_incl_new_records.data_source_integration_columns
     , loan_dim_incl_new_records.data_source_integration_id
     , loan_dim_incl_new_records.edw_created_datetime
     , loan_dim_incl_new_records.edw_modified_datetime
     , loan_dim_incl_new_records.data_source_modified_datetime
     , loan_dim_incl_new_records.last_unprocessed_changes_datetime
     , loan_dim_incl_new_records.locked_price_change_percent
     , loan_dim_incl_new_records.mi_requirement_ltv_ratio_percent
     , loan_dim_incl_new_records.base_loan_amount_ltv_ratio_percent
     , loan_dim_incl_new_records.arm_index_current_value_percent
     , loan_dim_incl_new_records.arm_index_datetime
     , loan_dim_incl_new_records.product_terms_pid
     , loan_dim_incl_new_records.proposal_pid
     , loan_dim_incl_new_records.loan_pid
     , loan_dim_incl_new_records.fhac_case_assignment_messages
     , loan_dim_incl_new_records.product_choice_datetime
     , loan_dim_incl_new_records.fnm_mbs_investor_contract_id
     , loan_dim_incl_new_records.base_guaranty_fee_percent
     , loan_dim_incl_new_records.guaranty_fee_percent
     , loan_dim_incl_new_records.guaranty_fee_after_alternate_payment_method_percent
     , loan_dim_incl_new_records.fnm_investor_product_plan_id
     , loan_dim_incl_new_records.uldd_loan_comment
     , loan_dim_incl_new_records.hmda_rate_spread_percent
     , loan_dim_incl_new_records.hoepa_apr
     , loan_dim_incl_new_records.hoepa_rate_spread
     , loan_dim_incl_new_records.rate_sheet_undiscounted_rate_percent
     , loan_dim_incl_new_records.effective_undiscounted_rate_percent
     , loan_dim_incl_new_records.los_loan_number
FROM (
    SELECT ''loan_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
    COALESCE(CAST(primary_table.l_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
    primary_table.l_base_guaranty_fee_basis_points as base_guaranty_fee_percent,
    primary_table.l_guaranty_fee_basis_points as guaranty_fee_percent,
    primary_table.l_guaranty_fee_after_alternate_payment_method_basis_points as guaranty_fee_after_alternate_payment_method_percent,
    primary_table.l_fnm_investor_product_plan_id as fnm_investor_product_plan_id,
    primary_table.l_uldd_loan_comment as uldd_loan_comment,
    primary_table.l_hmda_rate_spread_percent as hmda_rate_spread_percent,
    primary_table.l_hoepa_apr as hoepa_apr,
    primary_table.l_hoepa_rate_spread as hoepa_rate_spread,
    primary_table.l_rate_sheet_undiscounted_rate_percent as rate_sheet_undiscounted_rate_percent,
    primary_table.l_effective_undiscounted_rate_percent as effective_undiscounted_rate_percent,
    CASE WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN t1317.d_los_loan_id_main ELSE t1317.d_los_loan_id_piggyback END as los_loan_number
FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        loan.*
    FROM history_octane.loan
    LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
        AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
) AS primary_table

INNER JOIN (
    SELECT * FROM (
        SELECT
            proposal.*
        FROM history_octane.proposal
        LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
            AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.prp_pid IS NULL
    ) as primary_table

        -- child join start
    INNER JOIN
    (
        SELECT
            <<deal_partial_load_condition>> as include_record,
            deal.*
        FROM
            history_octane.deal
            LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE
            history_records.d_pid IS NULL
    ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
    -- child join end

) AS t1317 ON primary_table.l_proposal_pid = t1317.prp_pid
WHERE
    GREATEST(primary_table.include_record, t1317.include_record) IS TRUE
ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS loan_dim_incl_new_records
    LEFT JOIN star_loan.loan_dim ON loan_dim_incl_new_records.data_source_integration_id =
                                    loan_dim.data_source_integration_id
        AND loan_dim_incl_new_records.proposal_pid IS NOT DISTINCT FROM loan_dim.proposal_pid
        AND loan_dim_incl_new_records.product_terms_pid IS NOT DISTINCT FROM loan_dim.product_terms_pid
        AND loan_dim_incl_new_records.los_loan_number IS NOT DISTINCT FROM loan_dim.los_loan_number
        AND loan_dim_incl_new_records.arm_index_current_value_percent IS NOT DISTINCT FROM loan_dim.arm_index_current_value_percent
        AND loan_dim_incl_new_records.arm_index_datetime IS NOT DISTINCT FROM loan_dim.arm_index_datetime
        AND loan_dim_incl_new_records.base_guaranty_fee_percent IS NOT DISTINCT FROM loan_dim.base_guaranty_fee_percent
        AND loan_dim_incl_new_records.base_loan_amount_ltv_ratio_percent IS NOT DISTINCT FROM loan_dim.base_loan_amount_ltv_ratio_percent
        AND loan_dim_incl_new_records.effective_undiscounted_rate_percent IS NOT DISTINCT FROM loan_dim.effective_undiscounted_rate_percent
        AND loan_dim_incl_new_records.fhac_case_assignment_messages IS NOT DISTINCT FROM loan_dim.fhac_case_assignment_messages
        AND loan_dim_incl_new_records.fnm_investor_product_plan_id IS NOT DISTINCT FROM loan_dim.fnm_investor_product_plan_id
        AND loan_dim_incl_new_records.fnm_mbs_investor_contract_id IS NOT DISTINCT FROM loan_dim.fnm_mbs_investor_contract_id
        AND loan_dim_incl_new_records.guaranty_fee_after_alternate_payment_method_percent IS NOT DISTINCT FROM loan_dim.guaranty_fee_after_alternate_payment_method_percent
        AND loan_dim_incl_new_records.guaranty_fee_percent IS NOT DISTINCT FROM loan_dim.guaranty_fee_percent
        AND loan_dim_incl_new_records.hmda_rate_spread_percent IS NOT DISTINCT FROM loan_dim.hmda_rate_spread_percent
        AND loan_dim_incl_new_records.hoepa_apr IS NOT DISTINCT FROM loan_dim.hoepa_apr
        AND loan_dim_incl_new_records.hoepa_rate_spread IS NOT DISTINCT FROM loan_dim.hoepa_rate_spread
        AND loan_dim_incl_new_records.last_unprocessed_changes_datetime IS NOT DISTINCT FROM loan_dim.last_unprocessed_changes_datetime
        AND loan_dim_incl_new_records.locked_price_change_percent IS NOT DISTINCT FROM loan_dim.locked_price_change_percent
        AND loan_dim_incl_new_records.mi_requirement_ltv_ratio_percent IS NOT DISTINCT FROM loan_dim.mi_requirement_ltv_ratio_percent
        AND loan_dim_incl_new_records.product_choice_datetime IS NOT DISTINCT FROM loan_dim.product_choice_datetime
        AND loan_dim_incl_new_records.rate_sheet_undiscounted_rate_percent IS NOT DISTINCT FROM loan_dim.rate_sheet_undiscounted_rate_percent
        AND loan_dim_incl_new_records.uldd_loan_comment IS NOT DISTINCT FROM loan_dim.uldd_loan_comment
WHERE loan_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'loan_dim'
        );


-- loan_funding_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT loan_funding_dim_incl_new_records.data_source_integration_columns
     , loan_funding_dim_incl_new_records.data_source_integration_id
     , loan_funding_dim_incl_new_records.edw_created_datetime
     , loan_funding_dim_incl_new_records.edw_modified_datetime
     , loan_funding_dim_incl_new_records.data_source_modified_datetime
     , loan_funding_dim_incl_new_records.collateral_courier
     , loan_funding_dim_incl_new_records.funding_status
     , loan_funding_dim_incl_new_records.release_wire_federal_reference_number
     , loan_funding_dim_incl_new_records.interim_funder_fee_amount
     , loan_funding_dim_incl_new_records.wire_amount
     , loan_funding_dim_incl_new_records.funding_confirmed_release_datetime
     , loan_funding_dim_incl_new_records.funding_status_code
     , loan_funding_dim_incl_new_records.interim_funder_loan_id
     , loan_funding_dim_incl_new_records.loan_funding_pid
     , loan_funding_dim_incl_new_records.loan_pid
     , loan_funding_dim_incl_new_records.interim_funder_pid
     , loan_funding_dim_incl_new_records.early_wire_request_flag
     , loan_funding_dim_incl_new_records.scheduled_release_date_auto_compute_flag
     , loan_funding_dim_incl_new_records.early_wire_total_charge_amount
     , loan_funding_dim_incl_new_records.early_wire_daily_charge_amount
     , loan_funding_dim_incl_new_records.early_wire_charge_day_count
     , loan_funding_dim_incl_new_records.net_wire_amount
     , loan_funding_dim_incl_new_records.post_wire_adjustment_amount
     , loan_funding_dim_incl_new_records.collateral_courier_code
     , loan_funding_dim_incl_new_records.funds_authorized_datetime
     , loan_funding_dim_incl_new_records.funds_authorization_code
     , loan_funding_dim_incl_new_records.collateral_tracking_number
FROM (
        SELECT ''loan_funding_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.lf_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        primary_table.lf_funds_authorization_code as funds_authorization_code,
        primary_table.lf_collateral_tracking_number as collateral_tracking_number
 FROM (
    SELECT
        <<loan_funding_partial_load_condition>> as include_record,
        loan_funding.*
    FROM history_octane.loan_funding
        LEFT JOIN history_octane.loan_funding AS history_records ON loan_funding.lf_pid = history_records.lf_pid
            AND loan_funding.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lf_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<courier_type_partial_load_condition>> as include_record,
            courier_type.*
            FROM history_octane.courier_type
                LEFT JOIN history_octane.courier_type AS history_records ON courier_type.code = history_records.code
                AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t380 ON primary_table.lf_collateral_courier_type = t380.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<funding_status_type_partial_load_condition>> as include_record,
            funding_status_type.*
            FROM history_octane.funding_status_type
                LEFT JOIN history_octane.funding_status_type AS history_records ON funding_status_type.code = history_records.code
                AND funding_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t381 ON primary_table.lf_funding_status_type = t381.code
 WHERE
    GREATEST(primary_table.include_record, t380.include_record, t381.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS loan_funding_dim_incl_new_records
    LEFT JOIN star_loan.loan_funding_dim ON loan_funding_dim_incl_new_records.data_source_integration_id =
                                            loan_funding_dim.data_source_integration_id
        AND loan_funding_dim_incl_new_records.loan_pid IS NOT DISTINCT FROM loan_funding_dim.loan_pid
        AND loan_funding_dim_incl_new_records.interim_funder_pid IS NOT DISTINCT FROM loan_funding_dim.interim_funder_pid
        AND loan_funding_dim_incl_new_records.collateral_courier IS NOT DISTINCT FROM loan_funding_dim.collateral_courier
        AND loan_funding_dim_incl_new_records.collateral_courier_code IS NOT DISTINCT FROM loan_funding_dim.collateral_courier_code
        AND loan_funding_dim_incl_new_records.early_wire_charge_day_count IS NOT DISTINCT FROM loan_funding_dim.early_wire_charge_day_count
        AND loan_funding_dim_incl_new_records.early_wire_daily_charge_amount IS NOT DISTINCT FROM loan_funding_dim.early_wire_daily_charge_amount
        AND loan_funding_dim_incl_new_records.early_wire_total_charge_amount IS NOT DISTINCT FROM loan_funding_dim.early_wire_total_charge_amount
        AND loan_funding_dim_incl_new_records.funding_confirmed_release_datetime IS NOT DISTINCT FROM loan_funding_dim.funding_confirmed_release_datetime
        AND loan_funding_dim_incl_new_records.funding_status IS NOT DISTINCT FROM loan_funding_dim.funding_status
        AND loan_funding_dim_incl_new_records.funding_status_code IS NOT DISTINCT FROM loan_funding_dim.funding_status_code
        AND loan_funding_dim_incl_new_records.funds_authorization_code IS NOT DISTINCT FROM loan_funding_dim.funds_authorization_code
        AND loan_funding_dim_incl_new_records.funds_authorized_datetime IS NOT DISTINCT FROM loan_funding_dim.funds_authorized_datetime
        AND loan_funding_dim_incl_new_records.interim_funder_fee_amount IS NOT DISTINCT FROM loan_funding_dim.interim_funder_fee_amount
        AND loan_funding_dim_incl_new_records.interim_funder_loan_id IS NOT DISTINCT FROM loan_funding_dim.interim_funder_loan_id
        AND loan_funding_dim_incl_new_records.early_wire_request_flag IS NOT DISTINCT FROM loan_funding_dim.early_wire_request_flag
        AND loan_funding_dim_incl_new_records.scheduled_release_date_auto_compute_flag IS NOT DISTINCT FROM loan_funding_dim.scheduled_release_date_auto_compute_flag
        AND loan_funding_dim_incl_new_records.net_wire_amount IS NOT DISTINCT FROM loan_funding_dim.net_wire_amount
        AND loan_funding_dim_incl_new_records.post_wire_adjustment_amount IS NOT DISTINCT FROM loan_funding_dim.post_wire_adjustment_amount
        AND loan_funding_dim_incl_new_records.release_wire_federal_reference_number IS NOT DISTINCT FROM loan_funding_dim.release_wire_federal_reference_number
        AND loan_funding_dim_incl_new_records.wire_amount IS NOT DISTINCT FROM loan_funding_dim.wire_amount
        AND loan_funding_dim_incl_new_records.collateral_tracking_number IS NOT DISTINCT FROM loan_funding_dim.collateral_tracking_number
WHERE loan_funding_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'loan_funding_dim'
        );


-- mortgage_insurance_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT mortgage_insurance_dim_incl_new_records.data_source_integration_columns
     , mortgage_insurance_dim_incl_new_records.data_source_integration_id
     , mortgage_insurance_dim_incl_new_records.edw_created_datetime
     , mortgage_insurance_dim_incl_new_records.edw_modified_datetime
     , mortgage_insurance_dim_incl_new_records.data_source_modified_datetime
     , mortgage_insurance_dim_incl_new_records.mi_rate_quote_id
     , mortgage_insurance_dim_incl_new_records.mi_base_upfront_payment_amount
     , mortgage_insurance_dim_incl_new_records.mi_base_monthly_payment_amount
     , mortgage_insurance_dim_incl_new_records.mi_base_upfront_percent
     , mortgage_insurance_dim_incl_new_records.mi_base_monthly_payment_annual_percent
     , mortgage_insurance_dim_incl_new_records.mi_base_rate_label
     , mortgage_insurance_dim_incl_new_records.mi_renewal_calculated_rate_code
     , mortgage_insurance_dim_incl_new_records.mi_initial_calculated_rate_code
     , mortgage_insurance_dim_incl_new_records.mi_initial_monthly_payment_annual_percent
     , mortgage_insurance_dim_incl_new_records.mi_initial_duration_months
     , mortgage_insurance_dim_incl_new_records.mi_renewal_monthly_payment_amount
     , mortgage_insurance_dim_incl_new_records.mi_renewal_monthly_payment_annual_percent
     , mortgage_insurance_dim_incl_new_records.mi_initial_monthly_payment_amount
     , mortgage_insurance_dim_incl_new_records.mi_upront_percent
     , mortgage_insurance_dim_incl_new_records.mi_upfront_amount
     , mortgage_insurance_dim_incl_new_records.mi_payment_code
     , mortgage_insurance_dim_incl_new_records.mi_actual_monthly_payment_count
     , mortgage_insurance_dim_incl_new_records.mi_required_monthly_payment_count
     , mortgage_insurance_dim_incl_new_records.mi_midpoint_cutoff_required_flag
     , mortgage_insurance_dim_incl_new_records.mi_ltv_cutoff_percent
     , mortgage_insurance_dim_incl_new_records.mi_coverage_percent
     , mortgage_insurance_dim_incl_new_records.mi_payer_code
     , mortgage_insurance_dim_incl_new_records.mi_renewal_calculation_code
     , mortgage_insurance_dim_incl_new_records.mi_initial_calculation_code
     , mortgage_insurance_dim_incl_new_records.mi_premium_refundable_code
     , mortgage_insurance_dim_incl_new_records.mi_certificate_id
     , mortgage_insurance_dim_incl_new_records.mi_company_code
     , mortgage_insurance_dim_incl_new_records.mi_input_code
     , mortgage_insurance_dim_incl_new_records.no_mi_product_flag
     , mortgage_insurance_dim_incl_new_records.mi_auto_compute_flag
     , mortgage_insurance_dim_incl_new_records.loan_pid
     , mortgage_insurance_dim_incl_new_records.mi_lender_paid_rate_adjustment_percent
     , mortgage_insurance_dim_incl_new_records.mi_initial_calculated_rate
     , mortgage_insurance_dim_incl_new_records.mi_renewal_calcuated_rate
     , mortgage_insurance_dim_incl_new_records.mi_company
     , mortgage_insurance_dim_incl_new_records.mi_initial_calculation
     , mortgage_insurance_dim_incl_new_records.mi_input
     , mortgage_insurance_dim_incl_new_records.mi_payer
     , mortgage_insurance_dim_incl_new_records.mi_payment
     , mortgage_insurance_dim_incl_new_records.mi_premium_refundable
     , mortgage_insurance_dim_incl_new_records.mi_renewal_calculation
     , mortgage_insurance_dim_incl_new_records.loan_dwid
FROM (
        SELECT ''loan_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.l_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        loan.*
    FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
            AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_calculated_rate_type_partial_load_condition>> as include_record,
            mi_calculated_rate_type.*
            FROM history_octane.mi_calculated_rate_type
                LEFT JOIN history_octane.mi_calculated_rate_type AS history_records ON mi_calculated_rate_type.code = history_records.code
                AND mi_calculated_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t471 ON primary_table.l_mi_initial_calculated_rate_type = t471.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_calculated_rate_type_partial_load_condition>> as include_record,
            mi_calculated_rate_type.*
            FROM history_octane.mi_calculated_rate_type
                LEFT JOIN history_octane.mi_calculated_rate_type AS history_records ON mi_calculated_rate_type.code = history_records.code
                AND mi_calculated_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t477 ON primary_table.l_mi_renewal_calculated_rate_type = t477.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_company_name_type_partial_load_condition>> as include_record,
            mi_company_name_type.*
            FROM history_octane.mi_company_name_type
                LEFT JOIN history_octane.mi_company_name_type AS history_records ON mi_company_name_type.code = history_records.code
                AND mi_company_name_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t470 ON primary_table.l_mi_company_name_type = t470.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_initial_calculation_type_partial_load_condition>> as include_record,
            mi_initial_calculation_type.*
            FROM history_octane.mi_initial_calculation_type
                LEFT JOIN history_octane.mi_initial_calculation_type AS history_records ON mi_initial_calculation_type.code = history_records.code
                AND mi_initial_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t472 ON primary_table.l_mi_initial_calculation_type = t472.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_input_type_partial_load_condition>> as include_record,
            mi_input_type.*
            FROM history_octane.mi_input_type
                LEFT JOIN history_octane.mi_input_type AS history_records ON mi_input_type.code = history_records.code
                AND mi_input_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t473 ON primary_table.l_mi_input_type = t473.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_payer_type_partial_load_condition>> as include_record,
            mi_payer_type.*
            FROM history_octane.mi_payer_type
                LEFT JOIN history_octane.mi_payer_type AS history_records ON mi_payer_type.code = history_records.code
                AND mi_payer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t474 ON primary_table.l_mi_payer_type = t474.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_payment_type_partial_load_condition>> as include_record,
            mi_payment_type.*
            FROM history_octane.mi_payment_type
                LEFT JOIN history_octane.mi_payment_type AS history_records ON mi_payment_type.code = history_records.code
                AND mi_payment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t475 ON primary_table.l_mi_payment_type = t475.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_premium_refundable_type_partial_load_condition>> as include_record,
            mi_premium_refundable_type.*
            FROM history_octane.mi_premium_refundable_type
                LEFT JOIN history_octane.mi_premium_refundable_type AS history_records ON mi_premium_refundable_type.code = history_records.code
                AND mi_premium_refundable_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t476 ON primary_table.l_mi_premium_refundable_type = t476.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_renewal_calculation_type_partial_load_condition>> as include_record,
            mi_renewal_calculation_type.*
            FROM history_octane.mi_renewal_calculation_type
                LEFT JOIN history_octane.mi_renewal_calculation_type AS history_records ON mi_renewal_calculation_type.code = history_records.code
                AND mi_renewal_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
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
) AS mortgage_insurance_dim_incl_new_records
    LEFT JOIN star_loan.mortgage_insurance_dim ON mortgage_insurance_dim_incl_new_records.data_source_integration_id =
                                                  mortgage_insurance_dim.data_source_integration_id
    AND mortgage_insurance_dim_incl_new_records.mi_auto_compute_flag IS NOT DISTINCT FROM mortgage_insurance_dim.mi_auto_compute_flag
    AND mortgage_insurance_dim_incl_new_records.mi_midpoint_cutoff_required_flag IS NOT DISTINCT FROM mortgage_insurance_dim.mi_midpoint_cutoff_required_flag
    AND mortgage_insurance_dim_incl_new_records.no_mi_product_flag IS NOT DISTINCT FROM mortgage_insurance_dim.no_mi_product_flag
    AND mortgage_insurance_dim_incl_new_records.mi_actual_monthly_payment_count IS NOT DISTINCT FROM mortgage_insurance_dim.mi_actual_monthly_payment_count
    AND mortgage_insurance_dim_incl_new_records.mi_base_monthly_payment_amount IS NOT DISTINCT FROM mortgage_insurance_dim.mi_base_monthly_payment_amount
    AND mortgage_insurance_dim_incl_new_records.mi_base_monthly_payment_annual_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_base_monthly_payment_annual_percent
    AND mortgage_insurance_dim_incl_new_records.mi_base_rate_label IS NOT DISTINCT FROM mortgage_insurance_dim.mi_base_rate_label
    AND mortgage_insurance_dim_incl_new_records.mi_base_upfront_payment_amount IS NOT DISTINCT FROM mortgage_insurance_dim.mi_base_upfront_payment_amount
    AND mortgage_insurance_dim_incl_new_records.mi_base_upfront_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_base_upfront_percent
    AND mortgage_insurance_dim_incl_new_records.mi_certificate_id IS NOT DISTINCT FROM mortgage_insurance_dim.mi_certificate_id
    AND mortgage_insurance_dim_incl_new_records.mi_company IS NOT DISTINCT FROM mortgage_insurance_dim.mi_company
    AND mortgage_insurance_dim_incl_new_records.mi_company_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_company_code
    AND mortgage_insurance_dim_incl_new_records.mi_coverage_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_coverage_percent
    AND mortgage_insurance_dim_incl_new_records.mi_initial_calculated_rate IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_calculated_rate
    AND mortgage_insurance_dim_incl_new_records.mi_initial_calculated_rate_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_calculated_rate_code
    AND mortgage_insurance_dim_incl_new_records.mi_initial_calculation IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_calculation
    AND mortgage_insurance_dim_incl_new_records.mi_initial_calculation_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_calculation_code
    AND mortgage_insurance_dim_incl_new_records.mi_initial_duration_months IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_duration_months
    AND mortgage_insurance_dim_incl_new_records.mi_initial_monthly_payment_amount IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_monthly_payment_amount
    AND mortgage_insurance_dim_incl_new_records.mi_initial_monthly_payment_annual_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_initial_monthly_payment_annual_percent
    AND mortgage_insurance_dim_incl_new_records.mi_input IS NOT DISTINCT FROM mortgage_insurance_dim.mi_input
    AND mortgage_insurance_dim_incl_new_records.mi_input_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_input_code
    AND mortgage_insurance_dim_incl_new_records.mi_lender_paid_rate_adjustment_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_lender_paid_rate_adjustment_percent
    AND mortgage_insurance_dim_incl_new_records.mi_ltv_cutoff_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_ltv_cutoff_percent
    AND mortgage_insurance_dim_incl_new_records.mi_payer IS NOT DISTINCT FROM mortgage_insurance_dim.mi_payer
    AND mortgage_insurance_dim_incl_new_records.mi_payer_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_payer_code
    AND mortgage_insurance_dim_incl_new_records.mi_payment IS NOT DISTINCT FROM mortgage_insurance_dim.mi_payment
    AND mortgage_insurance_dim_incl_new_records.mi_payment_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_payment_code
    AND mortgage_insurance_dim_incl_new_records.mi_premium_refundable IS NOT DISTINCT FROM mortgage_insurance_dim.mi_premium_refundable
    AND mortgage_insurance_dim_incl_new_records.mi_premium_refundable_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_premium_refundable_code
    AND mortgage_insurance_dim_incl_new_records.mi_rate_quote_id IS NOT DISTINCT FROM mortgage_insurance_dim.mi_rate_quote_id
    AND mortgage_insurance_dim_incl_new_records.mi_renewal_calcuated_rate IS NOT DISTINCT FROM mortgage_insurance_dim.mi_renewal_calcuated_rate
    AND mortgage_insurance_dim_incl_new_records.mi_renewal_calculated_rate_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_renewal_calculated_rate_code
    AND mortgage_insurance_dim_incl_new_records.mi_renewal_calculation IS NOT DISTINCT FROM mortgage_insurance_dim.mi_renewal_calculation
    AND mortgage_insurance_dim_incl_new_records.mi_renewal_calculation_code IS NOT DISTINCT FROM mortgage_insurance_dim.mi_renewal_calculation_code
    AND mortgage_insurance_dim_incl_new_records.mi_renewal_monthly_payment_amount IS NOT DISTINCT FROM mortgage_insurance_dim.mi_renewal_monthly_payment_amount
    AND mortgage_insurance_dim_incl_new_records.mi_renewal_monthly_payment_annual_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_renewal_monthly_payment_annual_percent
    AND mortgage_insurance_dim_incl_new_records.mi_required_monthly_payment_count IS NOT DISTINCT FROM mortgage_insurance_dim.mi_required_monthly_payment_count
    AND mortgage_insurance_dim_incl_new_records.mi_upfront_amount IS NOT DISTINCT FROM mortgage_insurance_dim.mi_upfront_amount
    AND mortgage_insurance_dim_incl_new_records.mi_upront_percent IS NOT DISTINCT FROM mortgage_insurance_dim.mi_upront_percent
WHERE mortgage_insurance_dim.loan_dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'mortgage_insurance_dim'
        );


-- product_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT product_dim_incl_new_records.data_source_integration_columns
     , product_dim_incl_new_records.data_source_integration_id
     , product_dim_incl_new_records.edw_created_datetime
     , product_dim_incl_new_records.edw_modified_datetime
     , product_dim_incl_new_records.data_source_modified_datetime
     , product_dim_incl_new_records.fund_source
     , product_dim_incl_new_records.product_pid
     , product_dim_incl_new_records.description
     , product_dim_incl_new_records.lock_auto_confirm_flag
     , product_dim_incl_new_records.fnm_product_name
     , product_dim_incl_new_records.through_date
     , product_dim_incl_new_records.from_date
     , product_dim_incl_new_records.investor_product_name
     , product_dim_incl_new_records.investor_product_id
     , product_dim_incl_new_records.fund_source_code
     , product_dim_incl_new_records.product_side_code
     , product_dim_incl_new_records.investor_pid
     , product_dim_incl_new_records.product_side
FROM (
        SELECT ''product_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.p_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
        product.*
    FROM history_octane.product
        LEFT JOIN history_octane.product AS history_records ON product.p_pid = history_records.p_pid
            AND product.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.p_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fund_source_type_partial_load_condition>> as include_record,
            fund_source_type.*
            FROM history_octane.fund_source_type
                LEFT JOIN history_octane.fund_source_type AS history_records ON fund_source_type.code = history_records.code
                AND fund_source_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t755 ON primary_table.p_fund_source_type = t755.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<product_side_type_partial_load_condition>> as include_record,
            product_side_type.*
            FROM history_octane.product_side_type
                LEFT JOIN history_octane.product_side_type AS history_records ON product_side_type.code = history_records.code
                AND product_side_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t756 ON primary_table.p_product_side_type = t756.code
 WHERE
    GREATEST(primary_table.include_record, t755.include_record, t756.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS product_dim_incl_new_records
    LEFT JOIN star_loan.product_dim ON product_dim_incl_new_records.data_source_integration_id =
                                       product_dim.data_source_integration_id
    AND product_dim_incl_new_records.investor_pid IS NOT DISTINCT FROM product_dim.investor_pid
    AND product_dim_incl_new_records.investor_product_id IS NOT DISTINCT FROM product_dim.investor_product_id
    AND product_dim_incl_new_records.description IS NOT DISTINCT FROM product_dim.description
    AND product_dim_incl_new_records.fnm_product_name IS NOT DISTINCT FROM product_dim.fnm_product_name
    AND product_dim_incl_new_records.fund_source IS NOT DISTINCT FROM product_dim.fund_source
    AND product_dim_incl_new_records.fund_source_code IS NOT DISTINCT FROM product_dim.fund_source_code
    AND product_dim_incl_new_records.investor_product_name IS NOT DISTINCT FROM product_dim.investor_product_name
    AND product_dim_incl_new_records.lock_auto_confirm_flag IS NOT DISTINCT FROM product_dim.lock_auto_confirm_flag
    AND product_dim_incl_new_records.product_side IS NOT DISTINCT FROM product_dim.product_side
    AND product_dim_incl_new_records.product_side_code IS NOT DISTINCT FROM product_dim.product_side_code
    AND product_dim_incl_new_records.from_date IS NOT DISTINCT FROM product_dim.from_date
    AND product_dim_incl_new_records.through_date IS NOT DISTINCT FROM product_dim.through_date
WHERE product_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'product_dim'
        );


-- product_terms_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT product_terms_dim_incl_new_records.data_source_integration_columns
     , product_terms_dim_incl_new_records.data_source_integration_id
     , product_terms_dim_incl_new_records.edw_created_datetime
     , product_terms_dim_incl_new_records.edw_modified_datetime
     , product_terms_dim_incl_new_records.data_source_modified_datetime
     , product_terms_dim_incl_new_records.arm_index
     , product_terms_dim_incl_new_records.buydown_base_date
     , product_terms_dim_incl_new_records.buydown_subsidy_calculation
     , product_terms_dim_incl_new_records.community_lending
     , product_terms_dim_incl_new_records.days_per_year
     , product_terms_dim_incl_new_records.decision_credit_score_calc
     , product_terms_dim_incl_new_records.fha_rehab_program
     , product_terms_dim_incl_new_records.fha_special_program
     , product_terms_dim_incl_new_records.fnm_arm_plan
     , product_terms_dim_incl_new_records.fnm_community_lending_product
     , product_terms_dim_incl_new_records.fre_community_program
     , product_terms_dim_incl_new_records.heloc_cancel_fee_applicable
     , product_terms_dim_incl_new_records.ipc_calc
     , product_terms_dim_incl_new_records.ipc_comparison_operator3
     , product_terms_dim_incl_new_records.ipc_comparison_operator1
     , product_terms_dim_incl_new_records.ipc_comparison_operator2
     , product_terms_dim_incl_new_records.ipc_comparison_operator4
     , product_terms_dim_incl_new_records.ipc_property_usage3
     , product_terms_dim_incl_new_records.ipc_property_usage1
     , product_terms_dim_incl_new_records.ipc_property_usage2
     , product_terms_dim_incl_new_records.ipc_property_usage4
     , product_terms_dim_incl_new_records.lien_priority
     , product_terms_dim_incl_new_records.loan_amortization
     , product_terms_dim_incl_new_records.mortgage_type
     , product_terms_dim_incl_new_records.negative_amortization
     , product_terms_dim_incl_new_records.partial_payment_policy
     , product_terms_dim_incl_new_records.arm_payment_adjustment_calculation
     , product_terms_dim_incl_new_records.payment_frequency
     , product_terms_dim_incl_new_records.payment_structure
     , product_terms_dim_incl_new_records.prepaid_interest_rate
     , product_terms_dim_incl_new_records.prepay_penalty
     , product_terms_dim_incl_new_records.product_appraisal_requirement
     , product_terms_dim_incl_new_records.product_special_program
     , product_terms_dim_incl_new_records.ipc_comparison_operator_code3
     , product_terms_dim_incl_new_records.ipc_cltv_ratio_percent3
     , product_terms_dim_incl_new_records.ipc_limit_percent4
     , product_terms_dim_incl_new_records.ipc_property_usage_code4
     , product_terms_dim_incl_new_records.ipc_comparison_operator_code4
     , product_terms_dim_incl_new_records.ipc_cltv_ratio_percent4
     , product_terms_dim_incl_new_records.buydown_base_date_code
     , product_terms_dim_incl_new_records.buydown_subsidy_calculation_code
     , product_terms_dim_incl_new_records.prepaid_interest_rate_code
     , product_terms_dim_incl_new_records.fnm_arm_plan_code
     , product_terms_dim_incl_new_records.dsi_plan_code
     , product_terms_dim_incl_new_records.credit_qualifying_flag
     , product_terms_dim_incl_new_records.product_special_program_code
     , product_terms_dim_incl_new_records.section_of_act_coarse_code
     , product_terms_dim_incl_new_records.fha_rehab_program_code
     , product_terms_dim_incl_new_records.fha_special_program_code
     , product_terms_dim_incl_new_records.third_party_grant_eligible_flag
     , product_terms_dim_incl_new_records.servicing_transfer_code
     , product_terms_dim_incl_new_records.no_mi_product_flag
     , product_terms_dim_incl_new_records.mortgage_credit_certificate_eligible_flag
     , product_terms_dim_incl_new_records.fre_community_program_code
     , product_terms_dim_incl_new_records.fnm_community_lending_product_code
     , product_terms_dim_incl_new_records.zero_note_rate_flag
     , product_terms_dim_incl_new_records.third_party_community_second_program_eligibility_code
     , product_terms_dim_incl_new_records.texas_veterans_land_board_code
     , product_terms_dim_incl_new_records.security_instrument_page_count
     , product_terms_dim_incl_new_records.deed_page_count
     , product_terms_dim_incl_new_records.partial_payment_policy_code
     , product_terms_dim_incl_new_records.payment_structure_code
     , product_terms_dim_incl_new_records.deferred_payment_months
     , product_terms_dim_incl_new_records.always_current_market_price_flag
     , product_terms_dim_incl_new_records.rate_protect_flag
     , product_terms_dim_incl_new_records.non_conforming_flag
     , product_terms_dim_incl_new_records.allow_loan_amount_cents_flag
     , product_terms_dim_incl_new_records.product_appraisal_requirement_code
     , product_terms_dim_incl_new_records.family_advantage_flag
     , product_terms_dim_incl_new_records.community_lending_code
     , product_terms_dim_incl_new_records.high_balance_code
     , product_terms_dim_incl_new_records.decision_credit_score_calc_code
     , product_terms_dim_incl_new_records.new_york_flag
     , product_terms_dim_incl_new_records.manual_risk_assessment_accepted_flag
     , product_terms_dim_incl_new_records.external_fha_underwrite_accepted_flag
     , product_terms_dim_incl_new_records.external_va_underwrite_accepted_flag
     , product_terms_dim_incl_new_records.external_usda_underwrite_accepted_flag
     , product_terms_dim_incl_new_records.external_investor_underwrite_accepted_flag
     , product_terms_dim_incl_new_records.heloc_cancel_fee_applicable_code
     , product_terms_dim_incl_new_records.heloc_cancel_fee_period_months
     , product_terms_dim_incl_new_records.heloc_cancel_fee_amount
     , product_terms_dim_incl_new_records.heloc_draw_period_months
     , product_terms_dim_incl_new_records.heloc_repayment_period_duration_months
     , product_terms_dim_incl_new_records.heloc_maximum_initial_draw_flag
     , product_terms_dim_incl_new_records.heloc_maximum_initial_draw_amount
     , product_terms_dim_incl_new_records.heloc_minimum_draw_flag
     , product_terms_dim_incl_new_records.heloc_minimum_draw_amount
     , product_terms_dim_incl_new_records.gpm_adjustment_years
     , product_terms_dim_incl_new_records.gpm_adjustment_percent
     , product_terms_dim_incl_new_records.qualifying_monthly_payment_code
     , product_terms_dim_incl_new_records.qualifying_rate_code
     , product_terms_dim_incl_new_records.qualifying_rate_input_percent
     , product_terms_dim_incl_new_records.ipc_calc_code
     , product_terms_dim_incl_new_records.ipc_limit_percent1
     , product_terms_dim_incl_new_records.ipc_property_usage_code1
     , product_terms_dim_incl_new_records.ipc_comparison_operator_code1
     , product_terms_dim_incl_new_records.ipc_cltv_ratio_percent1
     , product_terms_dim_incl_new_records.ipc_limit_percent2
     , product_terms_dim_incl_new_records.ipc_property_usage_code2
     , product_terms_dim_incl_new_records.ipc_comparison_operator_code2
     , product_terms_dim_incl_new_records.ipc_cltv_ratio_percent2
     , product_terms_dim_incl_new_records.ipc_limit_percent3
     , product_terms_dim_incl_new_records.ipc_property_usage_code3
     , product_terms_dim_incl_new_records.product_terms_pid
     , product_terms_dim_incl_new_records.amortization_term_months
     , product_terms_dim_incl_new_records.arm_index_code
     , product_terms_dim_incl_new_records.arm_payment_adjustment_calculation_code
     , product_terms_dim_incl_new_records.assumable_flag
     , product_terms_dim_incl_new_records.product_category
     , product_terms_dim_incl_new_records.conditions_to_assumability_flag
     , product_terms_dim_incl_new_records.demand_feature_flag
     , product_terms_dim_incl_new_records.due_in_term_months
     , product_terms_dim_incl_new_records.escrow_cushion_months
     , product_terms_dim_incl_new_records.from_date
     , product_terms_dim_incl_new_records.initial_payment_adjustment_term_months
     , product_terms_dim_incl_new_records.initial_rate_adjustment_cap_percent
     , product_terms_dim_incl_new_records.initial_rate_adjustment_term_months
     , product_terms_dim_incl_new_records.lien_priority_code
     , product_terms_dim_incl_new_records.loan_amortization_code
     , product_terms_dim_incl_new_records.minimum_payment_rate_percent
     , product_terms_dim_incl_new_records.minimum_rate_term_months
     , product_terms_dim_incl_new_records.mortgage_type_code
     , product_terms_dim_incl_new_records.negative_amortization_code
     , product_terms_dim_incl_new_records.negative_amortization_limit_percent
     , product_terms_dim_incl_new_records.negative_amortization_recast_period_months
     , product_terms_dim_incl_new_records.payment_adjustment_lifetime_cap_percent
     , product_terms_dim_incl_new_records.payment_adjustment_periodic_cap
     , product_terms_dim_incl_new_records.payment_frequency_code
     , product_terms_dim_incl_new_records.prepayment_charge_refund_flag
     , product_terms_dim_incl_new_records.product_pid
     , product_terms_dim_incl_new_records.rate_adjustment_lifetime_cap_percent
     , product_terms_dim_incl_new_records.subsequent_payment_adjustment_term_months
     , product_terms_dim_incl_new_records.subsequent_rate_adjustment_cap_percent
     , product_terms_dim_incl_new_records.subsequent_rate_adjustment_term_months
     , product_terms_dim_incl_new_records.prepay_penalty_code
     , product_terms_dim_incl_new_records.lender_hazard_insurance_available_flag
     , product_terms_dim_incl_new_records.lender_hazard_insurance_premium_amount
     , product_terms_dim_incl_new_records.lender_hazard_insurance_term_months
     , product_terms_dim_incl_new_records.loan_requires_hazard_insurance_flag
     , product_terms_dim_incl_new_records.arm_convertible_flag
     , product_terms_dim_incl_new_records.arm_convertible_from_month
     , product_terms_dim_incl_new_records.arm_convertible_through_month
     , product_terms_dim_incl_new_records.arm_floor_rate_percent
     , product_terms_dim_incl_new_records.arm_lookback_period_days
     , product_terms_dim_incl_new_records.escrow_waiver_allowed_flag
     , product_terms_dim_incl_new_records.days_per_year_code
     , product_terms_dim_incl_new_records.lp_risk_assessment_accepted_flag
     , product_terms_dim_incl_new_records.du_risk_assessment_accepted_flag
     , product_terms_dim_incl_new_records.internal_underwrite_accepted_flag
     , product_terms_dim_incl_new_records.qualifying_monthly_payment
     , product_terms_dim_incl_new_records.qualifying_rate
     , product_terms_dim_incl_new_records.section_of_act_coarse
     , product_terms_dim_incl_new_records.servicing_transfer
     , product_terms_dim_incl_new_records.third_party_community_second_program_eligibility
     , product_terms_dim_incl_new_records.texas_veterans_land_board
     , product_terms_dim_incl_new_records.high_balance
FROM (
            SELECT ''product_terms_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
            COALESCE(CAST(primary_table.pt_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
             product_terms.*
         FROM history_octane.product_terms
                  LEFT JOIN history_octane.product_terms AS history_records ON product_terms.pt_pid = history_records.pt_pid
             AND product_terms.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.pt_pid IS NULL
     ) AS primary_table

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<arm_index_type_partial_load_condition>> as include_record,
                                 arm_index_type.*
                      FROM history_octane.arm_index_type
                               LEFT JOIN history_octane.arm_index_type AS history_records ON arm_index_type.code = history_records.code
                          AND arm_index_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t715 ON primary_table.pt_arm_index_type = t715.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<buydown_base_date_type_partial_load_condition>> as include_record,
                                 buydown_base_date_type.*
                      FROM history_octane.buydown_base_date_type
                               LEFT JOIN history_octane.buydown_base_date_type AS history_records ON buydown_base_date_type.code = history_records.code
                          AND buydown_base_date_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t717 ON primary_table.pt_buydown_base_date_type = t717.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<buydown_subsidy_calculation_type_partial_load_condition>> as include_record,
                                 buydown_subsidy_calculation_type.*
                      FROM history_octane.buydown_subsidy_calculation_type
                               LEFT JOIN history_octane.buydown_subsidy_calculation_type AS history_records ON buydown_subsidy_calculation_type.code = history_records.code
                          AND buydown_subsidy_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t718 ON primary_table.pt_buydown_subsidy_calculation_type = t718.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<community_lending_type_partial_load_condition>> as include_record,
                                 community_lending_type.*
                      FROM history_octane.community_lending_type
                               LEFT JOIN history_octane.community_lending_type AS history_records ON community_lending_type.code = history_records.code
                          AND community_lending_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t719 ON primary_table.pt_community_lending_type = t719.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<days_per_year_type_partial_load_condition>> as include_record,
                                 days_per_year_type.*
                      FROM history_octane.days_per_year_type
                               LEFT JOIN history_octane.days_per_year_type AS history_records ON days_per_year_type.code = history_records.code
                          AND days_per_year_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t720 ON primary_table.pt_days_per_year_type = t720.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<decision_credit_score_calc_type_partial_load_condition>> as include_record,
                                 decision_credit_score_calc_type.*
                      FROM history_octane.decision_credit_score_calc_type
                               LEFT JOIN history_octane.decision_credit_score_calc_type AS history_records ON decision_credit_score_calc_type.code = history_records.code
                          AND decision_credit_score_calc_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t721 ON primary_table.pt_decision_credit_score_calc_type = t721.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fha_rehab_program_type_partial_load_condition>> as include_record,
                                 fha_rehab_program_type.*
                      FROM history_octane.fha_rehab_program_type
                               LEFT JOIN history_octane.fha_rehab_program_type AS history_records ON fha_rehab_program_type.code = history_records.code
                          AND fha_rehab_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t722 ON primary_table.pt_fha_rehab_program_type = t722.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fha_special_program_type_partial_load_condition>> as include_record,
                                 fha_special_program_type.*
                      FROM history_octane.fha_special_program_type
                               LEFT JOIN history_octane.fha_special_program_type AS history_records ON fha_special_program_type.code = history_records.code
                          AND fha_special_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t723 ON primary_table.pt_fha_special_program_type = t723.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fnm_arm_plan_type_partial_load_condition>> as include_record,
                                 fnm_arm_plan_type.*
                      FROM history_octane.fnm_arm_plan_type
                               LEFT JOIN history_octane.fnm_arm_plan_type AS history_records ON fnm_arm_plan_type.code = history_records.code
                          AND fnm_arm_plan_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t724 ON primary_table.pt_fnm_arm_plan_type = t724.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fnm_community_lending_product_type_partial_load_condition>> as include_record,
                                 fnm_community_lending_product_type.*
                      FROM history_octane.fnm_community_lending_product_type
                               LEFT JOIN history_octane.fnm_community_lending_product_type AS history_records ON fnm_community_lending_product_type.code = history_records.code
                          AND fnm_community_lending_product_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t725 ON primary_table.pt_fnm_community_lending_product_type = t725.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fre_community_program_type_partial_load_condition>> as include_record,
                                 fre_community_program_type.*
                      FROM history_octane.fre_community_program_type
                               LEFT JOIN history_octane.fre_community_program_type AS history_records ON fre_community_program_type.code = history_records.code
                          AND fre_community_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t726 ON primary_table.pt_fre_community_program_type = t726.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<heloc_cancel_fee_applicable_type_partial_load_condition>> as include_record,
                                 heloc_cancel_fee_applicable_type.*
                      FROM history_octane.heloc_cancel_fee_applicable_type
                               LEFT JOIN history_octane.heloc_cancel_fee_applicable_type AS history_records ON heloc_cancel_fee_applicable_type.code = history_records.code
                          AND heloc_cancel_fee_applicable_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t727 ON primary_table.pt_heloc_cancel_fee_applicable_type = t727.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_calc_type_partial_load_condition>> as include_record,
                                 ipc_calc_type.*
                      FROM history_octane.ipc_calc_type
                               LEFT JOIN history_octane.ipc_calc_type AS history_records ON ipc_calc_type.code = history_records.code
                          AND ipc_calc_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t729 ON primary_table.pt_ipc_calc_type = t729.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t732 ON primary_table.pt_ipc_comparison_operator_type3 = t732.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t730 ON primary_table.pt_ipc_comparison_operator_type1 = t730.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t731 ON primary_table.pt_ipc_comparison_operator_type2 = t731.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t733 ON primary_table.pt_ipc_comparison_operator_type4 = t733.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t736 ON primary_table.pt_ipc_property_usage_type3 = t736.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t734 ON primary_table.pt_ipc_property_usage_type1 = t734.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t735 ON primary_table.pt_ipc_property_usage_type2 = t735.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t737 ON primary_table.pt_ipc_property_usage_type4 = t737.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<lien_priority_type_partial_load_condition>> as include_record,
                                 lien_priority_type.*
                      FROM history_octane.lien_priority_type
                               LEFT JOIN history_octane.lien_priority_type AS history_records ON lien_priority_type.code = history_records.code
                          AND lien_priority_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t738 ON primary_table.pt_lien_priority_type = t738.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<loan_amortization_type_partial_load_condition>> as include_record,
                                 loan_amortization_type.*
                      FROM history_octane.loan_amortization_type
                               LEFT JOIN history_octane.loan_amortization_type AS history_records ON loan_amortization_type.code = history_records.code
                          AND loan_amortization_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t739 ON primary_table.pt_loan_amortization_type = t739.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<mortgage_type_partial_load_condition>> as include_record,
                                 mortgage_type.*
                      FROM history_octane.mortgage_type
                               LEFT JOIN history_octane.mortgage_type AS history_records ON mortgage_type.code = history_records.code
                          AND mortgage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t740 ON primary_table.pt_mortgage_type = t740.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<negative_amortization_type_partial_load_condition>> as include_record,
                                 negative_amortization_type.*
                      FROM history_octane.negative_amortization_type
                               LEFT JOIN history_octane.negative_amortization_type AS history_records ON negative_amortization_type.code = history_records.code
                          AND negative_amortization_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t741 ON primary_table.pt_negative_amortization_type = t741.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<partial_payment_policy_type_partial_load_condition>> as include_record,
                                 partial_payment_policy_type.*
                      FROM history_octane.partial_payment_policy_type
                               LEFT JOIN history_octane.partial_payment_policy_type AS history_records ON partial_payment_policy_type.code = history_records.code
                          AND partial_payment_policy_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t742 ON primary_table.pt_partial_payment_policy_type = t742.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<payment_adjustment_calculation_type_partial_load_condition>> as include_record,
                                 payment_adjustment_calculation_type.*
                      FROM history_octane.payment_adjustment_calculation_type
                               LEFT JOIN history_octane.payment_adjustment_calculation_type AS history_records ON payment_adjustment_calculation_type.code = history_records.code
                          AND payment_adjustment_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t716 ON primary_table.pt_arm_payment_adjustment_calculation_type = t716.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<payment_frequency_type_partial_load_condition>> as include_record,
                                 payment_frequency_type.*
                      FROM history_octane.payment_frequency_type
                               LEFT JOIN history_octane.payment_frequency_type AS history_records ON payment_frequency_type.code = history_records.code
                          AND payment_frequency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t743 ON primary_table.pt_payment_frequency_type = t743.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<payment_structure_type_partial_load_condition>> as include_record,
                                 payment_structure_type.*
                      FROM history_octane.payment_structure_type
                               LEFT JOIN history_octane.payment_structure_type AS history_records ON payment_structure_type.code = history_records.code
                          AND payment_structure_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t744 ON primary_table.pt_payment_structure_type = t744.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<prepaid_interest_rate_type_partial_load_condition>> as include_record,
                                 prepaid_interest_rate_type.*
                      FROM history_octane.prepaid_interest_rate_type
                               LEFT JOIN history_octane.prepaid_interest_rate_type AS history_records ON prepaid_interest_rate_type.code = history_records.code
                          AND prepaid_interest_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t745 ON primary_table.pt_prepaid_interest_rate_type = t745.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<prepay_penalty_type_partial_load_condition>> as include_record,
                                 prepay_penalty_type.*
                      FROM history_octane.prepay_penalty_type
                               LEFT JOIN history_octane.prepay_penalty_type AS history_records ON prepay_penalty_type.code = history_records.code
                          AND prepay_penalty_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t746 ON primary_table.pt_prepay_penalty_type = t746.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<product_appraisal_requirement_type_partial_load_condition>> as include_record,
                                 product_appraisal_requirement_type.*
                      FROM history_octane.product_appraisal_requirement_type
                               LEFT JOIN history_octane.product_appraisal_requirement_type AS history_records ON product_appraisal_requirement_type.code = history_records.code
                          AND product_appraisal_requirement_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t747 ON primary_table.pt_product_appraisal_requirement_type = t747.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<product_special_program_type_partial_load_condition>> as include_record,
                                 product_special_program_type.*
                      FROM history_octane.product_special_program_type
                               LEFT JOIN history_octane.product_special_program_type AS history_records ON product_special_program_type.code = history_records.code
                          AND product_special_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t748 ON primary_table.pt_product_special_program_type = t748.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<qualifying_monthly_payment_type_partial_load_condition>> as include_record,
                                 qualifying_monthly_payment_type.*
                      FROM history_octane.qualifying_monthly_payment_type
                               LEFT JOIN history_octane.qualifying_monthly_payment_type AS history_records ON qualifying_monthly_payment_type.code = history_records.code
                          AND qualifying_monthly_payment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t749 ON primary_table.pt_qualifying_monthly_payment_type = t749.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<qualifying_rate_type_partial_load_condition>> as include_record,
                                 qualifying_rate_type.*
                      FROM history_octane.qualifying_rate_type
                               LEFT JOIN history_octane.qualifying_rate_type AS history_records ON qualifying_rate_type.code = history_records.code
                          AND qualifying_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t750 ON primary_table.pt_qualifying_rate_type = t750.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<section_of_act_coarse_type_partial_load_condition>> as include_record,
                                 section_of_act_coarse_type.*
                      FROM history_octane.section_of_act_coarse_type
                               LEFT JOIN history_octane.section_of_act_coarse_type AS history_records ON section_of_act_coarse_type.code = history_records.code
                          AND section_of_act_coarse_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t751 ON primary_table.pt_section_of_act_coarse_type = t751.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<servicing_transfer_type_partial_load_condition>> as include_record,
                                 servicing_transfer_type.*
                      FROM history_octane.servicing_transfer_type
                               LEFT JOIN history_octane.servicing_transfer_type AS history_records ON servicing_transfer_type.code = history_records.code
                          AND servicing_transfer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t752 ON primary_table.pt_servicing_transfer_type = t752.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<third_party_community_second_program_eligibility_type_partial_load_condition>> as include_record,
                                 third_party_community_second_program_eligibility_type.*
                      FROM history_octane.third_party_community_second_program_eligibility_type
                               LEFT JOIN history_octane.third_party_community_second_program_eligibility_type AS history_records ON third_party_community_second_program_eligibility_type.code = history_records.code
                          AND third_party_community_second_program_eligibility_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t754 ON primary_table.pt_third_party_community_second_program_eligibility_type = t754.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
                                 yes_no_unknown_type.*
                      FROM history_octane.yes_no_unknown_type
                               LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t753 ON primary_table.pt_texas_veterans_land_board = t753.code
     -- ignoring this because the table alias t753 has already been added: INNER JOIN history_octane.yes_no_unknown_type t753 ON primary_table.pt_texas_veterans_land_board = t753.code
WHERE
    GREATEST(primary_table.include_record, t715.include_record, t717.include_record, t718.include_record, t719.include_record, t720.include_record, t721.include_record, t722.include_record, t723.include_record, t724.include_record, t725.include_record, t726.include_record, t727.include_record, t729.include_record, t732.include_record, t730.include_record, t731.include_record, t733.include_record, t736.include_record, t734.include_record, t735.include_record, t737.include_record, t738.include_record, t739.include_record, t740.include_record, t741.include_record, t742.include_record, t716.include_record, t743.include_record, t744.include_record, t745.include_record, t746.include_record, t747.include_record, t748.include_record, t749.include_record, t750.include_record, t751.include_record, t752.include_record, t754.include_record, t753.include_record) IS TRUE
ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS product_terms_dim_incl_new_records
    LEFT JOIN star_loan.product_terms_dim ON product_terms_dim_incl_new_records.data_source_integration_id =
                                             product_terms_dim.data_source_integration_id
        AND product_terms_dim_incl_new_records.product_pid IS NOT DISTINCT FROM product_terms_dim.product_pid
        AND product_terms_dim_incl_new_records.amortization_term_months IS NOT DISTINCT FROM product_terms_dim.amortization_term_months
        AND product_terms_dim_incl_new_records.arm_convertible_from_month IS NOT DISTINCT FROM product_terms_dim.arm_convertible_from_month
        AND product_terms_dim_incl_new_records.arm_convertible_through_month IS NOT DISTINCT FROM product_terms_dim.arm_convertible_through_month
        AND product_terms_dim_incl_new_records.arm_floor_rate_percent IS NOT DISTINCT FROM product_terms_dim.arm_floor_rate_percent
        AND product_terms_dim_incl_new_records.arm_index IS NOT DISTINCT FROM product_terms_dim.arm_index
        AND product_terms_dim_incl_new_records.arm_index_code IS NOT DISTINCT FROM product_terms_dim.arm_index_code
        AND product_terms_dim_incl_new_records.arm_lookback_period_days IS NOT DISTINCT FROM product_terms_dim.arm_lookback_period_days
        AND product_terms_dim_incl_new_records.arm_payment_adjustment_calculation IS NOT DISTINCT FROM product_terms_dim.arm_payment_adjustment_calculation
        AND product_terms_dim_incl_new_records.arm_payment_adjustment_calculation_code IS NOT DISTINCT FROM product_terms_dim.arm_payment_adjustment_calculation_code
        AND product_terms_dim_incl_new_records.buydown_base_date IS NOT DISTINCT FROM product_terms_dim.buydown_base_date
        AND product_terms_dim_incl_new_records.buydown_base_date_code IS NOT DISTINCT FROM product_terms_dim.buydown_base_date_code
        AND product_terms_dim_incl_new_records.buydown_subsidy_calculation_code IS NOT DISTINCT FROM product_terms_dim.buydown_subsidy_calculation_code
        AND product_terms_dim_incl_new_records.buydown_subsidy_calculation IS NOT DISTINCT FROM product_terms_dim.buydown_subsidy_calculation
        AND product_terms_dim_incl_new_records.community_lending IS NOT DISTINCT FROM product_terms_dim.community_lending
        AND product_terms_dim_incl_new_records.community_lending_code IS NOT DISTINCT FROM product_terms_dim.community_lending_code
        AND product_terms_dim_incl_new_records.days_per_year IS NOT DISTINCT FROM product_terms_dim.days_per_year
        AND product_terms_dim_incl_new_records.days_per_year_code IS NOT DISTINCT FROM product_terms_dim.days_per_year_code
        AND product_terms_dim_incl_new_records.decision_credit_score_calc IS NOT DISTINCT FROM product_terms_dim.decision_credit_score_calc
        AND product_terms_dim_incl_new_records.decision_credit_score_calc_code IS NOT DISTINCT FROM product_terms_dim.decision_credit_score_calc_code
        AND product_terms_dim_incl_new_records.deed_page_count IS NOT DISTINCT FROM product_terms_dim.deed_page_count
        AND product_terms_dim_incl_new_records.deferred_payment_months IS NOT DISTINCT FROM product_terms_dim.deferred_payment_months
        AND product_terms_dim_incl_new_records.dsi_plan_code IS NOT DISTINCT FROM product_terms_dim.dsi_plan_code
        AND product_terms_dim_incl_new_records.due_in_term_months IS NOT DISTINCT FROM product_terms_dim.due_in_term_months
        AND product_terms_dim_incl_new_records.escrow_cushion_months IS NOT DISTINCT FROM product_terms_dim.escrow_cushion_months
        AND product_terms_dim_incl_new_records.fha_rehab_program IS NOT DISTINCT FROM product_terms_dim.fha_rehab_program
        AND product_terms_dim_incl_new_records.fha_rehab_program_code IS NOT DISTINCT FROM product_terms_dim.fha_rehab_program_code
        AND product_terms_dim_incl_new_records.fha_special_program IS NOT DISTINCT FROM product_terms_dim.fha_special_program
        AND product_terms_dim_incl_new_records.fha_special_program_code IS NOT DISTINCT FROM product_terms_dim.fha_special_program_code
        AND product_terms_dim_incl_new_records.fnm_arm_plan IS NOT DISTINCT FROM product_terms_dim.fnm_arm_plan
        AND product_terms_dim_incl_new_records.fnm_arm_plan_code IS NOT DISTINCT FROM product_terms_dim.fnm_arm_plan_code
        AND product_terms_dim_incl_new_records.fnm_community_lending_product IS NOT DISTINCT FROM product_terms_dim.fnm_community_lending_product
        AND product_terms_dim_incl_new_records.fnm_community_lending_product_code IS NOT DISTINCT FROM product_terms_dim.fnm_community_lending_product_code
        AND product_terms_dim_incl_new_records.fre_community_program IS NOT DISTINCT FROM product_terms_dim.fre_community_program
        AND product_terms_dim_incl_new_records.fre_community_program_code IS NOT DISTINCT FROM product_terms_dim.fre_community_program_code
        AND product_terms_dim_incl_new_records.from_date IS NOT DISTINCT FROM product_terms_dim.from_date
        AND product_terms_dim_incl_new_records.gpm_adjustment_percent IS NOT DISTINCT FROM product_terms_dim.gpm_adjustment_percent
        AND product_terms_dim_incl_new_records.gpm_adjustment_years IS NOT DISTINCT FROM product_terms_dim.gpm_adjustment_years
        AND product_terms_dim_incl_new_records.conditions_to_assumability_flag IS NOT DISTINCT FROM product_terms_dim.conditions_to_assumability_flag
        AND product_terms_dim_incl_new_records.demand_feature_flag IS NOT DISTINCT FROM product_terms_dim.demand_feature_flag
        AND product_terms_dim_incl_new_records.lender_hazard_insurance_available_flag IS NOT DISTINCT FROM product_terms_dim.lender_hazard_insurance_available_flag
        AND product_terms_dim_incl_new_records.prepayment_charge_refund_flag IS NOT DISTINCT FROM product_terms_dim.prepayment_charge_refund_flag
        AND product_terms_dim_incl_new_records.heloc_cancel_fee_amount IS NOT DISTINCT FROM product_terms_dim.heloc_cancel_fee_amount
        AND product_terms_dim_incl_new_records.heloc_cancel_fee_applicable IS NOT DISTINCT FROM product_terms_dim.heloc_cancel_fee_applicable
        AND product_terms_dim_incl_new_records.heloc_cancel_fee_applicable_code IS NOT DISTINCT FROM product_terms_dim.heloc_cancel_fee_applicable_code
        AND product_terms_dim_incl_new_records.heloc_cancel_fee_period_months IS NOT DISTINCT FROM product_terms_dim.heloc_cancel_fee_period_months
        AND product_terms_dim_incl_new_records.heloc_draw_period_months IS NOT DISTINCT FROM product_terms_dim.heloc_draw_period_months
        AND product_terms_dim_incl_new_records.heloc_maximum_initial_draw_amount IS NOT DISTINCT FROM product_terms_dim.heloc_maximum_initial_draw_amount
        AND product_terms_dim_incl_new_records.heloc_minimum_draw_amount IS NOT DISTINCT FROM product_terms_dim.heloc_minimum_draw_amount
        AND product_terms_dim_incl_new_records.heloc_repayment_period_duration_months IS NOT DISTINCT FROM product_terms_dim.heloc_repayment_period_duration_months
        AND product_terms_dim_incl_new_records.high_balance IS NOT DISTINCT FROM product_terms_dim.high_balance
        AND product_terms_dim_incl_new_records.high_balance_code IS NOT DISTINCT FROM product_terms_dim.high_balance_code
        AND product_terms_dim_incl_new_records.initial_payment_adjustment_term_months IS NOT DISTINCT FROM product_terms_dim.initial_payment_adjustment_term_months
        AND product_terms_dim_incl_new_records.initial_rate_adjustment_cap_percent IS NOT DISTINCT FROM product_terms_dim.initial_rate_adjustment_cap_percent
        AND product_terms_dim_incl_new_records.initial_rate_adjustment_term_months IS NOT DISTINCT FROM product_terms_dim.initial_rate_adjustment_term_months
        AND product_terms_dim_incl_new_records.ipc_calc IS NOT DISTINCT FROM product_terms_dim.ipc_calc
        AND product_terms_dim_incl_new_records.ipc_calc_code IS NOT DISTINCT FROM product_terms_dim.ipc_calc_code
        AND product_terms_dim_incl_new_records.ipc_cltv_ratio_percent1 IS NOT DISTINCT FROM product_terms_dim.ipc_cltv_ratio_percent1
        AND product_terms_dim_incl_new_records.ipc_cltv_ratio_percent2 IS NOT DISTINCT FROM product_terms_dim.ipc_cltv_ratio_percent2
        AND product_terms_dim_incl_new_records.ipc_cltv_ratio_percent3 IS NOT DISTINCT FROM product_terms_dim.ipc_cltv_ratio_percent3
        AND product_terms_dim_incl_new_records.ipc_cltv_ratio_percent4 IS NOT DISTINCT FROM product_terms_dim.ipc_cltv_ratio_percent4
        AND product_terms_dim_incl_new_records.ipc_comparison_operator_code1 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator_code1
        AND product_terms_dim_incl_new_records.ipc_comparison_operator_code2 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator_code2
        AND product_terms_dim_incl_new_records.ipc_comparison_operator_code3 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator_code3
        AND product_terms_dim_incl_new_records.ipc_comparison_operator_code4 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator_code4
        AND product_terms_dim_incl_new_records.ipc_comparison_operator1 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator1
        AND product_terms_dim_incl_new_records.ipc_comparison_operator2 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator2
        AND product_terms_dim_incl_new_records.ipc_comparison_operator3 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator3
        AND product_terms_dim_incl_new_records.ipc_comparison_operator4 IS NOT DISTINCT FROM product_terms_dim.ipc_comparison_operator4
        AND product_terms_dim_incl_new_records.ipc_limit_percent1 IS NOT DISTINCT FROM product_terms_dim.ipc_limit_percent1
        AND product_terms_dim_incl_new_records.ipc_limit_percent2 IS NOT DISTINCT FROM product_terms_dim.ipc_limit_percent2
        AND product_terms_dim_incl_new_records.ipc_limit_percent3 IS NOT DISTINCT FROM product_terms_dim.ipc_limit_percent3
        AND product_terms_dim_incl_new_records.ipc_limit_percent4 IS NOT DISTINCT FROM product_terms_dim.ipc_limit_percent4
        AND product_terms_dim_incl_new_records.ipc_property_usage_code1 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage_code1
        AND product_terms_dim_incl_new_records.ipc_property_usage_code2 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage_code2
        AND product_terms_dim_incl_new_records.ipc_property_usage_code3 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage_code3
        AND product_terms_dim_incl_new_records.ipc_property_usage_code4 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage_code4
        AND product_terms_dim_incl_new_records.ipc_property_usage1 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage1
        AND product_terms_dim_incl_new_records.ipc_property_usage2 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage2
        AND product_terms_dim_incl_new_records.ipc_property_usage3 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage3
        AND product_terms_dim_incl_new_records.ipc_property_usage4 IS NOT DISTINCT FROM product_terms_dim.ipc_property_usage4
        AND product_terms_dim_incl_new_records.allow_loan_amount_cents_flag IS NOT DISTINCT FROM product_terms_dim.allow_loan_amount_cents_flag
        AND product_terms_dim_incl_new_records.always_current_market_price_flag IS NOT DISTINCT FROM product_terms_dim.always_current_market_price_flag
        AND product_terms_dim_incl_new_records.arm_convertible_flag IS NOT DISTINCT FROM product_terms_dim.arm_convertible_flag
        AND product_terms_dim_incl_new_records.assumable_flag IS NOT DISTINCT FROM product_terms_dim.assumable_flag
        AND product_terms_dim_incl_new_records.credit_qualifying_flag IS NOT DISTINCT FROM product_terms_dim.credit_qualifying_flag
        AND product_terms_dim_incl_new_records.du_risk_assessment_accepted_flag IS NOT DISTINCT FROM product_terms_dim.du_risk_assessment_accepted_flag
        AND product_terms_dim_incl_new_records.escrow_waiver_allowed_flag IS NOT DISTINCT FROM product_terms_dim.escrow_waiver_allowed_flag
        AND product_terms_dim_incl_new_records.external_fha_underwrite_accepted_flag IS NOT DISTINCT FROM product_terms_dim.external_fha_underwrite_accepted_flag
        AND product_terms_dim_incl_new_records.external_investor_underwrite_accepted_flag IS NOT DISTINCT FROM product_terms_dim.external_investor_underwrite_accepted_flag
        AND product_terms_dim_incl_new_records.external_usda_underwrite_accepted_flag IS NOT DISTINCT FROM product_terms_dim.external_usda_underwrite_accepted_flag
        AND product_terms_dim_incl_new_records.external_va_underwrite_accepted_flag IS NOT DISTINCT FROM product_terms_dim.external_va_underwrite_accepted_flag
        AND product_terms_dim_incl_new_records.family_advantage_flag IS NOT DISTINCT FROM product_terms_dim.family_advantage_flag
        AND product_terms_dim_incl_new_records.heloc_maximum_initial_draw_flag IS NOT DISTINCT FROM product_terms_dim.heloc_maximum_initial_draw_flag
        AND product_terms_dim_incl_new_records.heloc_minimum_draw_flag IS NOT DISTINCT FROM product_terms_dim.heloc_minimum_draw_flag
        AND product_terms_dim_incl_new_records.internal_underwrite_accepted_flag IS NOT DISTINCT FROM product_terms_dim.internal_underwrite_accepted_flag
        AND product_terms_dim_incl_new_records.loan_requires_hazard_insurance_flag IS NOT DISTINCT FROM product_terms_dim.loan_requires_hazard_insurance_flag
        AND product_terms_dim_incl_new_records.lp_risk_assessment_accepted_flag IS NOT DISTINCT FROM product_terms_dim.lp_risk_assessment_accepted_flag
        AND product_terms_dim_incl_new_records.manual_risk_assessment_accepted_flag IS NOT DISTINCT FROM product_terms_dim.manual_risk_assessment_accepted_flag
        AND product_terms_dim_incl_new_records.mortgage_credit_certificate_eligible_flag IS NOT DISTINCT FROM product_terms_dim.mortgage_credit_certificate_eligible_flag
        AND product_terms_dim_incl_new_records.new_york_flag IS NOT DISTINCT FROM product_terms_dim.new_york_flag
        AND product_terms_dim_incl_new_records.no_mi_product_flag IS NOT DISTINCT FROM product_terms_dim.no_mi_product_flag
        AND product_terms_dim_incl_new_records.non_conforming_flag IS NOT DISTINCT FROM product_terms_dim.non_conforming_flag
        AND product_terms_dim_incl_new_records.rate_protect_flag IS NOT DISTINCT FROM product_terms_dim.rate_protect_flag
        AND product_terms_dim_incl_new_records.texas_veterans_land_board IS NOT DISTINCT FROM product_terms_dim.texas_veterans_land_board
        AND product_terms_dim_incl_new_records.texas_veterans_land_board_code IS NOT DISTINCT FROM product_terms_dim.texas_veterans_land_board_code
        AND product_terms_dim_incl_new_records.third_party_grant_eligible_flag IS NOT DISTINCT FROM product_terms_dim.third_party_grant_eligible_flag
        AND product_terms_dim_incl_new_records.zero_note_rate_flag IS NOT DISTINCT FROM product_terms_dim.zero_note_rate_flag
        AND product_terms_dim_incl_new_records.lender_hazard_insurance_premium_amount IS NOT DISTINCT FROM product_terms_dim.lender_hazard_insurance_premium_amount
        AND product_terms_dim_incl_new_records.lender_hazard_insurance_term_months IS NOT DISTINCT FROM product_terms_dim.lender_hazard_insurance_term_months
        AND product_terms_dim_incl_new_records.lien_priority IS NOT DISTINCT FROM product_terms_dim.lien_priority
        AND product_terms_dim_incl_new_records.lien_priority_code IS NOT DISTINCT FROM product_terms_dim.lien_priority_code
        AND product_terms_dim_incl_new_records.loan_amortization IS NOT DISTINCT FROM product_terms_dim.loan_amortization
        AND product_terms_dim_incl_new_records.loan_amortization_code IS NOT DISTINCT FROM product_terms_dim.loan_amortization_code
        AND product_terms_dim_incl_new_records.minimum_payment_rate_percent IS NOT DISTINCT FROM product_terms_dim.minimum_payment_rate_percent
        AND product_terms_dim_incl_new_records.minimum_rate_term_months IS NOT DISTINCT FROM product_terms_dim.minimum_rate_term_months
        AND product_terms_dim_incl_new_records.mortgage_type IS NOT DISTINCT FROM product_terms_dim.mortgage_type
        AND product_terms_dim_incl_new_records.mortgage_type_code IS NOT DISTINCT FROM product_terms_dim.mortgage_type_code
        AND product_terms_dim_incl_new_records.negative_amortization IS NOT DISTINCT FROM product_terms_dim.negative_amortization
        AND product_terms_dim_incl_new_records.negative_amortization_code IS NOT DISTINCT FROM product_terms_dim.negative_amortization_code
        AND product_terms_dim_incl_new_records.negative_amortization_limit_percent IS NOT DISTINCT FROM product_terms_dim.negative_amortization_limit_percent
        AND product_terms_dim_incl_new_records.negative_amortization_recast_period_months IS NOT DISTINCT FROM product_terms_dim.negative_amortization_recast_period_months
        AND product_terms_dim_incl_new_records.partial_payment_policy IS NOT DISTINCT FROM product_terms_dim.partial_payment_policy
        AND product_terms_dim_incl_new_records.partial_payment_policy_code IS NOT DISTINCT FROM product_terms_dim.partial_payment_policy_code
        AND product_terms_dim_incl_new_records.payment_adjustment_lifetime_cap_percent IS NOT DISTINCT FROM product_terms_dim.payment_adjustment_lifetime_cap_percent
        AND product_terms_dim_incl_new_records.payment_adjustment_periodic_cap IS NOT DISTINCT FROM product_terms_dim.payment_adjustment_periodic_cap
        AND product_terms_dim_incl_new_records.payment_frequency IS NOT DISTINCT FROM product_terms_dim.payment_frequency
        AND product_terms_dim_incl_new_records.payment_frequency_code IS NOT DISTINCT FROM product_terms_dim.payment_frequency_code
        AND product_terms_dim_incl_new_records.payment_structure IS NOT DISTINCT FROM product_terms_dim.payment_structure
        AND product_terms_dim_incl_new_records.payment_structure_code IS NOT DISTINCT FROM product_terms_dim.payment_structure_code
        AND product_terms_dim_incl_new_records.prepaid_interest_rate IS NOT DISTINCT FROM product_terms_dim.prepaid_interest_rate
        AND product_terms_dim_incl_new_records.prepaid_interest_rate_code IS NOT DISTINCT FROM product_terms_dim.prepaid_interest_rate_code
        AND product_terms_dim_incl_new_records.prepay_penalty IS NOT DISTINCT FROM product_terms_dim.prepay_penalty
        AND product_terms_dim_incl_new_records.prepay_penalty_code IS NOT DISTINCT FROM product_terms_dim.prepay_penalty_code
        AND product_terms_dim_incl_new_records.product_appraisal_requirement IS NOT DISTINCT FROM product_terms_dim.product_appraisal_requirement
        AND product_terms_dim_incl_new_records.product_appraisal_requirement_code IS NOT DISTINCT FROM product_terms_dim.product_appraisal_requirement_code
        AND product_terms_dim_incl_new_records.product_category IS NOT DISTINCT FROM product_terms_dim.product_category
        AND product_terms_dim_incl_new_records.product_special_program IS NOT DISTINCT FROM product_terms_dim.product_special_program
        AND product_terms_dim_incl_new_records.product_special_program_code IS NOT DISTINCT FROM product_terms_dim.product_special_program_code
        AND product_terms_dim_incl_new_records.qualifying_monthly_payment IS NOT DISTINCT FROM product_terms_dim.qualifying_monthly_payment
        AND product_terms_dim_incl_new_records.qualifying_monthly_payment_code IS NOT DISTINCT FROM product_terms_dim.qualifying_monthly_payment_code
        AND product_terms_dim_incl_new_records.qualifying_rate IS NOT DISTINCT FROM product_terms_dim.qualifying_rate
        AND product_terms_dim_incl_new_records.qualifying_rate_code IS NOT DISTINCT FROM product_terms_dim.qualifying_rate_code
        AND product_terms_dim_incl_new_records.qualifying_rate_input_percent IS NOT DISTINCT FROM product_terms_dim.qualifying_rate_input_percent
        AND product_terms_dim_incl_new_records.rate_adjustment_lifetime_cap_percent IS NOT DISTINCT FROM product_terms_dim.rate_adjustment_lifetime_cap_percent
        AND product_terms_dim_incl_new_records.section_of_act_coarse IS NOT DISTINCT FROM product_terms_dim.section_of_act_coarse
        AND product_terms_dim_incl_new_records.section_of_act_coarse_code IS NOT DISTINCT FROM product_terms_dim.section_of_act_coarse_code
        AND product_terms_dim_incl_new_records.security_instrument_page_count IS NOT DISTINCT FROM product_terms_dim.security_instrument_page_count
        AND product_terms_dim_incl_new_records.servicing_transfer IS NOT DISTINCT FROM product_terms_dim.servicing_transfer
        AND product_terms_dim_incl_new_records.servicing_transfer_code IS NOT DISTINCT FROM product_terms_dim.servicing_transfer_code
        AND product_terms_dim_incl_new_records.subsequent_payment_adjustment_term_months IS NOT DISTINCT FROM product_terms_dim.subsequent_payment_adjustment_term_months
        AND product_terms_dim_incl_new_records.subsequent_rate_adjustment_cap_percent IS NOT DISTINCT FROM product_terms_dim.subsequent_rate_adjustment_cap_percent
        AND product_terms_dim_incl_new_records.subsequent_rate_adjustment_term_months IS NOT DISTINCT FROM product_terms_dim.subsequent_rate_adjustment_term_months
        AND product_terms_dim_incl_new_records.third_party_community_second_program_eligibility IS NOT DISTINCT FROM product_terms_dim.third_party_community_second_program_eligibility
        AND product_terms_dim_incl_new_records.third_party_community_second_program_eligibility_code IS NOT DISTINCT FROM product_terms_dim.third_party_community_second_program_eligibility_code
WHERE product_terms_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'product_terms_dim'
        );


-- transaction_dim
UPDATE mdi.table_input_step
    SET sql = 'SELECT transaction_dim_incl_new_records.data_source_integration_columns
     , transaction_dim_incl_new_records.data_source_integration_id
     , transaction_dim_incl_new_records.edw_created_datetime
     , transaction_dim_incl_new_records.edw_modified_datetime
     , transaction_dim_incl_new_records.data_source_modified_datetime
     , transaction_dim_incl_new_records.deal_pid
     , transaction_dim_incl_new_records.active_proposal_pid
FROM (
SELECT  ''deal_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(t1441.d_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t1441.d_pid as deal_pid,
        primary_table.prp_pid as active_proposal_pid
FROM (
         SELECT
             <<proposal_partial_load_condition>> as include_record,
             proposal.*
         FROM history_octane.proposal
                  LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
             AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.prp_pid IS NULL
     ) AS primary_table

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<deal_partial_load_condition>> as include_record,
                                 deal.*
                      FROM history_octane.deal
                               LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
                          AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.d_pid IS NULL
                  ) as primary_table

) AS t1441 ON primary_table.prp_pid = t1441.d_active_proposal_pid
WHERE
    GREATEST(primary_table.include_record, t1441.include_record) IS TRUE
ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS transaction_dim_incl_new_records
    LEFT JOIN star_loan.transaction_dim ON transaction_dim_incl_new_records.data_source_integration_id =
                                           transaction_dim.data_source_integration_id
        AND transaction_dim_incl_new_records.deal_pid IS NOT DISTINCT FROM transaction_dim.deal_pid
        AND transaction_dim_incl_new_records.active_proposal_pid IS NOT DISTINCT FROM transaction_dim.active_proposal_pid
WHERE transaction_dim.dwid IS NULL;'
    WHERE process_dwid = (
        SELECT process.dwid
        FROM mdi.process
            JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                AND insert_update_step.table_name = 'transaction_dim'
        );
