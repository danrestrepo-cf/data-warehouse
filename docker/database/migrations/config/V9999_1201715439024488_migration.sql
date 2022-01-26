/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'smart_doc_provider_type_case', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON insert_rows.source_database_name = source_table_definition.database_name
              AND insert_rows.source_schema_name = source_table_definition.schema_name
              AND insert_rows.source_table_name = source_table_definition.table_name;

WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'history_octane', 'smart_doc_provider_type_case', 'staging', 'staging_octane', 'smart_doc_provider_type_case')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case')
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
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name,
                  source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'smart_doc_provider_type_case', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_provider_type_case', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_provider_type_case', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_bonus_monthly_income', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_employer_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_employer_phone', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_gross_monthly_income', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_income_end_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_income_start_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_2_position', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_bonus_monthly_income', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_employer_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_employer_phone', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_gross_monthly_income', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_income_end_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_income_start_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_3_position', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_bonus_monthly_income', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_employer_phone', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_income_end_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_job_income_start_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_residence_from_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_residence_through_date', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead', 'ld_borrower_residency_basis_type', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_provider_type_case', 'sdptc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_provider_type_case', 'sdptc_smart_doc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_provider_type_case', 'sdptc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_active', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_criteria_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_deal_child_relationship_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_deal_child_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_ordinal', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_prior_to_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_smart_doc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'criteria_snippet', 'crs_compatible_with_smart_doc_prior_to_type_case', 'BOOLEAN', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid
     , insert_rows.field_name
     , FALSE
     , source_field_definition.dwid
     , NULL
     , insert_rows.data_type
     , NULL
     , NULL
     , NULL
     , NULL
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

WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name,
                  source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_bonus_monthly_income', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_bonus_monthly_income')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_employer_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_employer_name')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_employer_phone', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_employer_phone')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_gross_monthly_income', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_gross_monthly_income')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_income_end_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_income_end_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_income_start_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_income_start_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_2_position', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_2_position')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_bonus_monthly_income', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_bonus_monthly_income')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_employer_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_employer_name')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_employer_phone', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_employer_phone')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_gross_monthly_income', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_gross_monthly_income')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_income_end_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_income_end_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_income_start_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_income_start_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_3_position', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_3_position')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_bonus_monthly_income', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_bonus_monthly_income')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_employer_phone', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_employer_phone')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_income_end_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_income_end_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_job_income_start_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_job_income_start_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_residence_from_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_residence_from_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_residence_through_date', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_residence_through_date')
         , ('staging', 'history_octane', 'lead', 'ld_borrower_residency_basis_type', 'VARCHAR(32)', 'staging', 'staging_octane', 'lead', 'ld_borrower_residency_basis_type')
         , ('staging', 'history_octane', 'smart_doc_provider_type_case', 'sdptc_pid', 'BIGINT', 'staging', 'staging_octane', 'smart_doc_provider_type_case', 'sdptc_pid')
         , ('staging', 'history_octane', 'smart_doc_provider_type_case', 'sdptc_smart_doc_pid', 'BIGINT', 'staging', 'staging_octane', 'smart_doc_provider_type_case', 'sdptc_smart_doc_pid')
         , ('staging', 'history_octane', 'smart_doc_provider_type_case', 'sdptc_version', 'INTEGER', 'staging', 'staging_octane', 'smart_doc_provider_type_case', 'sdptc_version')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_active', 'BOOLEAN', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_active')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_criteria_pid', 'BIGINT', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_criteria_pid')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_deal_child_relationship_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_deal_child_relationship_type')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_deal_child_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_deal_child_type')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_ordinal', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_ordinal')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_pid', 'BIGINT', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_pid')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_prior_to_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_prior_to_type')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_smart_doc_pid', 'BIGINT', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_smart_doc_pid')
         , ('staging', 'history_octane', 'smart_doc_prior_to_type_case', 'sdpttc_version', 'INTEGER', 'staging', 'staging_octane', 'smart_doc_prior_to_type_case', 'sdpttc_version')
         , ('staging', 'history_octane', 'criteria_snippet', 'crs_compatible_with_smart_doc_prior_to_type_case', 'BOOLEAN', 'staging', 'staging_octane', 'criteria_snippet', 'crs_compatible_with_smart_doc_prior_to_type_case')
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid
     , insert_rows.field_name
     , FALSE
     , source_field_definition.dwid
     , NULL
     , insert_rows.data_type
     , NULL
     , NULL
     , NULL
     , NULL
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

--process
INSERT
INTO mdi.process (name, description)
VALUES ('SP-100894', 'ETL to copy smart_doc_provider_type_case data from staging_octane to history_octane')
     , ('SP-100893', 'ETL to copy smart_doc_prior_to_type_case data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100894', 0, '--finding records to insert into history_octane.smart_doc_provider_type_case
SELECT staging_table.sdptc_pid
     , staging_table.sdptc_version
     , staging_table.sdptc_smart_doc_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc_provider_type_case staging_table
LEFT JOIN history_octane.smart_doc_provider_type_case history_table
          ON staging_table.sdptc_pid = history_table.sdptc_pid
              AND staging_table.sdptc_version = history_table.sdptc_version
WHERE history_table.sdptc_pid IS NULL
UNION ALL
SELECT history_table.sdptc_pid
     , history_table.sdptc_version + 1
     , history_table.sdptc_smart_doc_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc_provider_type_case history_table
LEFT JOIN staging_octane.smart_doc_provider_type_case staging_table
          ON staging_table.sdptc_pid = history_table.sdptc_pid
WHERE staging_table.sdptc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_doc_provider_type_case deleted_records
    WHERE deleted_records.sdptc_pid = history_table.sdptc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100893', 0, '--finding records to insert into history_octane.smart_doc_prior_to_type_case
SELECT staging_table.sdpttc_pid
     , staging_table.sdpttc_version
     , staging_table.sdpttc_smart_doc_pid
     , staging_table.sdpttc_criteria_pid
     , staging_table.sdpttc_deal_child_type
     , staging_table.sdpttc_deal_child_relationship_type
     , staging_table.sdpttc_prior_to_type
     , staging_table.sdpttc_ordinal
     , staging_table.sdpttc_active
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc_prior_to_type_case staging_table
LEFT JOIN history_octane.smart_doc_prior_to_type_case history_table
          ON staging_table.sdpttc_pid = history_table.sdpttc_pid
              AND staging_table.sdpttc_version = history_table.sdpttc_version
WHERE history_table.sdpttc_pid IS NULL
UNION ALL
SELECT history_table.sdpttc_pid
     , history_table.sdpttc_version + 1
     , history_table.sdpttc_smart_doc_pid
     , history_table.sdpttc_criteria_pid
     , history_table.sdpttc_deal_child_type
     , history_table.sdpttc_deal_child_relationship_type
     , history_table.sdpttc_prior_to_type
     , history_table.sdpttc_ordinal
     , history_table.sdpttc_active
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc_prior_to_type_case history_table
LEFT JOIN staging_octane.smart_doc_prior_to_type_case staging_table
          ON staging_table.sdpttc_pid = history_table.sdpttc_pid
WHERE staging_table.sdpttc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_doc_prior_to_type_case deleted_records
    WHERE deleted_records.sdpttc_pid = history_table.sdpttc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid
     , insert_rows.data_source_dwid
     , insert_rows.sql
     , 0
     , 'N'
     , 'N'
     , 'N'
     , 'N'
     , insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-100894', 'history_octane', 'smart_doc_provider_type_case', 'N', 'Staging DB Connection')
         , ('SP-100893', 'history_octane', 'smart_doc_prior_to_type_case', 'N', 'Staging DB Connection')
)
INSERT
INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid
     , insert_rows.target_schema
     , insert_rows.target_table
     , 1000
     , NULL
     , NULL
     , NULL
     , NULL
     , 'N'
     , NULL
     , insert_rows.truncate_table::mdi.pentaho_y_or_n
     , insert_rows.connectionname
     , 'N'
     , 'Y'
     , 'N'
     , 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100089', 'ld_borrower_job_2_bonus_monthly_income')
         , ('SP-100089', 'ld_borrower_job_2_employer_name')
         , ('SP-100089', 'ld_borrower_job_2_employer_phone')
         , ('SP-100089', 'ld_borrower_job_2_gross_monthly_income')
         , ('SP-100089', 'ld_borrower_job_2_income_end_date')
         , ('SP-100089', 'ld_borrower_job_2_income_start_date')
         , ('SP-100089', 'ld_borrower_job_2_position')
         , ('SP-100089', 'ld_borrower_job_3_bonus_monthly_income')
         , ('SP-100089', 'ld_borrower_job_3_employer_name')
         , ('SP-100089', 'ld_borrower_job_3_employer_phone')
         , ('SP-100089', 'ld_borrower_job_3_gross_monthly_income')
         , ('SP-100089', 'ld_borrower_job_3_income_end_date')
         , ('SP-100089', 'ld_borrower_job_3_income_start_date')
         , ('SP-100089', 'ld_borrower_job_3_position')
         , ('SP-100089', 'ld_borrower_job_bonus_monthly_income')
         , ('SP-100089', 'ld_borrower_job_employer_phone')
         , ('SP-100089', 'ld_borrower_job_income_end_date')
         , ('SP-100089', 'ld_borrower_job_income_start_date')
         , ('SP-100089', 'ld_borrower_residence_from_date')
         , ('SP-100089', 'ld_borrower_residence_through_date')
         , ('SP-100089', 'ld_borrower_residency_basis_type')
         , ('SP-100894', 'data_source_deleted_flag')
         , ('SP-100894', 'data_source_updated_datetime')
         , ('SP-100894', 'etl_batch_id')
         , ('SP-100894', 'sdptc_pid')
         , ('SP-100894', 'sdptc_smart_doc_pid')
         , ('SP-100894', 'sdptc_version')
         , ('SP-100893', 'data_source_deleted_flag')
         , ('SP-100893', 'data_source_updated_datetime')
         , ('SP-100893', 'etl_batch_id')
         , ('SP-100893', 'sdpttc_active')
         , ('SP-100893', 'sdpttc_criteria_pid')
         , ('SP-100893', 'sdpttc_deal_child_relationship_type')
         , ('SP-100893', 'sdpttc_deal_child_type')
         , ('SP-100893', 'sdpttc_ordinal')
         , ('SP-100893', 'sdpttc_pid')
         , ('SP-100893', 'sdpttc_prior_to_type')
         , ('SP-100893', 'sdpttc_smart_doc_pid')
         , ('SP-100893', 'sdpttc_version')
         , ('SP-100026', 'crs_compatible_with_smart_doc_prior_to_type_case')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid;


--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
    VALUES ('SP-100894', 'sdptc_pid')
         , ('SP-100893', 'sdpttc_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100894', 'SP-100894', 'ETL to copy smart_doc_provider_type_case data from staging_octane to history_octane')
         , ('SP-100893', 'SP-100893', 'ETL to copy smart_doc_prior_to_type_case data from staging_octane to history_octane')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100089', 0, '--finding records to insert into history_octane.lead
SELECT staging_table.ld_pid
     , staging_table.ld_version
     , staging_table.ld_deal_pid
     , staging_table.ld_lead_datetime
     , staging_table.ld_velocify_campaign_id
     , staging_table.ld_velocify_campaign_title
     , staging_table.ld_originator_email
     , staging_table.ld_customer_service_rep_name
     , staging_table.ld_velocify_lead_id
     , staging_table.ld_tracking_id
     , staging_table.ld_zillow_zq
     , staging_table.ld_reference_id
     , staging_table.ld_apr_percent
     , staging_table.ld_interest_rate
     , staging_table.ld_rate_type
     , staging_table.ld_fico_score
     , staging_table.ld_loan_type
     , staging_table.ld_notes
     , staging_table.ld_loan_purpose_type
     , staging_table.ld_purchase_price
     , staging_table.ld_existing_home_value
     , staging_table.ld_loan_amount
     , staging_table.ld_property_use
     , staging_table.ld_subject_property_street
     , staging_table.ld_subject_property_city
     , staging_table.ld_subject_property_state
     , staging_table.ld_subject_property_postal_code
     , staging_table.ld_subject_property_type
     , staging_table.ld_borrower_first_name
     , staging_table.ld_borrower_last_name
     , staging_table.ld_borrower_home_phone
     , staging_table.ld_borrower_mobile_phone
     , staging_table.ld_borrower_email
     , staging_table.ld_borrower_birth_date
     , staging_table.ld_borrower_residence_street
     , staging_table.ld_borrower_residence_city
     , staging_table.ld_borrower_residence_state
     , staging_table.ld_borrower_residence_postal_code
     , staging_table.ld_coborrower_first_name
     , staging_table.ld_coborrower_middle_name
     , staging_table.ld_coborrower_last_name
     , staging_table.ld_coborrower_email
     , staging_table.ld_coborrower_birth_date
     , staging_table.ld_borrower_current_job_employer_name
     , staging_table.ld_borrower_current_job_position
     , staging_table.ld_borrower_years_on_job
     , staging_table.ld_borrower_gross_monthly_income
     , staging_table.ld_borrower_job_employer_phone
     , staging_table.ld_borrower_job_income_start_date
     , staging_table.ld_borrower_job_income_end_date
     , staging_table.ld_borrower_job_bonus_monthly_income
     , staging_table.ld_borrower_job_2_employer_name
     , staging_table.ld_borrower_job_2_position
     , staging_table.ld_borrower_job_2_employer_phone
     , staging_table.ld_borrower_job_2_income_start_date
     , staging_table.ld_borrower_job_2_income_end_date
     , staging_table.ld_borrower_job_2_gross_monthly_income
     , staging_table.ld_borrower_job_2_bonus_monthly_income
     , staging_table.ld_borrower_job_3_employer_name
     , staging_table.ld_borrower_job_3_position
     , staging_table.ld_borrower_job_3_employer_phone
     , staging_table.ld_borrower_job_3_income_start_date
     , staging_table.ld_borrower_job_3_income_end_date
     , staging_table.ld_borrower_job_3_gross_monthly_income
     , staging_table.ld_borrower_job_3_bonus_monthly_income
     , staging_table.ld_borrower_residency_basis_type
     , staging_table.ld_borrower_residence_from_date
     , staging_table.ld_borrower_residence_through_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lead staging_table
LEFT JOIN history_octane.lead history_table
          ON staging_table.ld_pid = history_table.ld_pid
              AND staging_table.ld_version = history_table.ld_version
WHERE history_table.ld_pid IS NULL
UNION ALL
SELECT history_table.ld_pid
     , history_table.ld_version + 1
     , history_table.ld_deal_pid
     , history_table.ld_lead_datetime
     , history_table.ld_velocify_campaign_id
     , history_table.ld_velocify_campaign_title
     , history_table.ld_originator_email
     , history_table.ld_customer_service_rep_name
     , history_table.ld_velocify_lead_id
     , history_table.ld_tracking_id
     , history_table.ld_zillow_zq
     , history_table.ld_reference_id
     , history_table.ld_apr_percent
     , history_table.ld_interest_rate
     , history_table.ld_rate_type
     , history_table.ld_fico_score
     , history_table.ld_loan_type
     , history_table.ld_notes
     , history_table.ld_loan_purpose_type
     , history_table.ld_purchase_price
     , history_table.ld_existing_home_value
     , history_table.ld_loan_amount
     , history_table.ld_property_use
     , history_table.ld_subject_property_street
     , history_table.ld_subject_property_city
     , history_table.ld_subject_property_state
     , history_table.ld_subject_property_postal_code
     , history_table.ld_subject_property_type
     , history_table.ld_borrower_first_name
     , history_table.ld_borrower_last_name
     , history_table.ld_borrower_home_phone
     , history_table.ld_borrower_mobile_phone
     , history_table.ld_borrower_email
     , history_table.ld_borrower_birth_date
     , history_table.ld_borrower_residence_street
     , history_table.ld_borrower_residence_city
     , history_table.ld_borrower_residence_state
     , history_table.ld_borrower_residence_postal_code
     , history_table.ld_coborrower_first_name
     , history_table.ld_coborrower_middle_name
     , history_table.ld_coborrower_last_name
     , history_table.ld_coborrower_email
     , history_table.ld_coborrower_birth_date
     , history_table.ld_borrower_current_job_employer_name
     , history_table.ld_borrower_current_job_position
     , history_table.ld_borrower_years_on_job
     , history_table.ld_borrower_gross_monthly_income
     , history_table.ld_borrower_job_employer_phone
     , history_table.ld_borrower_job_income_start_date
     , history_table.ld_borrower_job_income_end_date
     , history_table.ld_borrower_job_bonus_monthly_income
     , history_table.ld_borrower_job_2_employer_name
     , history_table.ld_borrower_job_2_position
     , history_table.ld_borrower_job_2_employer_phone
     , history_table.ld_borrower_job_2_income_start_date
     , history_table.ld_borrower_job_2_income_end_date
     , history_table.ld_borrower_job_2_gross_monthly_income
     , history_table.ld_borrower_job_2_bonus_monthly_income
     , history_table.ld_borrower_job_3_employer_name
     , history_table.ld_borrower_job_3_position
     , history_table.ld_borrower_job_3_employer_phone
     , history_table.ld_borrower_job_3_income_start_date
     , history_table.ld_borrower_job_3_income_end_date
     , history_table.ld_borrower_job_3_gross_monthly_income
     , history_table.ld_borrower_job_3_bonus_monthly_income
     , history_table.ld_borrower_residency_basis_type
     , history_table.ld_borrower_residence_from_date
     , history_table.ld_borrower_residence_through_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lead history_table
LEFT JOIN staging_octane.lead staging_table
          ON staging_table.ld_pid = history_table.ld_pid
WHERE staging_table.ld_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lead deleted_records
    WHERE deleted_records.ld_pid = history_table.ld_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100026', 0, '--finding records to insert into history_octane.criteria_snippet
SELECT staging_table.crs_pid
     , staging_table.crs_version
     , staging_table.crs_account_pid
     , staging_table.crs_name
     , staging_table.crs_criteria_pid
     , staging_table.crs_description
     , staging_table.crs_deal_child_type
     , staging_table.crs_compatible_with_smart_charge_case
     , staging_table.crs_compatible_with_smart_req
     , staging_table.crs_compatible_with_stack_separator
     , staging_table.crs_compatible_with_investor_eligibility
     , staging_table.crs_compatible_with_wf_smart_task
     , staging_table.crs_compatible_with_wf_outcome
     , staging_table.crs_compatible_with_wf_smart_process
     , staging_table.crs_compatible_with_smart_doc
     , staging_table.crs_compatible_with_smart_doc_validity_date_case
     , staging_table.crs_compatible_with_smart_charge_apr
     , staging_table.crs_compatible_with_smart_doc_prior_to_type_case
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.criteria_snippet staging_table
LEFT JOIN history_octane.criteria_snippet history_table
          ON staging_table.crs_pid = history_table.crs_pid
              AND staging_table.crs_version = history_table.crs_version
WHERE history_table.crs_pid IS NULL
UNION ALL
SELECT history_table.crs_pid
     , history_table.crs_version + 1
     , history_table.crs_account_pid
     , history_table.crs_name
     , history_table.crs_criteria_pid
     , history_table.crs_description
     , history_table.crs_deal_child_type
     , history_table.crs_compatible_with_smart_charge_case
     , history_table.crs_compatible_with_smart_req
     , history_table.crs_compatible_with_stack_separator
     , history_table.crs_compatible_with_investor_eligibility
     , history_table.crs_compatible_with_wf_smart_task
     , history_table.crs_compatible_with_wf_outcome
     , history_table.crs_compatible_with_wf_smart_process
     , history_table.crs_compatible_with_smart_doc
     , history_table.crs_compatible_with_smart_doc_validity_date_case
     , history_table.crs_compatible_with_smart_charge_apr
     , history_table.crs_compatible_with_smart_doc_prior_to_type_case
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.criteria_snippet history_table
LEFT JOIN staging_octane.criteria_snippet staging_table
          ON staging_table.crs_pid = history_table.crs_pid
WHERE staging_table.crs_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.criteria_snippet deleted_records
    WHERE deleted_records.crs_pid = history_table.crs_pid
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
