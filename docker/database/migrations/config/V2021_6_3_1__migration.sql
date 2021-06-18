--
-- Main | EDW | Octane Schema changes for 2021.6.3.1 (6/18/2021) (https://app.asana.com/0/0/1200488131634566 )
--


--
-- INSERT EDW_TABLE_DEFINITION ROWS FOR NEW TABLES: loan_charge_payer_item_source_type, loan_charge_payer_item, wf_prereq_set, wf_prereq
--

-- Insert edw_table_definition rows for loan_charge_payer_item_source_type
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'loan_charge_payer_item_source_type', NULL)
        RETURNING dwid
)
INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'loan_charge_payer_item_source_type', staging_table.dwid
FROM staging_table;


-- Insert edw_table_definition rows for loan_charge_payer_item
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'loan_charge_payer_item', NULL)
        RETURNING dwid
)
INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'loan_charge_payer_item', staging_table.dwid
FROM staging_table;


-- Insert edw_table_definition rows for wf_prereq_set
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'wf_prereq_set', NULL)
        RETURNING dwid
)
INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'wf_prereq_set', staging_table.dwid
FROM staging_table;


-- Insert edw_table_definition rows for wf_prereq
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'wf_prereq', NULL)
        RETURNING dwid
)
INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'wf_prereq', staging_table.dwid
FROM staging_table;



--
-- INSERT EDW_FIELD_DEFINITION ROWS FOR NEW TABLES: loan_charge_payer_item_source_type, loan_charge_payer_item, wf_prereq_set, wf_prereq
--

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_new_table_field_data (
                                                     table_name TEXT,
                                                     field_name TEXT,
                                                     key_field_flag BOOLEAN,
                                                     field_order INTEGER
);

INSERT INTO temp_new_table_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('loan_charge_payer_item_source_type', 'code', TRUE, 1)
     , ('loan_charge_payer_item_source_type', 'value', FALSE, 2)
     , ('loan_charge_payer_item', 'lcpi_pid', TRUE, 1)
     , ('loan_charge_payer_item', 'lcpi_version', FALSE, 2)
     , ('loan_charge_payer_item', 'lcpi_item_amount', FALSE, 3)
     , ('loan_charge_payer_item', 'lcpi_loan_charge_payer_item_source_type', FALSE, 4)
     , ('loan_charge_payer_item', 'lcpi_loan_charge_pid', FALSE, 5)
     , ('loan_charge_payer_item', 'lcpi_charge_payer_type', FALSE, 6)
     , ('loan_charge_payer_item', 'lcpi_paid_by', FALSE, 7)
     , ('loan_charge_payer_item', 'lcpi_poc', FALSE, 8)
     , ('loan_charge_payer_item', 'lcpi_charge_wire_action_auto_compute', FALSE, 9)
     , ('loan_charge_payer_item', 'lcpi_charge_wire_action_type', FALSE, 10)
     , ('wf_prereq_set', 'wps_pid', TRUE, 1)
     , ('wf_prereq_set', 'wps_version', FALSE, 2)
     , ('wf_prereq_set', 'wps_account_pid', FALSE, 3)
     , ('wf_prereq_set', 'wps_wf_prereq_set_name', FALSE, 4)
     , ('wf_prereq', 'wp_pid', TRUE, 1)
     , ('wf_prereq', 'wp_version', FALSE, 2)
     , ('wf_prereq', 'wp_wf_prereq_set_pid', TRUE, 3)
     , ('wf_prereq', 'wp_wf_step_pid', FALSE, 4);

-- Insert edw_field_definition data for new staging_octane tables
INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_new_table_field_data.field_name, temp_new_table_field_data.key_field_flag
FROM temp_new_table_field_data
    JOIN mdi.edw_table_definition
        ON temp_new_table_field_data.table_name = edw_table_definition.table_name
            AND edw_table_definition.schema_name = 'staging_octane';

-- Load history_octane-specific fields into temporary table before inserting history_octane field data
INSERT INTO temp_new_table_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('loan_charge_payer_item_source_type', 'data_source_updated_datetime', FALSE, 3)
     , ('loan_charge_payer_item_source_type', 'data_source_deleted_flag', FALSE, 4)
     , ('loan_charge_payer_item', 'data_source_updated_datetime', FALSE, 11)
     , ('loan_charge_payer_item', 'data_source_deleted_flag', FALSE, 12)
     , ('wf_prereq_set', 'data_source_deleted_flag', FALSE, 5)
     , ('wf_prereq_set', 'data_source_updated_datetime', FALSE, 6)
     , ('wf_prereq', 'data_source_deleted_flag', FALSE, 5)
     , ('wf_prereq', 'data_source_deleted_flag', FALSE, 6);

-- Insert edw_field_definition data for new history_octane tables
INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
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
-- INSERT MDI ETL CONFIG DATA FOR NEW TABLES: loan_charge_payer_item_source_type (SP-100829), loan_charge_payer_item (SP-100830), wf_prereq_set (SP-100831), wf_prereq (SP-100832)
--

-- Load field values that differ between processes into a temp table before inserting MDI config data
CREATE TEMPORARY TABLE temp_new_table_mdi_data (
                                                   table_name TEXT,
                                                   process_name TEXT,
                                                   json_output_field TEXT,
                                                   input_sql TEXT,
                                                   process_dwid BIGINT);

INSERT INTO temp_new_table_mdi_data (table_name, process_name, json_output_field, input_sql)
VALUES ('loan_charge_payer_item_source_type', 'SP-100829', 'code', '--finding records to insert into history_octane.loan_charge_payer_item_source_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW() AS data_source_updated_datetime
FROM staging_octane.loan_charge_payer_item_source_type staging_table
LEFT JOIN history_octane.loan_charge_payer_item_source_type history_table
          ON staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;')
     , ('loan_charge_payer_item', 'SP-100830', 'lcpi_pid', '--finding records to insert into history_octane.loan_charge_payer_item
SELECT staging_table.lcpi_pid
     , staging_table.lcpi_version
     , staging_table.lcpi_item_amount
     , staging_table.lcpi_loan_charge_payer_item_source_type
     , staging_table.lcpi_loan_charge_pid
     , staging_table.lcpi_charge_payer_type
     , staging_table.lcpi_paid_by
     , staging_table.lcpi_poc
     , staging_table.lcpi_charge_wire_action_auto_compute
     , staging_table.lcpi_charge_wire_action_type
     , FALSE AS data_source_deleted_flag
     , NOW() AS data_source_updated_datetime
FROM staging_octane.loan_charge_payer_item staging_table
LEFT JOIN history_octane.loan_charge_payer_item history_table
          ON staging_table.lcpi_pid = history_table.lcpi_pid AND staging_table.lcpi_version = history_table.lcpi_version
WHERE history_table.prpc_pid IS NULL
UNION ALL
SELECT history_table.lcpi_pid
     , history_table.lcpi_version + 1
     , history_table.lcpi_item_amount
     , history_table.lcpi_loan_charge_payer_item_source_type
     , history_table.lcpi_loan_charge_pid
     , history_table.lcpi_charge_payer_type
     , history_table.lcpi_paid_by
     , history_table.lcpi_poc
     , history_table.lcpi_charge_wire_action_auto_compute
     , history_table.lcpi_charge_wire_action_type
     , TRUE AS data_source_deleted_flag
     , NOW() AS data_source_updated_datetime
FROM history_octane.loan_charge_payer_item history_table
LEFT JOIN staging_octane.loan_charge_payer_item staging_table
          ON staging_table.lcpi_pid = history_table.lcpi_pid
WHERE staging_table.lcpi_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.loan_charge_payer_item deleted_records
                  WHERE deleted_records.lcpi_pid = history_table.lcpi_pid
                    AND deleted_records.data_source_deleted_flag = TRUE )')
     , ('wf_prereq_set', 'SP-100831', 'wps_pid', '--finding records to insert into history_octane.wf_prereq_set
SELECT staging_table.wps_pid
     , staging_table.wps_version
     , staging_table.wps_account_pid
     , staging_table.wps_wf_prereq_set_name
     , FALSE AS data_source_deleted_flag
     , NOW() AS data_source_updated_datetime
FROM staging_octane.wf_prereq_set staging_table
LEFT JOIN history_octane.wf_prereq_set history_table
          ON staging_table.wps_pid = history_table.prpc_pid AND staging_table.prpc_version = history_table.prpc_version
WHERE history_table.wps_pid IS NULL
UNION ALL
SELECT history_table.wps_pid
     , history_table.wps_version + 1
     , history_table.wps_account_pid
     , history_table.wps_wf_prereq_set_name
     , TRUE AS data_source_deleted_flag
     , NOW() AS data_source_updated_datetime
FROM history_octane.wf_prereq_set history_table
LEFT JOIN staging_octane.wf_prereq_set staging_table
          ON staging_table.wps_pid = history_table.wps_pid
WHERE staging_table.wps_pid IS NULL
  AND NOT EXISTS (SELECT 1
                  FROM history_octane.wf_prereq_set deleted_records
                  WHERE deleted_records.wps_pid = history_table.wps_pid
                    AND deleted_records.data_source_deleted_flag = TRUE )')
     , ('wf_prereq', 'SP-100832', 'wp_pid', '--finding records to insert into history_octane.wf_prereq
SELECT staging_table.wp_pid
     , staging_table.wp_version
     , staging_table.wp_wf_prereq_set_pid
     , staging_table.wp_wf_step_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.wf_prereq staging_table
LEFT JOIN history_octane.wf_prereq history_table
          ON staging_table.wp_pid = history_table.wp_pid AND staging_table.wp_version = history_table.wp_version
WHERE history_table.wp_pid IS NULL
UNION ALL
SELECT history_table.wp_pid
     , history_table.wp_version + 1
     , history_table.wp_wf_prereq_set_pid
     , history_table.wp_wf_step_pid
     , TRUE AS data_source_deleted_flag
     , NOW() AS data_source_updated_datetime
FROM history_octane.wf_prereq history_table
LEFT JOIN staging_octane.wf_prereq staging_table
          ON staging_table.wp_pid = history_table.wp_pid
WHERE staging_table.wp_pid IS NULL
  AND NOT EXISTS (SELECT 1
                  FROM history_octane.wf_prereq deleted_records
                  WHERE deleted_records.wp_pid = history_table.wp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE )');

-- Insert process rows for all new tables
INSERT INTO mdi.process (name, description)
SELECT process_name, 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
FROM temp_new_table_mdi_data;

-- Update temp_mdi_data table with newly-inserted process dwids to avoid repetitive joins later
UPDATE temp_new_table_mdi_data
SET process_dwid = process.dwid
FROM mdi.process
WHERE temp_new_table_mdi_data.process_name = process.name;

-- Insert table_input_step rows for all new tables
INSERT INTO mdi.table_input_step (  process_dwid,
                                    data_source_dwid,
                                    sql,
                                    limit_size,
                                    execute_for_each_row,
                                    replace_variables,
                                    enable_lazy_conversion,
                                    cached_row_meta,
                                    connectionname)
SELECT temp_new_table_mdi_data.process_dwid
    , 1
    , temp_new_table_mdi_data.input_sql
    , 0
    , 'N'
    , 'N'
    , 'N'
    , 'N'
    , 'Staging DB Connection'
FROM temp_new_table_mdi_data;

-- Insert table_output_step rows for all new tables
INSERT INTO mdi.table_output_step (  process_dwid,
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
INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
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
INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT temp_new_table_mdi_data.process_dwid
    , 'Octane__' || temp_new_table_mdi_data.table_name
    , 'ETL to copy ' || temp_new_table_mdi_data.table_name || ' data from staging_octane to history_octane'
FROM temp_new_table_mdi_data;

-- Insert state_machine_step rows for all new tables
INSERT INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT temp_new_table_mdi_data.process_dwid, NULL
FROM temp_new_table_mdi_data;

-- Insert json_output_field rows for all new tables
INSERT INTO mdi.json_output_field (process_dwid, field_name)
SELECT temp_new_table_mdi_data.process_dwid, temp_new_table_mdi_data.json_output_field
FROM temp_new_table_mdi_data;




























