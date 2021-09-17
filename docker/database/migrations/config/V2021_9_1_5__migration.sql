--
-- Main | EDW - Octane schemas from prod-release to v2021.9.3.2 on uat
-- https://app.asana.com/0/0/1200992742622198
--

-- Insert metadata for new tables: deal_note_category_type, doc_status_type, proposal_doc_new
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'deal_note_category_type', NULL)
            , ('staging', 'staging_octane', 'doc_status_type', NULL)
            , ('staging', 'staging_octane', 'proposal_doc_new', NULL)
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
    VALUES
        -- staging_octane.deal_note_category_type
        ('staging_octane', 'deal_note_category_type', 'code', TRUE, NULL)
        , ('staging_octane', 'deal_note_category_type', 'value', FALSE, NULL)
         -- history_octane.deal_note_category_type
        , ('history_octane', 'deal_note_category_type', 'code', TRUE, 1)
        , ('history_octane', 'deal_note_category_type', 'value', FALSE, 2)
        , ('history_octane', 'deal_note_category_type', 'data_source_updated_datetime', FALSE, 3)
        , ('history_octane', 'deal_note_category_type', 'data_source_deleted_flag', FALSE, 4)
        -- staging_octane.doc_status_type
        , ('staging_octane', 'doc_status_type', 'code', TRUE, NULL)
        , ('staging_octane', 'doc_status_type', 'value', FALSE, NULL)
        -- history_octane.doc_status_type
        , ('history_octane', 'doc_status_type', 'code', TRUE, 1)
        , ('history_octane', 'doc_status_type', 'value', FALSE, 2)
        , ('history_octane', 'doc_status_type', 'data_source_updated_datetime', FALSE, 3)
        , ('history_octane', 'doc_status_type', 'data_source_deleted_flag', FALSE, 4)
        -- staging_octane.proposal_doc_new
        , ('staging_octane', 'proposal_doc_new', 'prpd_pid', TRUE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_version', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_name', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_name', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_access', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_deal_child_type', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_deal_child_name', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_deal_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_proposal_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_loan_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_income_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_job_income_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_job_gap_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_other_income_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_business_income_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_rental_income_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_asset_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_asset_large_deposit_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_liability_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_reo_place_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_property_place_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_residence_place_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_residence_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_application_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_credit_inquiry_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_appraisal_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_appraisal_form_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_tax_transcript_request_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_trash', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_smart_doc_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_proposal_doc_set_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_fulfill_status_type', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_status_unparsed_name', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_status_datetime', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_status_reason', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_excluded', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_excluded_reason', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_excluded_unparsed_name', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_excluded_datetime', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_approval_type', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_edit', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_borrower_associated_address_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_construction_cost_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_construction_draw_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_proposal_contractor_pid', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_provider_group_type', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_req_fulfill_status_type', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_req_decision_status_type', FALSE, NULL)
        , ('staging_octane', 'proposal_doc_new', 'prpd_doc_status_type', FALSE, NULL)
        -- history_octane.proposal_doc_new
        , ('history_octane', 'proposal_doc_new', 'prpd_pid', TRUE, 1)
        , ('history_octane', 'proposal_doc_new', 'prpd_version', FALSE, 2)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_name', FALSE, 3)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_name', FALSE, 4)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_access', FALSE, 5)
        , ('history_octane', 'proposal_doc_new', 'prpd_deal_child_type', FALSE, 6)
        , ('history_octane', 'proposal_doc_new', 'prpd_deal_child_name', FALSE, 7)
        , ('history_octane', 'proposal_doc_new', 'prpd_deal_pid', FALSE, 8)
        , ('history_octane', 'proposal_doc_new', 'prpd_proposal_pid', FALSE, 9)
        , ('history_octane', 'proposal_doc_new', 'prpd_loan_pid', FALSE, 10)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_pid', FALSE, 11)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_income_pid', FALSE, 12)
        , ('history_octane', 'proposal_doc_new', 'prpd_job_income_pid', FALSE, 13)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_job_gap_pid', FALSE, 14)
        , ('history_octane', 'proposal_doc_new', 'prpd_other_income_pid', FALSE, 15)
        , ('history_octane', 'proposal_doc_new', 'prpd_business_income_pid', FALSE, 16)
        , ('history_octane', 'proposal_doc_new', 'prpd_rental_income_pid', FALSE, 17)
        , ('history_octane', 'proposal_doc_new', 'prpd_asset_pid', FALSE, 18)
        , ('history_octane', 'proposal_doc_new', 'prpd_asset_large_deposit_pid', FALSE, 19)
        , ('history_octane', 'proposal_doc_new', 'prpd_liability_pid', FALSE, 20)
        , ('history_octane', 'proposal_doc_new', 'prpd_reo_place_pid', FALSE, 21)
        , ('history_octane', 'proposal_doc_new', 'prpd_property_place_pid', FALSE, 22)
        , ('history_octane', 'proposal_doc_new', 'prpd_residence_place_pid', FALSE, 23)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_residence_pid', FALSE, 24)
        , ('history_octane', 'proposal_doc_new', 'prpd_application_pid', FALSE, 25)
        , ('history_octane', 'proposal_doc_new', 'prpd_credit_inquiry_pid', FALSE, 26)
        , ('history_octane', 'proposal_doc_new', 'prpd_appraisal_pid', FALSE, 27)
        , ('history_octane', 'proposal_doc_new', 'prpd_appraisal_form_pid', FALSE, 28)
        , ('history_octane', 'proposal_doc_new', 'prpd_tax_transcript_request_pid', FALSE, 29)
        , ('history_octane', 'proposal_doc_new', 'prpd_trash', FALSE, 30)
        , ('history_octane', 'proposal_doc_new', 'prpd_smart_doc_pid', FALSE, 31)
        , ('history_octane', 'proposal_doc_new', 'prpd_proposal_doc_set_pid', FALSE, 32)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_fulfill_status_type', FALSE, 33)
        , ('history_octane', 'proposal_doc_new', 'prpd_status_unparsed_name', FALSE, 34)
        , ('history_octane', 'proposal_doc_new', 'prpd_status_datetime', FALSE, 35)
        , ('history_octane', 'proposal_doc_new', 'prpd_status_reason', FALSE, 36)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_excluded', FALSE, 37)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_excluded_reason', FALSE, 38)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_excluded_unparsed_name', FALSE, 39)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_excluded_datetime', FALSE, 40)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_approval_type', FALSE, 41)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_edit', FALSE, 42)
        , ('history_octane', 'proposal_doc_new', 'prpd_borrower_associated_address_pid', FALSE, 43)
        , ('history_octane', 'proposal_doc_new', 'prpd_construction_cost_pid', FALSE, 44)
        , ('history_octane', 'proposal_doc_new', 'prpd_construction_draw_pid', FALSE, 45)
        , ('history_octane', 'proposal_doc_new', 'prpd_proposal_contractor_pid', FALSE, 46)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_provider_group_type', FALSE, 47)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_req_fulfill_status_type', FALSE, 48)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_req_decision_status_type', FALSE, 49)
        , ('history_octane', 'proposal_doc_new', 'prpd_doc_status_type', FALSE, 50)
        , ('history_octane', 'proposal_doc_new', 'data_source_updated_datetime', FALSE, 51)
        , ('history_octane', 'proposal_doc_new', 'data_source_deleted_flag', FALSE, 52)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid
            , new_fields.field_name
            , new_fields.key_field_flag
        FROM new_fields
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
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
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
            JOIN new_history_table_definitions ON new_fields.table_name = new_history_table_definitions.table_name
            LEFT JOIN new_staging_field_definitions ON new_staging_table_definitions.dwid =
                                                       new_staging_field_definitions.edw_table_definition_dwid
                AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

, new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100846', 'deal_note_category_type', 'code', 'SELECT staging_table.code, staging_table.value, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.deal_note_category_type staging_table
         LEFT JOIN history_octane.deal_note_category_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100847', 'doc_status_type', 'code', 'SELECT staging_table.code, staging_table.value, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.doc_status_type staging_table
         LEFT JOIN history_octane.doc_status_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100848', 'proposal_doc_new', 'prpd_pid', '--finding records to insert into history_octane.proposal_doc_new
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
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.proposal_doc_new staging_table
         LEFT JOIN history_octane.proposal_doc_new history_table on staging_table.prpd_pid = history_table.prpd_pid and staging_table.prpd_version = history_table.prpd_version
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
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.proposal_doc_new history_table
         LEFT JOIN staging_octane.proposal_doc_new staging_table on staging_table.prpd_pid = history_table.prpd_pid
WHERE staging_table.prpd_pid is NULL
  AND not exists (select 1 from history_octane.proposal_doc_new deleted_records where deleted_records.prpd_pid = history_table.prpd_pid and deleted_records.data_source_deleted_flag = True)')
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
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
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
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
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
            JOIN new_fields ON new_fields.schema_name = new_table_output_steps.target_schema
                AND new_fields.table_name = new_table_output_steps.target_table
)

, new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
)

, new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)
SELECT 'Finished inserting metadata for new tables: deal_note_category_type, doc_status_type, proposal_doc_new';

/*
Insert metadata for new columns:
    - proposal_construction.prpc_estimated_permit_amount_applicable
    - asset.as_deposit_date
    - asset.as_gift_funds_ein
    - deal_note.dn_category_type
*/

WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('proposal_construction', 'prpc_estimated_permit_amount_applicable', 18)
        , ('asset', 'as_deposit_date', 45)
        , ('asset', 'as_gift_funds_ein', 46)
        , ('deal_note', 'dn_category_type', 14)
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
    VALUES ('proposal_construction', '--finding records to insert into history_octane.proposal_construction
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
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_construction staging_table
         LEFT JOIN history_octane.proposal_construction history_table
                   ON staging_table.prpc_pid = history_table.prpc_pid AND staging_table.prpc_version = history_table.prpc_version
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
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_construction history_table
         LEFT JOIN staging_octane.proposal_construction staging_table
                   ON staging_table.prpc_pid = history_table.prpc_pid
WHERE staging_table.prpc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal_construction deleted_records
                  WHERE deleted_records.prpc_pid = history_table.prpc_pid
                    AND deleted_records.data_source_deleted_flag = TRUE )')
        , ('asset', '--finding records to insert into history_octane.asset
SELECT staging_table.as_pid
, staging_table.as_version
, staging_table.as_aggregate_description
, staging_table.as_application_pid
, staging_table.as_asset_type
, staging_table.as_automobile_make_description
, staging_table.as_automobile_model_year
, staging_table.as_cash_or_market_value_amount
, staging_table.as_description
, staging_table.as_donor_city
, staging_table.as_donor_country
, staging_table.as_donor_postal_code
, staging_table.as_donor_state
, staging_table.as_donor_street1
, staging_table.as_donor_street2
, staging_table.as_gift_funds_donor_phone
, staging_table.as_gift_funds_donor_relationship
, staging_table.as_gift_funds_donor_unparsed_name
, staging_table.as_gift_funds_other_type_description
, staging_table.as_gift_funds_depository_asset_pid
, staging_table.as_gift_amount
, staging_table.as_gift_funds_source_account_type
, staging_table.as_gift_funds_source_holder_name
, staging_table.as_gift_funds_type
, staging_table.as_holder_name
, staging_table.as_holder_city
, staging_table.as_holder_country
, staging_table.as_holder_postal_code
, staging_table.as_holder_state
, staging_table.as_holder_street1
, staging_table.as_holder_street2
, staging_table.as_life_insurance_face_value_amount
, staging_table.as_liquid_amount
, staging_table.as_liquid_percent
, staging_table.as_source_verification_required
, staging_table.as_stock_bond_mutual_fund_share_count
, staging_table.as_earnest_money_deposit_source_pid
, staging_table.as_available_amount
, staging_table.as_down_payment_amount
, staging_table.as_closing_costs_amount
, staging_table.as_gift_funds_account_holder_type
, staging_table.as_penalty_amount
, staging_table.as_earnest_money_deposit_is_gift
, staging_table.as_deposit_date
, staging_table.as_gift_funds_ein
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.asset staging_table
         LEFT JOIN history_octane.asset history_table on staging_table.as_pid = history_table.as_pid and staging_table.as_version = history_table.as_version
WHERE history_table.as_pid is NULL
UNION ALL
SELECT history_table.as_pid
, history_table.as_version+1
, history_table.as_aggregate_description
, history_table.as_application_pid
, history_table.as_asset_type
, history_table.as_automobile_make_description
, history_table.as_automobile_model_year
, history_table.as_cash_or_market_value_amount
, history_table.as_description
, history_table.as_donor_city
, history_table.as_donor_country
, history_table.as_donor_postal_code
, history_table.as_donor_state
, history_table.as_donor_street1
, history_table.as_donor_street2
, history_table.as_gift_funds_donor_phone
, history_table.as_gift_funds_donor_relationship
, history_table.as_gift_funds_donor_unparsed_name
, history_table.as_gift_funds_other_type_description
, history_table.as_gift_funds_depository_asset_pid
, history_table.as_gift_amount
, history_table.as_gift_funds_source_account_type
, history_table.as_gift_funds_source_holder_name
, history_table.as_gift_funds_type
, history_table.as_holder_name
, history_table.as_holder_city
, history_table.as_holder_country
, history_table.as_holder_postal_code
, history_table.as_holder_state
, history_table.as_holder_street1
, history_table.as_holder_street2
, history_table.as_life_insurance_face_value_amount
, history_table.as_liquid_amount
, history_table.as_liquid_percent
, history_table.as_source_verification_required
, history_table.as_stock_bond_mutual_fund_share_count
, history_table.as_earnest_money_deposit_source_pid
, history_table.as_available_amount
, history_table.as_down_payment_amount
, history_table.as_closing_costs_amount
, history_table.as_gift_funds_account_holder_type
, history_table.as_penalty_amount
, history_table.as_earnest_money_deposit_is_gift
, history_table.as_deposit_date
, history_table.as_gift_funds_ein
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.asset history_table
         LEFT JOIN staging_octane.asset staging_table on staging_table.as_pid = history_table.as_pid
WHERE staging_table.as_pid is NULL
  AND not exists (select 1 from history_octane.asset deleted_records where deleted_records.as_pid = history_table.as_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('deal_note', '--finding records to insert into history_octane.deal_note
SELECT staging_table.dn_pid
, staging_table.dn_version
, staging_table.dn_deal_pid
, staging_table.dn_create_datetime
, staging_table.dn_content
, staging_table.dn_author_unparsed_name
, staging_table.dn_author_lender_user_pid
, staging_table.dn_scope_type
, staging_table.dn_scope_name
, staging_table.dn_wf_deal_step_pid
, staging_table.dn_proposal_doc_pid
, staging_table.dn_proposal_review_pid
, staging_table.dn_category_type
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.deal_note staging_table
         LEFT JOIN history_octane.deal_note history_table on staging_table.dn_pid = history_table.dn_pid and staging_table.dn_version = history_table.dn_version
WHERE history_table.dn_pid is NULL
UNION ALL
SELECT history_table.dn_pid
, history_table.dn_version+1
, history_table.dn_deal_pid
, history_table.dn_create_datetime
, history_table.dn_content
, history_table.dn_author_unparsed_name
, history_table.dn_author_lender_user_pid
, history_table.dn_scope_type
, history_table.dn_scope_name
, history_table.dn_wf_deal_step_pid
, history_table.dn_proposal_doc_pid
, history_table.dn_proposal_review_pid
, history_table.dn_category_type
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.deal_note history_table
         LEFT JOIN staging_octane.deal_note staging_table on staging_table.dn_pid = history_table.dn_pid
WHERE staging_table.dn_pid is NULL
  AND not exists (select 1 from history_octane.deal_note deleted_records where deleted_records.dn_pid = history_table.dn_pid and deleted_records.data_source_deleted_flag = True)
')
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
SELECT 'Finished inserting metadata for new columns: proposal_construction.prpc_estimated_permit_amount_applicable, ' ||
       'asset.as_deposit_date, asset.as_gift_funds_ein, deal_note.dn_category_type';

/*
Remove metadata for dropped columns:
    - smart_doc.sd_doc_validity_type
    - smart_doc.sd_expiration_rule_type
    - smart_doc.sd_days_before_key_date
    - smart_doc.sd_warning_days
    - smart_doc.sd_doc_key_date_type
    - proposal_doc.prpd_valid_from_date
    - proposal_doc.prpd_valid_through_date
    - proposal_doc.prpd_key_date
*/

-- Nullify source_edw_field_definition_dwid values for history_octane rows
UPDATE mdi.edw_field_definition
    SET source_edw_field_definition_dwid = NULL
    WHERE dwid IN (
        SELECT edw_field_definition.dwid
        FROM mdi.edw_table_definition
                 JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
        WHERE edw_table_definition.schema_name = 'history_octane'
          AND edw_table_definition.table_name IN ('smart_doc', 'proposal_doc')
          AND edw_field_definition.field_name IN ('sd_doc_validity_type', 'sd_expiration_rule_type',
                                                  'sd_days_before_key_date', 'sd_warning_days', 'sd_doc_key_date_type',
                                                  'prpd_valid_from_date', 'prpd_valid_through_date', 'prpd_key_date')
    );

-- Remove edw_field_definition records for staging_octane rows
DELETE FROM mdi.edw_field_definition
    WHERE dwid IN (
        SELECT edw_field_definition.dwid
        FROM mdi.edw_table_definition
            JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
        WHERE edw_table_definition.schema_name = 'staging_octane'
            AND edw_table_definition.table_name IN ('smart_doc', 'proposal_doc')
            AND edw_field_definition.field_name IN ('sd_doc_validity_type', 'sd_expiration_rule_type',
                                                    'sd_days_before_key_date', 'sd_warning_days', 'sd_doc_key_date_type',
                                                    'prpd_valid_from_date', 'prpd_valid_through_date', 'prpd_key_date')
        );

-- Update the table_input_step sql queries for the ETLs that maintain the smart_doc and proposal_doc tables
-- smart_doc:
UPDATE mdi.table_input_step
    SET sql = '--finding records to insert into history_octane.smart_doc
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
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.smart_doc staging_table
         LEFT JOIN history_octane.smart_doc history_table on staging_table.sd_pid = history_table.sd_pid and staging_table.sd_version = history_table.sd_version
WHERE history_table.sd_pid is NULL
UNION ALL
SELECT history_table.sd_pid
, history_table.sd_version+1
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
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.smart_doc history_table
         LEFT JOIN staging_octane.smart_doc staging_table on staging_table.sd_pid = history_table.sd_pid
WHERE staging_table.sd_pid is NULL
  AND not exists (select 1 from history_octane.smart_doc deleted_records where deleted_records.sd_pid = history_table.sd_pid and deleted_records.data_source_deleted_flag = True)'
    WHERE dwid = (
        SELECT table_input_step.dwid
        FROM mdi.process
            JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
            JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
                AND table_output_step.target_table = 'smart_doc'
        );

-- proposal_doc:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into history_octane.proposal_doc
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
, staging_table.prpd_last_status_reason
, staging_table.prpd_borrower_associated_address_pid
, staging_table.prpd_construction_cost_pid
, staging_table.prpd_construction_draw_pid
, staging_table.prpd_proposal_contractor_pid
, staging_table.prpd_doc_provider_group_type
, staging_table.prpd_doc_req_fulfill_status_type
, staging_table.prpd_doc_req_decision_status_type
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
, history_table.prpd_last_status_reason
, history_table.prpd_borrower_associated_address_pid
, history_table.prpd_construction_cost_pid
, history_table.prpd_construction_draw_pid
, history_table.prpd_proposal_contractor_pid
, history_table.prpd_doc_provider_group_type
, history_table.prpd_doc_req_fulfill_status_type
, history_table.prpd_doc_req_decision_status_type
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.proposal_doc history_table
         LEFT JOIN staging_octane.proposal_doc staging_table on staging_table.prpd_pid = history_table.prpd_pid
WHERE staging_table.prpd_pid is NULL
  AND not exists (select 1 from history_octane.proposal_doc deleted_records where deleted_records.prpd_pid = history_table.prpd_pid and deleted_records.data_source_deleted_flag = True)'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
             JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
             JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
        AND table_output_step.target_table = 'proposal_doc'
);

-- Remove table_output_field records for fields removed from the smart_doc and proposal_doc tables
DELETE FROM mdi.table_output_field
WHERE dwid IN (
    SELECT table_output_field.dwid
    FROM mdi.process
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table IN ('smart_doc', 'proposal_doc')
        JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
            AND table_output_field.database_field_name IN ('sd_doc_validity_type', 'sd_expiration_rule_type',
                                                           'sd_days_before_key_date', 'sd_warning_days',
                                                           'sd_doc_key_date_type', 'prpd_valid_from_date',
                                                           'prpd_valid_through_date', 'prpd_key_date')
    );
