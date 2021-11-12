--
-- Main | EDW - Octane schemas from prod-release to V2021.11.2.1 on uat
-- https://app.asana.com/0/0/1201362050225727
--

-- Insert metadata for new tables: company_license_contact
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'company_license_contact', NULL)
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
   , new_fields (schema_name, table_name, field_name, data_type, field_order) AS (
    VALUES ('staging_octane', 'company_license_contact', 'cmlc_pid', 'BIGINT', NULL)
         , ('staging_octane', 'company_license_contact', 'cmlc_version', 'INTEGER', NULL)
         , ('staging_octane', 'company_license_contact', 'cmlc_lender_user_pid', 'BIGINT', NULL)
         , ('staging_octane', 'company_license_contact', 'cmlc_company_license_pid', 'BIGINT', NULL)
         , ('staging_octane', 'company_license_contact', 'cmlc_from_date', 'DATE', NULL)
         , ('staging_octane', 'company_license_contact', 'cmlc_through_date', 'DATE', NULL)
         , ('history_octane', 'company_license_contact', 'cmlc_pid', 'BIGINT', 1)
         , ('history_octane', 'company_license_contact', 'cmlc_version', 'INTEGER', 2)
         , ('history_octane', 'company_license_contact', 'cmlc_lender_user_pid', 'BIGINT', 3)
         , ('history_octane', 'company_license_contact', 'cmlc_company_license_pid', 'BIGINT', 4)
         , ('history_octane', 'company_license_contact', 'cmlc_from_date', 'DATE', 5)
         , ('history_octane', 'company_license_contact', 'cmlc_through_date', 'DATE', 6)
         , ('history_octane', 'company_license_contact', 'data_source_updated_datetime', 'TIMESTAMPTZ', 7)
         , ('history_octane', 'company_license_contact', 'data_source_deleted_flag', 'BOOLEAN', 8)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag)
        SELECT new_staging_table_definitions.dwid, new_fields.field_name, new_fields.data_type, FALSE
        FROM new_fields
        JOIN new_staging_table_definitions
             ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid
             , new_fields.field_name
             , new_fields.data_type
             , FALSE
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
    VALUES ('SP-100870', 'company_license_contact', 'cmlc_pid', '--finding records to insert into history_octane.company_license_contact
SELECT staging_table.cmlc_pid
     , staging_table.cmlc_version
     , staging_table.cmlc_lender_user_pid
     , staging_table.cmlc_company_license_pid
     , staging_table.cmlc_from_date
     , staging_table.cmlc_through_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.company_license_contact staging_table
LEFT JOIN history_octane.company_license_contact history_table
          ON staging_table.cmlc_pid = history_table.cmlc_pid
              AND staging_table.cmlc_version = history_table.cmlc_version
WHERE history_table.cmlc_pid IS NULL
UNION ALL
SELECT history_table.cmlc_pid
     , history_table.cmlc_version + 1
     , history_table.cmlc_lender_user_pid
     , history_table.cmlc_company_license_pid
     , history_table.cmlc_from_date
     , history_table.cmlc_through_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.company_license_contact history_table
LEFT JOIN staging_octane.company_license_contact staging_table
          ON staging_table.cmlc_pid = history_table.cmlc_pid
WHERE staging_table.cmlc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.company_license_contact deleted_records
    WHERE deleted_records.cmlc_pid = history_table.cmlc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
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
SELECT 'Finished inserting metadata for new tables.';

--add new join definitions for new table: company_license_contact
WITH insert_rows (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name,
                  target_table_name, join_condition) AS (
    VALUES ('staging', 'history_octane', 'company_license_contact', 'staging', 'history_octane', 'lender_user', 'primary_table.cmlc_lender_user_pid = target_table.lu_pid')
         , ('staging', 'history_octane', 'company_license_contact', 'staging', 'history_octane', 'company_license', 'primary_table.cmlc_company_license_pid = target_table.cml_pid')
)
INSERT
INTO mdi.edw_join_definition (dwid, primary_edw_table_definition_dwid, target_edw_table_definition_dwid, join_type, join_condition)
SELECT NEXTVAL( 'mdi.edw_join_definition_dwid_seq' )
     , primary_table.dwid
     , target_table.dwid
     , 'left'
     , REPLACE( insert_rows.join_condition, 'target_table', 't' || CURRVAL( 'mdi.edw_join_definition_dwid_seq' ) )
FROM insert_rows
JOIN mdi.edw_table_definition primary_table
     ON insert_rows.primary_database_name = primary_table.database_name
         AND insert_rows.primary_schema_name = primary_table.schema_name
         AND insert_rows.primary_table_name = primary_table.table_name
JOIN mdi.edw_table_definition target_table
     ON insert_rows.target_database_name = target_table.database_name
         AND insert_rows.target_schema_name = target_table.schema_name
         AND insert_rows.target_table_name = target_table.table_name;
/*
Insert metadata for new columns:
- lender_user.lu_marketing_details_enabled
- lender_user.lu_marketing_details_featured_review
- proposal.prp_proposed_additional_monthly_payment
- proposal.prp_term_borrower_intends_to_retain_property
- proposal_construction.prpc_contingency_reserve_required
- lender_user_location.luloc_current_physical_location
- lender_user_location.luloc_current_license_location
- lender_user_location.luloc_synthetic_unique_current_physical_location
- lender_user_location.luloc_synthetic_unique_current_license_location
*/
WITH new_fields (table_name, field_name, data_type, field_order) AS (
    VALUES ('lender_user', 'lu_marketing_details_enabled', 'BOOLEAN', 63)
         , ('lender_user', 'lu_marketing_details_featured_review', 'VARCHAR(1024)', 64)
         , ('proposal', 'prp_proposed_additional_monthly_payment', 'NUMERIC(17,2)', 243)
         , ('proposal', 'prp_term_borrower_intends_to_retain_property', 'INTEGER', 244)
         , ('proposal_construction', 'prpc_contingency_reserve_required', 'BOOLEAN', 19)
         , ('lender_user_location', 'luloc_current_physical_location', 'BOOLEAN', 12)
         , ('lender_user_location', 'luloc_current_license_location', 'BOOLEAN', 13)
         , ('lender_user_location', 'luloc_synthetic_unique_current_physical_location', 'BOOLEAN', 14)
         , ('lender_user_location', 'luloc_synthetic_unique_current_license_location', 'BOOLEAN', 15)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , new_fields.data_type
             , FALSE
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'staging_octane'
                 AND new_fields.table_name = edw_table_definition.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , new_fields.data_type
             , FALSE
             , new_staging_field_definitions.dwid
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'history_octane'
                 AND new_fields.table_name = edw_table_definition.table_name
        JOIN mdi.edw_table_definition AS source_table_definition
             ON source_table_definition.schema_name = 'staging_octane'
                 AND source_table_definition.table_name = new_fields.table_name
        JOIN new_staging_field_definitions
             ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
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
        JOIN mdi.table_output_step
             ON table_output_step.target_schema = 'history_octane'
                 AND table_output_step.target_table = new_fields.table_name
)
SELECT 'Finished inserting metadata for new columns.';

/*
Remove metadata for deleted fields:
 - proposal_req.prpr_decision_status_reason
 - proposal_req.prpr_fulfill_status_reason
*/

WITH deleted_fields (table_name, field_name) AS (
    VALUES ('proposal_req', 'prpr_decision_status_reason')
         , ('proposal_req', 'prpr_fulfill_status_reason')
)
   , delete_table_output_fields AS (
    DELETE
        FROM mdi.table_output_field
            USING mdi.table_output_step, deleted_fields
            WHERE table_output_field.table_output_step_dwid = table_output_step.dwid
                AND table_output_field.database_field_name = deleted_fields.field_name
                AND table_output_step.target_table = deleted_fields.table_name
)
   , nullify_history_field_sources AS (
    UPDATE mdi.edw_field_definition
        SET source_edw_field_definition_dwid = NULL
        FROM mdi.edw_table_definition
            JOIN deleted_fields
            ON edw_table_definition.table_name = deleted_fields.table_name
                AND edw_table_definition.schema_name = 'history_octane'
        WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
            AND edw_field_definition.field_name = deleted_fields.field_name
)
   , delete_staging_field_definitions AS (
    DELETE
        FROM mdi.edw_field_definition
            USING mdi.edw_table_definition, deleted_fields
            WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
                AND edw_field_definition.field_name = deleted_fields.field_name
                AND edw_table_definition.table_name = deleted_fields.table_name
                AND edw_table_definition.schema_name = 'staging_octane'
)
SELECT 'Finished removing metadata for deleted fields.';


--update table_input_step SQL for updated tables: lender_user, proposal, proposal_construction, lender_user_location, proposal_req
WITH updated_table_input_sql (table_name, sql) AS (
    VALUES ('lender_user', '--finding records to insert into history_octane.lender_user
SELECT staging_table.lu_pid
     , staging_table.lu_version
     , staging_table.lu_branch_pid
     , staging_table.lu_account_owner
     , staging_table.lu_account_pid
     , staging_table.lu_create_date
     , staging_table.lu_first_name
     , staging_table.lu_last_name
     , staging_table.lu_middle_name
     , staging_table.lu_name_suffix
     , staging_table.lu_company_name
     , staging_table.lu_title
     , staging_table.lu_office_phone
     , staging_table.lu_office_phone_extension
     , staging_table.lu_email
     , staging_table.lu_fax
     , staging_table.lu_city
     , staging_table.lu_country
     , staging_table.lu_postal_code
     , staging_table.lu_state
     , staging_table.lu_street1
     , staging_table.lu_street2
     , staging_table.lu_office_phone_use_branch
     , staging_table.lu_fax_use_branch
     , staging_table.lu_address_use_branch
     , staging_table.lu_start_date
     , staging_table.lu_through_date
     , staging_table.lu_time_zone
     , staging_table.lu_unparsed_name
     , staging_table.lu_lender_user_status_type
     , staging_table.lu_username
     , staging_table.lu_nmls_loan_originator_id
     , staging_table.lu_fha_chums_id
     , staging_table.lu_va_agent_id
     , staging_table.lu_search_text
     , staging_table.lu_company_user_id
     , staging_table.lu_force_password_change
     , staging_table.lu_last_password_change_date
     , staging_table.lu_challenge_question_type
     , staging_table.lu_challenge_question_answer
     , staging_table.lu_allow_external_ip
     , staging_table.lu_total_workload_cap
     , staging_table.lu_schedule_once_booking_page_id
     , staging_table.lu_performer_team_pid
     , staging_table.lu_esign_only
     , staging_table.lu_work_step_start_notices_enabled
     , staging_table.lu_smart_app_enabled
     , staging_table.lu_default_lead_source_pid
     , staging_table.lu_default_credit_bureau_type
     , staging_table.lu_originator_id
     , staging_table.lu_name_qualifier
     , staging_table.lu_training_mode
     , staging_table.lu_about_me
     , staging_table.lu_lender_user_type
     , staging_table.lu_hire_date
     , staging_table.lu_mercury_client_group_pid
     , staging_table.lu_nickname
     , staging_table.lu_preferred_first_name
     , staging_table.lu_hub_directory
     , staging_table.lu_email_signature_title
     , staging_table.lu_termination_date
     , staging_table.lu_marketing_details_enabled
     , staging_table.lu_marketing_details_featured_review
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user staging_table
LEFT JOIN history_octane.lender_user history_table
          ON staging_table.lu_pid = history_table.lu_pid
              AND staging_table.lu_version = history_table.lu_version
WHERE history_table.lu_pid IS NULL
UNION ALL
SELECT history_table.lu_pid
     , history_table.lu_version + 1
     , history_table.lu_branch_pid
     , history_table.lu_account_owner
     , history_table.lu_account_pid
     , history_table.lu_create_date
     , history_table.lu_first_name
     , history_table.lu_last_name
     , history_table.lu_middle_name
     , history_table.lu_name_suffix
     , history_table.lu_company_name
     , history_table.lu_title
     , history_table.lu_office_phone
     , history_table.lu_office_phone_extension
     , history_table.lu_email
     , history_table.lu_fax
     , history_table.lu_city
     , history_table.lu_country
     , history_table.lu_postal_code
     , history_table.lu_state
     , history_table.lu_street1
     , history_table.lu_street2
     , history_table.lu_office_phone_use_branch
     , history_table.lu_fax_use_branch
     , history_table.lu_address_use_branch
     , history_table.lu_start_date
     , history_table.lu_through_date
     , history_table.lu_time_zone
     , history_table.lu_unparsed_name
     , history_table.lu_lender_user_status_type
     , history_table.lu_username
     , history_table.lu_nmls_loan_originator_id
     , history_table.lu_fha_chums_id
     , history_table.lu_va_agent_id
     , history_table.lu_search_text
     , history_table.lu_company_user_id
     , history_table.lu_force_password_change
     , history_table.lu_last_password_change_date
     , history_table.lu_challenge_question_type
     , history_table.lu_challenge_question_answer
     , history_table.lu_allow_external_ip
     , history_table.lu_total_workload_cap
     , history_table.lu_schedule_once_booking_page_id
     , history_table.lu_performer_team_pid
     , history_table.lu_esign_only
     , history_table.lu_work_step_start_notices_enabled
     , history_table.lu_smart_app_enabled
     , history_table.lu_default_lead_source_pid
     , history_table.lu_default_credit_bureau_type
     , history_table.lu_originator_id
     , history_table.lu_name_qualifier
     , history_table.lu_training_mode
     , history_table.lu_about_me
     , history_table.lu_lender_user_type
     , history_table.lu_hire_date
     , history_table.lu_mercury_client_group_pid
     , history_table.lu_nickname
     , history_table.lu_preferred_first_name
     , history_table.lu_hub_directory
     , history_table.lu_email_signature_title
     , history_table.lu_termination_date
     , history_table.lu_marketing_details_enabled
     , history_table.lu_marketing_details_featured_review
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_user history_table
LEFT JOIN staging_octane.lender_user staging_table
          ON staging_table.lu_pid = history_table.lu_pid
WHERE staging_table.lu_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_user deleted_records
    WHERE deleted_records.lu_pid = history_table.lu_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
         , ('proposal', '--finding records to insert into history_octane.proposal
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
     , staging_table.prp_hud_consultant
     , staging_table.prp_disclosure_action_type
     , staging_table.prp_financed_property_improvements
     , staging_table.prp_estimated_hard_construction_cost_amount
     , staging_table.prp_initial_uw_disposition_datetime
     , staging_table.prp_preapproval_uw_submit_datetime
     , staging_table.prp_preapproval_uw_disposition_datetime
     , staging_table.prp_down_payment_percent
     , staging_table.prp_cash_out_reason_investment_or_business_property
     , staging_table.prp_cash_out_reason_business_debt_or_debt_consolidation
     , staging_table.prp_non_business_cash_out_reason_acknowledged
     , staging_table.prp_va_energy_efficient_improvements_amount
     , staging_table.prp_proposed_additional_monthly_payment
     , staging_table.prp_term_borrower_intends_to_retain_property
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid
              AND staging_table.prp_version = history_table.prp_version
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
     , history_table.prp_hud_consultant
     , history_table.prp_disclosure_action_type
     , history_table.prp_financed_property_improvements
     , history_table.prp_estimated_hard_construction_cost_amount
     , history_table.prp_initial_uw_disposition_datetime
     , history_table.prp_preapproval_uw_submit_datetime
     , history_table.prp_preapproval_uw_disposition_datetime
     , history_table.prp_down_payment_percent
     , history_table.prp_cash_out_reason_investment_or_business_property
     , history_table.prp_cash_out_reason_business_debt_or_debt_consolidation
     , history_table.prp_non_business_cash_out_reason_acknowledged
     , history_table.prp_va_energy_efficient_improvements_amount
     , history_table.prp_proposed_additional_monthly_payment
     , history_table.prp_term_borrower_intends_to_retain_property
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal deleted_records
    WHERE deleted_records.prp_pid = history_table.prp_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
         , ('proposal_construction', '--finding records to insert into history_octane.proposal_construction
SELECT staging_table.prpc_pid
     , staging_table.prpc_version
     , staging_table.prpc_proposal_pid
     , staging_table.prpc_architectural_exhibits
     , staging_table.prpc_feasibility_study
     , staging_table.prpc_expected_months_to_complete
     , staging_table.prpc_extension_needed
     , staging_table.prpc_extension_period_months
     , staging_table.prpc_any_utilities_inoperable
     , staging_table.prpc_non_habitable_months
     , staging_table.prpc_non_habitable_units
     , staging_table.prpc_number_of_draws
     , staging_table.prpc_construction_confirmed_start_date
     , staging_table.prpc_loan_in_process_account_closed_date
     , staging_table.prpc_mortgage_payment_reserves_required
     , staging_table.prpc_estimated_permit_amount_applicable
     , staging_table.prpc_contingency_reserve_required
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_construction staging_table
LEFT JOIN history_octane.proposal_construction history_table
          ON staging_table.prpc_pid = history_table.prpc_pid
              AND staging_table.prpc_version = history_table.prpc_version
WHERE history_table.prpc_pid IS NULL
UNION ALL
SELECT history_table.prpc_pid
     , history_table.prpc_version + 1
     , history_table.prpc_proposal_pid
     , history_table.prpc_architectural_exhibits
     , history_table.prpc_feasibility_study
     , history_table.prpc_expected_months_to_complete
     , history_table.prpc_extension_needed
     , history_table.prpc_extension_period_months
     , history_table.prpc_any_utilities_inoperable
     , history_table.prpc_non_habitable_months
     , history_table.prpc_non_habitable_units
     , history_table.prpc_number_of_draws
     , history_table.prpc_construction_confirmed_start_date
     , history_table.prpc_loan_in_process_account_closed_date
     , history_table.prpc_mortgage_payment_reserves_required
     , history_table.prpc_estimated_permit_amount_applicable
     , history_table.prpc_contingency_reserve_required
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_construction history_table
LEFT JOIN staging_octane.proposal_construction staging_table
          ON staging_table.prpc_pid = history_table.prpc_pid
WHERE staging_table.prpc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_construction deleted_records
    WHERE deleted_records.prpc_pid = history_table.prpc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
         , ('lender_user_location', '--finding records to insert into history_octane.lender_user_location
SELECT staging_table.luloc_pid
     , staging_table.luloc_version
     , staging_table.luloc_company_pid
     , staging_table.luloc_lender_user_pid
     , staging_table.luloc_location_pid
     , staging_table.luloc_from_date
     , staging_table.luloc_lender_user_location_type
     , staging_table.luloc_workspace_type
     , staging_table.luloc_workspace_code
     , staging_table.luloc_current_physical_location
     , staging_table.luloc_current_license_location
     , staging_table.luloc_synthetic_unique_current_physical_location
     , staging_table.luloc_synthetic_unique_current_license_location
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user_location staging_table
LEFT JOIN history_octane.lender_user_location history_table
          ON staging_table.luloc_pid = history_table.luloc_pid
              AND staging_table.luloc_version = history_table.luloc_version
WHERE history_table.luloc_pid IS NULL
UNION ALL
SELECT history_table.luloc_pid
     , history_table.luloc_version + 1
     , history_table.luloc_company_pid
     , history_table.luloc_lender_user_pid
     , history_table.luloc_location_pid
     , history_table.luloc_from_date
     , history_table.luloc_lender_user_location_type
     , history_table.luloc_workspace_type
     , history_table.luloc_workspace_code
     , history_table.luloc_current_physical_location
     , history_table.luloc_current_license_location
     , history_table.luloc_synthetic_unique_current_physical_location
     , history_table.luloc_synthetic_unique_current_license_location
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_user_location history_table
LEFT JOIN staging_octane.lender_user_location staging_table
          ON staging_table.luloc_pid = history_table.luloc_pid
WHERE staging_table.luloc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_user_location deleted_records
    WHERE deleted_records.luloc_pid = history_table.luloc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
         , ('proposal_req', '--finding records to insert into history_octane.proposal_req
SELECT staging_table.prpr_pid
     , staging_table.prpr_version
     , staging_table.prpr_proposal_doc_pid
     , staging_table.prpr_req_name
     , staging_table.prpr_borrower_access
     , staging_table.prpr_req_id
     , staging_table.prpr_req_fulfill_status_type
     , staging_table.prpr_fulfill_status_unparsed_name
     , staging_table.prpr_fulfill_status_datetime
     , staging_table.prpr_req_decision_status_type
     , staging_table.prpr_decision_status_unparsed_name
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
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_req staging_table
LEFT JOIN history_octane.proposal_req history_table
          ON staging_table.prpr_pid = history_table.prpr_pid
              AND staging_table.prpr_version = history_table.prpr_version
WHERE history_table.prpr_pid IS NULL
UNION ALL
SELECT history_table.prpr_pid
     , history_table.prpr_version + 1
     , history_table.prpr_proposal_doc_pid
     , history_table.prpr_req_name
     , history_table.prpr_borrower_access
     , history_table.prpr_req_id
     , history_table.prpr_req_fulfill_status_type
     , history_table.prpr_fulfill_status_unparsed_name
     , history_table.prpr_fulfill_status_datetime
     , history_table.prpr_req_decision_status_type
     , history_table.prpr_decision_status_unparsed_name
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
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_req history_table
LEFT JOIN staging_octane.proposal_req staging_table
          ON staging_table.prpr_pid = history_table.prpr_pid
WHERE staging_table.prpr_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_req deleted_records
    WHERE deleted_records.prpr_pid = history_table.prpr_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
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
SELECT 'Finished updated table_input_step SQL for updated tables.'
