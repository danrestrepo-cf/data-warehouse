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
