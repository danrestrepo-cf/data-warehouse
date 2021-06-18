--
-- Main | EDW | Octane Schema changes for 2021.6.3.1 (6/18/2021) (https://app.asana.com/0/0/1200488131634566 )
--

-- INSERT EDW_TABLE_DEFINITION ROWS FOR NEW TABLES: loan_charge_payer_item_source_type, loan_charge_payer_item, wf_prereq_set, wf_prereq
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

-- Update temp_mdi_data table WITH newly-inserted process dwids to avoid repetitive joins later
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



-- replace edw_field_definition for staging_octane.construction_cost.coc_calculation_percentage to coc_effective_construction_cost_calculation_percent SP-100161
UPDATE mdi.edw_field_definition
    SET field_name = 'coc_effective_construction_cost_calculation_percent'
    WHERE field_name = 'coc_calculation_percentage';

-- modify edw_*_definition data for changed fields

-- nullify source_edw_field_definition_dwid pointing to deleted field
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
FROM mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name IN ('lc_charge_payer_type','lc_paid_by','lc_poc','lc_charge_wire_action_auto_compute','lc_charge_wire_action_type')
    AND edw_table_definition.schema_name = 'history_octane';

-- remove fields from staging_octane.loan_cost from edw_field_definition
DELETE FROM mdi.edw_field_definition
WHERE edw_field_definition.field_name in ('lc_charge_payer_type','lc_paid_by','lc_poc','lc_charge_wire_action_auto_compute','lc_charge_wire_action_type')
    AND edw_field_definition.source_edw_field_definition_dwid IS NULL;

-- delete join definitions relying on the deleted field from edw_join_definition
DELETE
FROM mdi.edw_join_definition
WHERE join_condition LIKE '%lc_paid_by%'
    OR join_condition LIKE '%lc_charge_payer_type%'
    OR join_condition LIKE '%lc_poc%'
    OR join_condition LIKE '%lc_charge_wire_action_auto_compute%'
    OR join_condition LIKE '%lc_charge_wire_action_type%';

-- delete field from table_output_field
DELETE
FROM mdi.table_output_field
WHERE table_output_field.database_field_name IN ('lc_charge_payer_type','lc_paid_by','lc_poc','lc_charge_wire_action_auto_compute','lc_charge_wire_action_type');

-- add new column staging_octane.wf_step.ws_wf_prereq_set_pid and history_octane.wf_step.ws_wf_prereq_set_pid
WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='wf_step' and schema_name='staging_octane'), 'ws_wf_prereq_set_pid', FALSE, NULL,                                                     NULL, NULL, 'bigint', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='wf_step' and schema_name='history_octane'), 'ws_wf_prereq_set_pid', FALSE, (SELECT temp_staging_field.dwid from temp_staging_field), NULL, NULL, 'bigint', NULL, NULL, NULL, NULL))
SELECT 'Added apr_appraisal_invoice_amount to staging_octane.appraisal and history_octane.appraisal';

-- add new column staging_octane.appraisal.apr_appraisal_invoice_amount and history_octane.appraisal.apr_appraisal_invoice_amount
WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='appraisal' and schema_name='staging_octane'), 'apr_appraisal_invoice_amount', FALSE, NULL,                                                     NULL, NULL, 'numeric(17,2)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='appraisal' and schema_name='history_octane'), 'apr_appraisal_invoice_amount', FALSE, (SELECT temp_staging_field.dwid from temp_staging_field), NULL, NULL, 'numeric(17,2)', NULL, NULL, NULL, NULL))
SELECT 'Added apr_appraisal_invoice_amount to staging_octane.appraisal and history_octane.appraisal';

-- nullify source_edw_field_definition_dwid pointing to deleted field
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
FROM mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name = 'aprq_appraisal_fee_amount'
    AND edw_table_definition.schema_name = 'history_octane';

-- remove fields from staging_octane.loan_cost from edw_field_definition
DELETE FROM mdi.edw_field_definition
WHERE edw_field_definition.field_name = 'aprq_appraisal_fee_amount'
    AND edw_field_definition.source_edw_field_definition_dwid IS NULL;

-- delete join definitions relying on the deleted field from edw_join_definition
DELETE
FROM mdi.edw_join_definition
WHERE join_condition LIKE '%aprq_appraisal_fee_amount%';

-- delete field from table_output_field
DELETE
FROM mdi.table_output_field
WHERE table_output_field.database_field_name = 'aprq_appraisal_fee_amount';


-- add new column staging_octane.mcr_loan.mcrl_servicing_transfer_type and history_octane.mcr_loan.mcrl_servicing_transfer_type
WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='mcr_loan' and schema_name='staging_octane'), 'mcrl_servicing_transfer_type', FALSE, NULL,                                                     NULL, NULL, 'varchar(128)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='mcr_loan' and schema_name='history_octane'), 'mcrl_servicing_transfer_type', FALSE, (SELECT temp_staging_field.dwid FROM temp_staging_field), NULL, NULL, 'varchar(128)', NULL, NULL, NULL, NULL))
SELECT 'Added mcrl_servicing_transfer_type to staging_octane.mcr_loan and history_octane.mcr_loan';


-- nullify source_edw_field_definition_dwid pointing to deleted field
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
FROM mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name in (  'pl_refinance_improvements_type'
    ,'pl_refinance_proposed_improvements_description'
    ,'pl_refinance_total_improvement_costs_amount'
    ,'pl_construction_improvement_costs_amount'
    ,'pl_energy_improvement_replacement_major_system'
    ,'pl_energy_improvement_insulation_sealant'
    ,'pl_energy_improvement_installation_solar'
    ,'pl_energy_improvement_addition_new_feature'
    ,'pl_energy_improvement_other'
    ,'pl_energy_related_repairs_or_improvements_amount'
    ,'pl_refinance_general_improvements_amount')
    AND edw_table_definition.schema_name = 'history_octane';


-- remove fields from staging_octane.place from edw_field_definition
DELETE FROM mdi.edw_field_definition
WHERE edw_field_definition.field_name in (  'pl_refinance_improvements_type'
                                            ,'pl_refinance_proposed_improvements_description'
                                            ,'pl_refinance_total_improvement_costs_amount'
                                            ,'pl_construction_improvement_costs_amount'
                                            ,'pl_energy_improvement_replacement_major_system'
                                            ,'pl_energy_improvement_insulation_sealant'
                                            ,'pl_energy_improvement_installation_solar'
                                            ,'pl_energy_improvement_addition_new_feature'
                                            ,'pl_energy_improvement_other'
                                            ,'pl_energy_related_repairs_or_improvements_amount'
                                            ,'pl_refinance_general_improvements_amount')
    AND edw_field_definition.source_edw_field_definition_dwid IS NULL;



-- delete join definitions relying on the deleted field from edw_join_definition
DELETE
FROM mdi.edw_join_definition
WHERE join_condition LIKE '%pl_refinance_improvements_type%'
    OR join_condition LIKE '%pl_refinance_proposed_improvements_description%'
    OR join_condition LIKE '%pl_refinance_total_improvement_costs_amount%'
    OR join_condition LIKE '%pl_construction_improvement_costs_amount%'
    OR join_condition LIKE '%pl_energy_improvement_replacement_major_system%'
    OR join_condition LIKE '%pl_energy_improvement_insulation_sealant%'
    OR join_condition LIKE '%pl_energy_improvement_installation_solar%'
    OR join_condition LIKE '%pl_energy_improvement_addition_new_feature%'
    OR join_condition LIKE '%pl_energy_improvement_other%'
    OR join_condition LIKE '%pl_energy_related_repairs_or_improvements_amount%'
    OR join_condition LIKE '%pl_refinance_general_improvements_amount%';


-- delete field from table_output_field
DELETE
FROM mdi.table_output_field
WHERE table_output_field.database_field_name in (  'pl_refinance_improvements_type'
    ,'pl_refinance_proposed_improvements_description'
    ,'pl_refinance_total_improvement_costs_amount'
    ,'pl_construction_improvement_costs_amount'
    ,'pl_energy_improvement_replacement_major_system'
    ,'pl_energy_improvement_insulation_sealant'
    ,'pl_energy_improvement_installation_solar'
    ,'pl_energy_improvement_addition_new_feature'
    ,'pl_energy_improvement_other'
    ,'pl_energy_related_repairs_or_improvements_amount'
    ,'pl_refinance_general_improvements_amount');


-- add new column staging_octane.proposal.prp_financed_property_improvements and history_octane.proposal.prp_financed_property_improvements
WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='staging_octane'), 'prp_financed_property_improvements', FALSE, NULL,                    NULL, NULL, 'boolean', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='history_octane'), 'prp_financed_property_improvements', FALSE, (SELECT temp_staging_field.dwid from temp_staging_field), NULL, NULL, 'boolean', NULL, NULL, NULL, NULL))
SELECT 'Added prp_financed_property_improvements to staging_octane.proposal and history_octane.proposal';

-- add new column staging_octane.proposal.prp_estimated_hard_construction_cost_amount and history_octane.proposal.prp_estimated_hard_construction_cost_amount
WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='staging_octane'), 'prp_estimated_hard_construction_cost_amount', FALSE, NULL,                        NULL, NULL, 'bigint', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='history_octane'), 'prp_estimated_hard_construction_cost_amount', FALSE, (SELECT temp_staging_field.dwid from temp_staging_field), NULL, NULL, 'bigint', NULL, NULL, NULL, NULL))
SELECT 'Added prp_estimated_hard_construction_cost_amount to staging_octane.proposal and history_octane.proposal';

-- add new column staging_octane.proposal.prp_financed_property_improvements and history_octane.proposal.prp_financed_property_improvements
WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='staging_octane'), 'prp_financed_property_improvements', FALSE, NULL,                    NULL, NULL, 'boolean', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='history_octane'), 'prp_financed_property_improvements', FALSE, (SELECT temp_staging_field.dwid from temp_staging_field), NULL, NULL, 'boolean', NULL, NULL, NULL, NULL))
SELECT 'Added prp_financed_property_improvements to staging_octane.proposal and history_octane.proposal';

WITH temp_staging_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='staging_octane'), 'prp_estimated_hard_construction_cost_amount', FALSE, NULL,                        NULL, NULL, 'bigint', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='proposal' and schema_name='history_octane'), 'prp_estimated_hard_construction_cost_amount', FALSE, (SELECT temp_staging_field.dwid from temp_staging_field), NULL, NULL, 'bigint', NULL, NULL, NULL, NULL))
SELECT 'Added prp_estimated_hard_construction_cost_amount to staging_octane.proposal and history_octane.proposal';

-- add new columns to staging_octane.construction_cost and history_octane.construction_cost
WITH temp_staging_field_01 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_calculated_construction_cost_percent', FALSE, NULL,                                     NULL, NULL, 'numeric(11,9)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_01 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_calculated_construction_cost_percent', FALSE, (SELECT dwid from temp_staging_field_01), NULL, NULL, 'numeric(11,9)', NULL, NULL, NULL, NULL)),

    temp_staging_field_02 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_overridden_construction_cost_percent', FALSE, NULL,                                     NULL, NULL, 'numeric(11,9)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_02 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_overridden_construction_cost_percent', FALSE, (SELECT dwid from temp_staging_field_02), NULL, NULL, 'numeric(11,9)', NULL, NULL, NULL, NULL)),

    temp_staging_field_03 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_construction_cost_calculation_percent_override_reason', FALSE, NULL,                                     NULL, NULL, 'varchar(1024)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_03 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_construction_cost_calculation_percent_override_reason', FALSE, (SELECT dwid from temp_staging_field_03), NULL, NULL, 'varchar(1024)', NULL, NULL, NULL, NULL)),

    temp_staging_field_04 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_calculated_construction_cost_months', FALSE, NULL,                                          NULL, NULL, 'integer', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_04 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_calculated_construction_cost_months', FALSE, (SELECT dwid from temp_staging_field_04), NULL, NULL, 'integer', NULL, NULL, NULL, NULL)),

    temp_staging_field_05 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_overridden_construction_cost_months', FALSE, NULL,                                     NULL, NULL, 'integer', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_05 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_overridden_construction_cost_months', FALSE, (SELECT dwid from temp_staging_field_05), NULL, NULL, 'integer', NULL, NULL, NULL, NULL)),

    temp_staging_field_06 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_effective_construction_cost_months', FALSE, NULL,                                     NULL, NULL, 'integer', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_06 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_effective_construction_cost_months', FALSE, (SELECT dwid from temp_staging_field_06), NULL, NULL, 'integer', NULL, NULL, NULL, NULL)),

    temp_staging_field_07 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_construction_cost_months_override_reason', FALSE, NULL,                                     NULL, NULL, 'varchar(1024)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_07 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
        VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_construction_cost_months_override_reason', FALSE, (SELECT dwid from temp_staging_field_07), NULL, NULL, 'varchar(1024)', NULL, NULL, NULL, NULL)),

    temp_staging_field_08 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_charge_type', FALSE, NULL,                                     NULL, NULL, 'varchar(128)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_08 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_charge_type', FALSE, (SELECT dwid from temp_staging_field_08), NULL, NULL, 'varchar(128)', NULL, NULL, NULL, NULL)),

    temp_staging_field_09 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_draw_discrepancy_text', FALSE, NULL,                                     NULL, NULL, 'varchar(1024)', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_09 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_draw_discrepancy_text', FALSE, (SELECT dwid from temp_staging_field_09), NULL, NULL, 'varchar(1024)', NULL, NULL, NULL, NULL)),

    temp_staging_field_10 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='staging_octane'), 'coc_impeding_draw_discrepancy', FALSE, NULL,                                          NULL, NULL, 'boolean', NULL, NULL, NULL, NULL) RETURNING dwid),
    temp_history_field_10 as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
    VALUES  ((SELECT dwid FROM mdi.edw_table_definition WHERE table_name='construction_cost' and schema_name='history_octane'), 'coc_impeding_draw_discrepancy', FALSE, (SELECT dwid from temp_staging_field_10), NULL, NULL, 'boolean', NULL, NULL, NULL, NULL))

    SELECT 'Added coc_calculated_construction_cost_percent, coc_overridden_construction_cost_percent, coc_construction_cost_calculation_percent_override_reason, coc_calculated_construction_cost_months, coc_overridden_construction_cost_months, coc_effective_construction_cost_months, coc_construction_cost_months_override_reason, coc_charge_type, coc_draw_discrepancy_text, and coc_impeding_draw_discrepancy to staging_octane.construction_cost and history_octane.construction_cost';



-- modify etls for changed tables (staging->history)
--- staging_octane.loan_charge -- SP-100156
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.loan_charge
SELECT staging_table.lc_pid, staging_table.lc_version, staging_table.lc_proposal_pid, staging_table.lc_obligation_pid, staging_table.lc_account_charge_ordinal, staging_table.lc_loan_position_type, staging_table.lc_charge_type, staging_table.lc_name, staging_table.lc_charge_payee_type, staging_table.lc_paid_to, staging_table.lc_poc_applicable, staging_table.lc_reduction_amount, staging_table.lc_apr, staging_table.lc_base_amount, staging_table.lc_configured_total_amount, staging_table.lc_total_amount, staging_table.lc_charge_input_type, staging_table.lc_charge_input_type_base_amount, staging_table.lc_charge_input_type_percent, staging_table.lc_charge_input_type_currency, staging_table.lc_hud_section_number, staging_table.lc_hud_line_number, staging_table.lc_user_defined, staging_table.lc_months_auto_compute, staging_table.lc_months, staging_table.lc_per_diem_amount, staging_table.lc_per_diem_rate, staging_table.lc_days, staging_table.lc_financed, staging_table.lc_financed_auto_compute, staging_table.lc_financed_amount, staging_table.lc_auto_compute, staging_table.lc_charge_source_type, staging_table.lc_obligation_charge_input_type, staging_table.lc_from_date, staging_table.lc_through_date, staging_table.lc_smart_charge_config_warning, staging_table.lc_reduction_amount_warning, staging_table.lc_advance_amount_warning, staging_table.lc_fha_mip_refund_warning, staging_table.lc_aggregate_adjustment_compute_warning, staging_table.lc_advance_obligation_compute_warning, staging_table.lc_escrow_obligation_compute_warning, staging_table.lc_excess_financing_concession_warning, staging_table.lc_amount_exceeds_cap_warning, staging_table.lc_subtract_lenders_title_insurance_amount, staging_table.lc_lender_insurance_exceeds_owner_insurance_warning, staging_table.lc_manual_circumstance_change_type_1, staging_table.lc_manual_circumstance_change_type_2, staging_table.lc_configured_charge_payer_type, staging_table.lc_configured_charge_payee_type, staging_table.lc_configured_paid_by, staging_table.lc_configured_paid_to, staging_table.lc_configured_poc, staging_table.lc_configured_financed, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.loan_charge staging_table
LEFT JOIN history_octane.loan_charge history_table on staging_table.lc_pid = history_table.lc_pid and staging_table.lc_version = history_table.lc_version
WHERE history_table.lc_pid is NULL
UNION ALL
SELECT history_table.lc_pid, history_table.lc_version+1, history_table.lc_proposal_pid, history_table.lc_obligation_pid, history_table.lc_account_charge_ordinal, history_table.lc_loan_position_type, history_table.lc_charge_type, history_table.lc_name, history_table.lc_charge_payee_type, history_table.lc_paid_to, history_table.lc_poc_applicable, history_table.lc_reduction_amount, history_table.lc_apr, history_table.lc_base_amount, history_table.lc_configured_total_amount, history_table.lc_total_amount, history_table.lc_charge_input_type, history_table.lc_charge_input_type_base_amount, history_table.lc_charge_input_type_percent, history_table.lc_charge_input_type_currency, history_table.lc_hud_section_number, history_table.lc_hud_line_number, history_table.lc_user_defined, history_table.lc_months_auto_compute, history_table.lc_months, history_table.lc_per_diem_amount, history_table.lc_per_diem_rate, history_table.lc_days, history_table.lc_financed, history_table.lc_financed_auto_compute, history_table.lc_financed_amount, history_table.lc_auto_compute, history_table.lc_charge_source_type, history_table.lc_obligation_charge_input_type, history_table.lc_from_date, history_table.lc_through_date, history_table.lc_smart_charge_config_warning, history_table.lc_reduction_amount_warning, history_table.lc_advance_amount_warning, history_table.lc_fha_mip_refund_warning, history_table.lc_aggregate_adjustment_compute_warning, history_table.lc_advance_obligation_compute_warning, history_table.lc_escrow_obligation_compute_warning, history_table.lc_excess_financing_concession_warning, history_table.lc_amount_exceeds_cap_warning, history_table.lc_subtract_lenders_title_insurance_amount, history_table.lc_lender_insurance_exceeds_owner_insurance_warning, history_table.lc_manual_circumstance_change_type_1, history_table.lc_manual_circumstance_change_type_2, history_table.lc_configured_charge_payer_type, history_table.lc_configured_charge_payee_type, history_table.lc_configured_paid_by, history_table.lc_configured_paid_to, history_table.lc_configured_poc, history_table.lc_configured_financed, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.loan_charge history_table
LEFT JOIN staging_octane.loan_charge staging_table on staging_table.lc_pid = history_table.lc_pid
WHERE staging_table.lc_pid is NULL
    AND not exists (select 1 from history_octane.loan_charge deleted_records where deleted_records.lc_pid = history_table.lc_pid and deleted_records.data_source_deleted_flag = True);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100156');

--- staging_octane.wf_step --SP-100191
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.wf_step
SELECT staging_table.ws_wf_prereq_set_pid, staging_table.ws_pid, staging_table.ws_version, staging_table.ws_wf_process_pid, staging_table.ws_step_name, staging_table.ws_step_number, staging_table.ws_step_number_formatted, staging_table.ws_step_number_name_formatted, staging_table.ws_step_start_borrower_text, staging_table.ws_expected_complete_minutes, staging_table.ws_wf_step_timeout_type, staging_table.ws_second_of_day_timeout, staging_table.ws_timeout_time_zone_type, staging_table.ws_description, staging_table.ws_wf_step_type, staging_table.ws_wf_phase_pid, staging_table.ws_wf_step_performer_assign_type, staging_table.ws_role_pid, staging_table.ws_from_role_pid, staging_table.ws_wf_step_reassign_type, staging_table.ws_wf_step_function_type, staging_table.ws_sap_expire_minutes, staging_table.ws_sap_expire_warning_minutes, staging_table.ws_prompt_user_defined_time, staging_table.ws_smart_message_pid, staging_table.ws_smart_doc_set_pid, staging_table.ws_lien_priority_type, staging_table.ws_active_only, staging_table.ws_internal, staging_table.ws_deal_stage_type, staging_table.ws_polling_interval_type, staging_table.ws_swappable, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.wf_step staging_table
LEFT JOIN history_octane.wf_step history_table on staging_table.ws_pid = history_table.ws_pid and staging_table.ws_version = history_table.ws_version
WHERE history_table.ws_pid is NULL
UNION ALL
SELECT history_table.ws_wf_prereq_set_pid, history_table.ws_pid, history_table.ws_version+1, history_table.ws_wf_process_pid, history_table.ws_step_name, history_table.ws_step_number, history_table.ws_step_number_formatted, history_table.ws_step_number_name_formatted, history_table.ws_step_start_borrower_text, history_table.ws_expected_complete_minutes, history_table.ws_wf_step_timeout_type, history_table.ws_second_of_day_timeout, history_table.ws_timeout_time_zone_type, history_table.ws_description, history_table.ws_wf_step_type, history_table.ws_wf_phase_pid, history_table.ws_wf_step_performer_assign_type, history_table.ws_role_pid, history_table.ws_from_role_pid, history_table.ws_wf_step_reassign_type, history_table.ws_wf_step_function_type, history_table.ws_sap_expire_minutes, history_table.ws_sap_expire_warning_minutes, history_table.ws_prompt_user_defined_time, history_table.ws_smart_message_pid, history_table.ws_smart_doc_set_pid, history_table.ws_lien_priority_type, history_table.ws_active_only, history_table.ws_internal, history_table.ws_deal_stage_type, history_table.ws_polling_interval_type, history_table.ws_swappable, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.wf_step history_table
LEFT JOIN staging_octane.wf_step staging_table on staging_table.ws_pid = history_table.ws_pid
WHERE staging_table.ws_pid is NULL
    AND not exists (select 1 from history_octane.wf_step deleted_records where deleted_records.ws_pid = history_table.ws_pid and deleted_records.data_source_deleted_flag = True);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100191');

--- appraisal --SP-100005
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.appraisal
SELECT staging_table.apr_appraisal_invoice_amount, staging_table.apr_pid, staging_table.apr_version, staging_table.apr_appraised_value_amount, staging_table.apr_effective_date, staging_table.apr_deal_pid, staging_table.apr_decision_appraisal, staging_table.apr_appraisal_condition_type, staging_table.apr_appraiser_address_city, staging_table.apr_appraiser_address_country, staging_table.apr_appraiser_address_postal_code, staging_table.apr_appraiser_address_state, staging_table.apr_appraiser_address_street1, staging_table.apr_appraiser_address_street2, staging_table.apr_appraiser_company_name, staging_table.apr_appraiser_email, staging_table.apr_appraiser_fax, staging_table.apr_appraiser_first_name, staging_table.apr_appraiser_last_name, staging_table.apr_appraiser_middle_name, staging_table.apr_appraiser_mobile_phone, staging_table.apr_appraiser_name_suffix, staging_table.apr_appraiser_office_phone, staging_table.apr_appraiser_office_phone_extension, staging_table.apr_appraiser_title, staging_table.apr_appraiser_license_number, staging_table.apr_appraiser_supervisory_license_number, staging_table.apr_appraiser_license_state, staging_table.apr_appraisal_order_status_type, staging_table.apr_appraisal_order_id, staging_table.apr_appraisal_order_instructions, staging_table.apr_property_address_city, staging_table.apr_property_address_country, staging_table.apr_property_address_postal_code, staging_table.apr_property_address_state, staging_table.apr_property_address_street1, staging_table.apr_property_address_street2, staging_table.apr_property_county_name, staging_table.apr_obtained_from_transfer, staging_table.apr_hud_provided, staging_table.apr_bedroom_count_unit_1, staging_table.apr_bedroom_count_unit_2, staging_table.apr_bedroom_count_unit_3, staging_table.apr_bedroom_count_unit_4, staging_table.apr_bathroom_count_unit_1, staging_table.apr_bathroom_count_unit_2, staging_table.apr_bathroom_count_unit_3, staging_table.apr_bathroom_count_unit_4, staging_table.apr_total_room_count_unit_1, staging_table.apr_total_room_count_unit_2, staging_table.apr_total_room_count_unit_3, staging_table.apr_total_room_count_unit_4, staging_table.apr_gross_living_area_square_feet_unit_1, staging_table.apr_gross_living_area_square_feet_unit_2, staging_table.apr_gross_living_area_square_feet_unit_3, staging_table.apr_gross_living_area_square_feet_unit_4, staging_table.apr_appraisal_underwriter_type, staging_table.apr_ucdp_doc_file_id, staging_table.apr_inspection_date, staging_table.apr_appraisal_reference_id, staging_table.apr_ucdp_ssr_id, staging_table.apr_sale_price_amount, staging_table.apr_property_tax_id, staging_table.apr_property_category_type, staging_table.apr_cost_to_build_new, staging_table.apr_monthly_hoa_amount, staging_table.apr_structure_built_year, staging_table.apr_structure_built_month, staging_table.apr_project_name, staging_table.apr_road_type, staging_table.apr_water_type, staging_table.apr_sanitation_type, staging_table.apr_neighborhood_location_type, staging_table.apr_site_area, staging_table.apr_due_date, staging_table.apr_order_date, staging_table.apr_payment_type, staging_table.apr_payment_received_date, staging_table.apr_appraisal_source_type, staging_table.apr_appraisal_purpose_type, staging_table.apr_exclude, staging_table.apr_order_appraisal, staging_table.apr_appraisal_id, staging_table.apr_mortgage_type, staging_table.apr_remaining_economic_life_years, staging_table.apr_deficient_economic_life_explanation, staging_table.apr_hve_point_value_estimate_amount, staging_table.apr_hve_forecast_standard_deviation_percent, staging_table.apr_hve_confidence_level_type, staging_table.apr_hve_variance_percent, staging_table.apr_hve_excessive_value_message, staging_table.apr_cu_risk_score, staging_table.apr_license_expiration_date, staging_table.apr_supervisor_required, staging_table.apr_supervisory_appraiser_first_name, staging_table.apr_supervisory_appraiser_middle_name, staging_table.apr_supervisory_appraiser_last_name, staging_table.apr_supervisory_appraiser_name_suffix, staging_table.apr_supervisory_license_state, staging_table.apr_supervisory_license_expiration_date, staging_table.apr_synthetic_unique, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.appraisal staging_table
    LEFT JOIN history_octane.appraisal history_table on staging_table.apr_pid = history_table.apr_pid and staging_table.apr_version = history_table.apr_version
WHERE history_table.apr_pid is NULL
UNION ALL
SELECT history_table.apr_appraisal_invoice_amount, history_table.apr_pid, history_table.apr_version+1, history_table.apr_appraised_value_amount, history_table.apr_effective_date, history_table.apr_deal_pid, history_table.apr_decision_appraisal, history_table.apr_appraisal_condition_type, history_table.apr_appraiser_address_city, history_table.apr_appraiser_address_country, history_table.apr_appraiser_address_postal_code, history_table.apr_appraiser_address_state, history_table.apr_appraiser_address_street1, history_table.apr_appraiser_address_street2, history_table.apr_appraiser_company_name, history_table.apr_appraiser_email, history_table.apr_appraiser_fax, history_table.apr_appraiser_first_name, history_table.apr_appraiser_last_name, history_table.apr_appraiser_middle_name, history_table.apr_appraiser_mobile_phone, history_table.apr_appraiser_name_suffix, history_table.apr_appraiser_office_phone, history_table.apr_appraiser_office_phone_extension, history_table.apr_appraiser_title, history_table.apr_appraiser_license_number, history_table.apr_appraiser_supervisory_license_number, history_table.apr_appraiser_license_state, history_table.apr_appraisal_order_status_type, history_table.apr_appraisal_order_id, history_table.apr_appraisal_order_instructions, history_table.apr_property_address_city, history_table.apr_property_address_country, history_table.apr_property_address_postal_code, history_table.apr_property_address_state, history_table.apr_property_address_street1, history_table.apr_property_address_street2, history_table.apr_property_county_name, history_table.apr_obtained_from_transfer, history_table.apr_hud_provided, history_table.apr_bedroom_count_unit_1, history_table.apr_bedroom_count_unit_2, history_table.apr_bedroom_count_unit_3, history_table.apr_bedroom_count_unit_4, history_table.apr_bathroom_count_unit_1, history_table.apr_bathroom_count_unit_2, history_table.apr_bathroom_count_unit_3, history_table.apr_bathroom_count_unit_4, history_table.apr_total_room_count_unit_1, history_table.apr_total_room_count_unit_2, history_table.apr_total_room_count_unit_3, history_table.apr_total_room_count_unit_4, history_table.apr_gross_living_area_square_feet_unit_1, history_table.apr_gross_living_area_square_feet_unit_2, history_table.apr_gross_living_area_square_feet_unit_3, history_table.apr_gross_living_area_square_feet_unit_4, history_table.apr_appraisal_underwriter_type, history_table.apr_ucdp_doc_file_id, history_table.apr_inspection_date, history_table.apr_appraisal_reference_id, history_table.apr_ucdp_ssr_id, history_table.apr_sale_price_amount, history_table.apr_property_tax_id, history_table.apr_property_category_type, history_table.apr_cost_to_build_new, history_table.apr_monthly_hoa_amount, history_table.apr_structure_built_year, history_table.apr_structure_built_month, history_table.apr_project_name, history_table.apr_road_type, history_table.apr_water_type, history_table.apr_sanitation_type, history_table.apr_neighborhood_location_type, history_table.apr_site_area, history_table.apr_due_date, history_table.apr_order_date, history_table.apr_payment_type, history_table.apr_payment_received_date, history_table.apr_appraisal_source_type, history_table.apr_appraisal_purpose_type, history_table.apr_exclude, history_table.apr_order_appraisal, history_table.apr_appraisal_id, history_table.apr_mortgage_type, history_table.apr_remaining_economic_life_years, history_table.apr_deficient_economic_life_explanation, history_table.apr_hve_point_value_estimate_amount, history_table.apr_hve_forecast_standard_deviation_percent, history_table.apr_hve_confidence_level_type, history_table.apr_hve_variance_percent, history_table.apr_hve_excessive_value_message, history_table.apr_cu_risk_score, history_table.apr_license_expiration_date, history_table.apr_supervisor_required, history_table.apr_supervisory_appraiser_first_name, history_table.apr_supervisory_appraiser_middle_name, history_table.apr_supervisory_appraiser_last_name, history_table.apr_supervisory_appraiser_name_suffix, history_table.apr_supervisory_license_state, history_table.apr_supervisory_license_expiration_date, history_table.apr_synthetic_unique, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.appraisal history_table
    LEFT JOIN staging_octane.appraisal staging_table on staging_table.apr_pid = history_table.apr_pid
WHERE staging_table.apr_pid is NULL
    AND not exists (select 1 from history_octane.appraisal deleted_records where deleted_records.apr_pid = history_table.apr_pid and deleted_records.data_source_deleted_flag = True);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100005');

--- appraisal_order_request --SP-100302
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.appraisal_order_request
SELECT staging_table.aprq_pid, staging_table.aprq_version, staging_table.aprq_deal_pid, staging_table.aprq_appraisal_pid, staging_table.aprq_mercury_network_status_request_pid, staging_table.aprq_appraisal_order_coarse_status_type, staging_table.aprq_order_id, staging_table.aprq_order_instructions, staging_table.aprq_address_street1, staging_table.aprq_address_street2, staging_table.aprq_address_city, staging_table.aprq_address_state, staging_table.aprq_address_postal_code, staging_table.aprq_order_request_date, staging_table.aprq_response_xml_deal_system_file_pid, staging_table.aprq_mismo_xml_deal_system_file_pid, staging_table.aprq_appraisal_order_request_type, staging_table.aprq_status_check_datetime, staging_table.aprq_appraisal_management_company_type, staging_table.aprq_requester_lender_user_pid, staging_table.aprq_requester_unparsed_name, staging_table.aprq_requester_agent_type, staging_table.aprq_vendor_status_unique_id, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.appraisal_order_request staging_table
LEFT JOIN history_octane.appraisal_order_request history_table on staging_table.aprq_pid = history_table.aprq_pid and staging_table.aprq_version = history_table.aprq_version
WHERE history_table.aprq_pid is NULL
UNION ALL
SELECT history_table.aprq_pid, history_table.aprq_version+1, history_table.aprq_deal_pid, history_table.aprq_appraisal_pid, history_table.aprq_mercury_network_status_request_pid, history_table.aprq_appraisal_order_coarse_status_type, history_table.aprq_order_id, history_table.aprq_order_instructions, history_table.aprq_address_street1, history_table.aprq_address_street2, history_table.aprq_address_city, history_table.aprq_address_state, history_table.aprq_address_postal_code, history_table.aprq_order_request_date, history_table.aprq_response_xml_deal_system_file_pid, history_table.aprq_mismo_xml_deal_system_file_pid, history_table.aprq_appraisal_order_request_type, history_table.aprq_status_check_datetime, history_table.aprq_appraisal_management_company_type, history_table.aprq_requester_lender_user_pid, history_table.aprq_requester_unparsed_name, history_table.aprq_requester_agent_type, history_table.aprq_vendor_status_unique_id, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.appraisal_order_request history_table
LEFT JOIN staging_octane.appraisal_order_request staging_table on staging_table.aprq_pid = history_table.aprq_pid
WHERE staging_table.aprq_pid is NULL
    AND not exists (select 1 from history_octane.appraisal_order_request deleted_records where deleted_records.aprq_pid = history_table.aprq_pid and deleted_records.data_source_deleted_flag = True);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100302');

--- mcr_loan --SP-100042
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.mcr_loan
SELECT staging_table.mcrl_servicing_transfer_type, staging_table.mcrl_pid, staging_table.mcrl_version, staging_table.mcrl_loan_pid, staging_table.mcrl_mcr_snapshot_pid, staging_table.mcrl_los_loan_id, staging_table.mcrl_originator_nmls_id, staging_table.mcrl_loan_amount, staging_table.mcrl_lien_priority_type, staging_table.mcrl_mortgage_type, staging_table.mcrl_interest_only_type, staging_table.mcrl_prepay_penalty_schedule_type, staging_table.mcrl_ltv_ratio_percent, staging_table.mcrl_note_rate_percent, staging_table.mcrl_hmda_action_type, staging_table.mcrl_hmda_action_date, staging_table.mcrl_disclosure_mode_date, staging_table.mcrl_decision_credit_score, staging_table.mcrl_property_usage_type, staging_table.mcrl_doc_level_type, staging_table.mcrl_loan_purpose_type, staging_table.mcrl_mi_required, staging_table.mcrl_proposal_structure_type, staging_table.mcrl_subject_property_state, staging_table.mcrl_property_category_type, staging_table.mcrl_cltv_ratio_percent, staging_table.mcrl_funding_status_type, staging_table.mcrl_funding_date, staging_table.mcrl_loan_amortization_type, staging_table.mcrl_product_special_program_type, staging_table.mcrl_non_conforming, staging_table.mcrl_initial_payment_adjustment_term_months, staging_table.mcrl_subsequent_payment_adjustment_term_months, staging_table.mcrl_fund_source_type, staging_table.mcrl_channel_type, staging_table.mcrl_financed_units_count, staging_table.mcrl_cash_out_reason_home_improvement, staging_table.mcrl_hmda_hoepa_status_type, staging_table.mcrl_qualified_mortgage_status_type, staging_table.mcrl_lender_fee_total_amount, staging_table.mcrl_broker_fee_total_amount, staging_table.mcrl_investor_hmda_purchaser_of_loan_type, staging_table.mcrl_confirmed_release_datetime, staging_table.mcrl_purchase_advice_date, staging_table.mcrl_purchasing_beneficiary_investor_pid, staging_table.mcrl_mcr_loan_status_type, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.mcr_loan staging_table
LEFT JOIN history_octane.mcr_loan history_table on staging_table.mcrl_pid = history_table.mcrl_pid and staging_table.mcrl_version = history_table.mcrl_version
WHERE history_table.mcrl_pid is NULL
UNION ALL
SELECT history_table.mcrl_servicing_transfer_type, history_table.mcrl_pid, history_table.mcrl_version+1, history_table.mcrl_loan_pid, history_table.mcrl_mcr_snapshot_pid, history_table.mcrl_los_loan_id, history_table.mcrl_originator_nmls_id, history_table.mcrl_loan_amount, history_table.mcrl_lien_priority_type, history_table.mcrl_mortgage_type, history_table.mcrl_interest_only_type, history_table.mcrl_prepay_penalty_schedule_type, history_table.mcrl_ltv_ratio_percent, history_table.mcrl_note_rate_percent, history_table.mcrl_hmda_action_type, history_table.mcrl_hmda_action_date, history_table.mcrl_disclosure_mode_date, history_table.mcrl_decision_credit_score, history_table.mcrl_property_usage_type, history_table.mcrl_doc_level_type, history_table.mcrl_loan_purpose_type, history_table.mcrl_mi_required, history_table.mcrl_proposal_structure_type, history_table.mcrl_subject_property_state, history_table.mcrl_property_category_type, history_table.mcrl_cltv_ratio_percent, history_table.mcrl_funding_status_type, history_table.mcrl_funding_date, history_table.mcrl_loan_amortization_type, history_table.mcrl_product_special_program_type, history_table.mcrl_non_conforming, history_table.mcrl_initial_payment_adjustment_term_months, history_table.mcrl_subsequent_payment_adjustment_term_months, history_table.mcrl_fund_source_type, history_table.mcrl_channel_type, history_table.mcrl_financed_units_count, history_table.mcrl_cash_out_reason_home_improvement, history_table.mcrl_hmda_hoepa_status_type, history_table.mcrl_qualified_mortgage_status_type, history_table.mcrl_lender_fee_total_amount, history_table.mcrl_broker_fee_total_amount, history_table.mcrl_investor_hmda_purchaser_of_loan_type, history_table.mcrl_confirmed_release_datetime, history_table.mcrl_purchase_advice_date, history_table.mcrl_purchasing_beneficiary_investor_pid, history_table.mcrl_mcr_loan_status_type, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.mcr_loan history_table
LEFT JOIN staging_octane.mcr_loan staging_table on staging_table.mcrl_pid = history_table.mcrl_pid
WHERE staging_table.mcrl_pid is NULL
    AND not exists (select 1 from history_octane.mcr_loan deleted_records where deleted_records.mcrl_pid = history_table.mcrl_pid and deleted_records.data_source_deleted_flag = True);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100042');

--- place --SP-100012
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.place
SELECT staging_table.pl_pid, staging_table.pl_version, staging_table.pl_proposal_pid, staging_table.pl_subject_property, staging_table.pl_acquisition_date, staging_table.pl_financed_units_count, staging_table.pl_unit_count, staging_table.pl_land_estimated_value_amount, staging_table.pl_land_original_cost_amount, staging_table.pl_leasehold_expiration_date, staging_table.pl_legal_description_type, staging_table.pl_legal_description, staging_table.pl_property_tax_id, staging_table.pl_legal_lot, staging_table.pl_legal_block, staging_table.pl_legal_section, staging_table.pl_project_name, staging_table.pl_cpm_project_id, staging_table.pl_acquisition_cost_amount, staging_table.pl_county_pid, staging_table.pl_sub_jurisdiction_name, staging_table.pl_recording_district_name, staging_table.pl_project_classification_type, staging_table.pl_property_category_type, staging_table.pl_property_rights_type, staging_table.pl_structure_built_year, staging_table.pl_structure_built_month, staging_table.pl_title_manner_held_type, staging_table.pl_title_manner_held_description, staging_table.pl_building_status_type, staging_table.pl_construction_conversion, staging_table.pl_native_american_lands_type, staging_table.pl_community_land_trust, staging_table.pl_inclusionary_zoning, staging_table.pl_unique_dwelling_type, staging_table.pl_living_unit_count, staging_table.pl_project_design_type, staging_table.pl_city, staging_table.pl_country, staging_table.pl_postal_code, staging_table.pl_state, staging_table.pl_street1, staging_table.pl_street2, staging_table.pl_street_tbd, staging_table.pl_landlord_first_name, staging_table.pl_landlord_last_name, staging_table.pl_landlord_middle_name, staging_table.pl_landlord_name_suffix, staging_table.pl_landlord_company_name, staging_table.pl_landlord_title, staging_table.pl_landlord_office_phone, staging_table.pl_landlord_office_phone_extension, staging_table.pl_landlord_mobile_phone, staging_table.pl_landlord_email, staging_table.pl_landlord_fax, staging_table.pl_landlord_city, staging_table.pl_landlord_country, staging_table.pl_landlord_postal_code, staging_table.pl_landlord_state, staging_table.pl_landlord_street1, staging_table.pl_landlord_street2, staging_table.pl_management_first_name, staging_table.pl_management_last_name, staging_table.pl_management_middle_name, staging_table.pl_management_name_suffix, staging_table.pl_management_company_name, staging_table.pl_management_title, staging_table.pl_management_office_phone, staging_table.pl_management_office_phone_extension, staging_table.pl_management_mobile_phone, staging_table.pl_management_email, staging_table.pl_management_fax, staging_table.pl_management_city, staging_table.pl_management_country, staging_table.pl_management_postal_code, staging_table.pl_management_state, staging_table.pl_management_street1, staging_table.pl_management_street2, staging_table.pl_property_insurance_amount_input_type, staging_table.pl_property_tax_amount_input_type, staging_table.pl_annual_property_insurance_amount, staging_table.pl_annual_property_tax_amount, staging_table.pl_monthly_property_insurance_amount, staging_table.pl_monthly_hoa_amount, staging_table.pl_monthly_mi_amount, staging_table.pl_monthly_property_tax_amount, staging_table.pl_monthly_lease_ground_rent_amount, staging_table.pl_monthly_rent_amount, staging_table.pl_monthly_obligation_amount, staging_table.pl_use_proposed_property_usage, staging_table.pl_property_usage_type, staging_table.pl_property_value_amount, staging_table.pl_reo_disposition_status_type, staging_table.pl_auto_geocode, staging_table.pl_auto_geocode_exception, staging_table.pl_msa_code, staging_table.pl_state_fips, staging_table.pl_county_fips, staging_table.pl_census_tract, staging_table.pl_mh_make, staging_table.pl_mh_model, staging_table.pl_mh_length, staging_table.pl_mh_width, staging_table.pl_mh_manufacturer, staging_table.pl_mh_serial_number, staging_table.pl_mh_hud_label_number, staging_table.pl_mh_certificate_of_title_issued, staging_table.pl_mh_certificate_of_title_number, staging_table.pl_mh_certificate_of_title_type, staging_table.pl_mh_loan_purpose_type, staging_table.pl_mh_anchored, staging_table.pl_coop_company_name, staging_table.pl_coop_building_name, staging_table.pl_coop_vacant_units, staging_table.pl_coop_proprietary_lease_date, staging_table.pl_coop_assignment_lease_date, staging_table.pl_coop_existing_company_laws_state, staging_table.pl_coop_shares_being_purchased, staging_table.pl_coop_attorney_in_fact, staging_table.pl_coop_stock_certificate_number, staging_table.pl_coop_apartment_unit, staging_table.pl_rental, staging_table.pl_underwriter_comments, staging_table.pl_lava_zone_type, staging_table.pl_neighborhood_location_type, staging_table.pl_site_area, staging_table.pl_hud_reo, staging_table.pl_va_guaranteed_reo, staging_table.pl_va_loan_date, staging_table.pl_gross_building_area_square_feet, staging_table.pl_project_dwelling_units_sold_count, staging_table.pl_prior_owners_title, staging_table.pl_prior_owners_title_policy_amount, staging_table.pl_prior_owners_title_policy_effective_date, staging_table.pl_prior_lenders_title, staging_table.pl_prior_lenders_title_policy_amount, staging_table.pl_prior_lenders_title_policy_effective_date, staging_table.pl_bedroom_count_unit_1, staging_table.pl_bedroom_count_unit_2, staging_table.pl_bedroom_count_unit_3, staging_table.pl_bedroom_count_unit_4, staging_table.pl_rent_amount_unit_1, staging_table.pl_rent_amount_unit_2, staging_table.pl_rent_amount_unit_3, staging_table.pl_rent_amount_unit_4, staging_table.pl_listed_for_sale_in_last_6_months, staging_table.pl_property_in_borrower_trust, staging_table.pl_road_type, staging_table.pl_water_type, staging_table.pl_sanitation_type, staging_table.pl_survey_required, staging_table.pl_solar_panels_type, staging_table.pl_power_purchase_agreement, staging_table.pl_solar_panel_provider_name, staging_table.pl_seller_acquired_date, staging_table.pl_seller_original_cost_amount, staging_table.pl_remaining_economic_life_years, staging_table.pl_bathroom_count_unit_1, staging_table.pl_bathroom_count_unit_2, staging_table.pl_bathroom_count_unit_3, staging_table.pl_bathroom_count_unit_4, staging_table.pl_total_room_count_unit_1, staging_table.pl_total_room_count_unit_2, staging_table.pl_total_room_count_unit_3, staging_table.pl_total_room_count_unit_4, staging_table.pl_gross_living_area_square_feet_unit_1, staging_table.pl_gross_living_area_square_feet_unit_2, staging_table.pl_gross_living_area_square_feet_unit_3, staging_table.pl_gross_living_area_square_feet_unit_4, staging_table.pl_mh_leasehold__property_interest_type, staging_table.pl_tribe_name, staging_table.pl_leasehold_begin_date, staging_table.pl_lease_number, staging_table.pl_property_inspection_required, staging_table.pl_hvac_inspection_required, staging_table.pl_pest_inspection_required, staging_table.pl_radon_inspection_required, staging_table.pl_septic_inspection_required, staging_table.pl_water_well_inspection_required, staging_table.pl_structural_inspection_required, staging_table.pl_pest_inspection_required_auto_compute, staging_table.pl_management_agent_federal_tax_id, staging_table.pl_mh_manufacturer_street_1, staging_table.pl_mh_manufacturer_street_2, staging_table.pl_mh_manufacturer_city, staging_table.pl_mh_manufacturer_state, staging_table.pl_mh_manufacturer_postal_code, staging_table.pl_mh_manufacturer_phone, staging_table.pl_mh_manufacturer_phone_extension, staging_table.pl_recording_city_name, staging_table.pl_abbreviated_legal_description, staging_table.pl_geocode_service_disabled, staging_table.pl_vesting_confirmed, staging_table.pl_previous_title_manner_held_description, staging_table.pl_legal_lot_na, staging_table.pl_legal_block_na, staging_table.pl_legal_section_na, staging_table.pl_legal_description_confirmed, staging_table.pl_lead_inspection_required, staging_table.pl_calculated_lead_inspection_required, staging_table.pl_geocode_system_error, staging_table.pl_mixed_use, staging_table.pl_mixed_use_verified, staging_table.pl_mixed_use_area_square_feet, staging_table.pl_mixed_use_area_square_feet_verified, staging_table.pl_mixed_use_area_percent, staging_table.pl_trust_classification_type, staging_table.pl_additional_building_area_square_feet, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.place staging_table
LEFT JOIN history_octane.place history_table on staging_table.pl_pid = history_table.pl_pid and staging_table.pl_version = history_table.pl_version
WHERE history_table.pl_pid is NULL
UNION ALL
SELECT history_table.pl_pid, history_table.pl_version+1, history_table.pl_proposal_pid, history_table.pl_subject_property, history_table.pl_acquisition_date, history_table.pl_financed_units_count, history_table.pl_unit_count, history_table.pl_land_estimated_value_amount, history_table.pl_land_original_cost_amount, history_table.pl_leasehold_expiration_date, history_table.pl_legal_description_type, history_table.pl_legal_description, history_table.pl_property_tax_id, history_table.pl_legal_lot, history_table.pl_legal_block, history_table.pl_legal_section, history_table.pl_project_name, history_table.pl_cpm_project_id, history_table.pl_acquisition_cost_amount, history_table.pl_county_pid, history_table.pl_sub_jurisdiction_name, history_table.pl_recording_district_name, history_table.pl_project_classification_type, history_table.pl_property_category_type, history_table.pl_property_rights_type, history_table.pl_structure_built_year, history_table.pl_structure_built_month, history_table.pl_title_manner_held_type, history_table.pl_title_manner_held_description, history_table.pl_building_status_type, history_table.pl_construction_conversion, history_table.pl_native_american_lands_type, history_table.pl_community_land_trust, history_table.pl_inclusionary_zoning, history_table.pl_unique_dwelling_type, history_table.pl_living_unit_count, history_table.pl_project_design_type, history_table.pl_city, history_table.pl_country, history_table.pl_postal_code, history_table.pl_state, history_table.pl_street1, history_table.pl_street2, history_table.pl_street_tbd, history_table.pl_landlord_first_name, history_table.pl_landlord_last_name, history_table.pl_landlord_middle_name, history_table.pl_landlord_name_suffix, history_table.pl_landlord_company_name, history_table.pl_landlord_title, history_table.pl_landlord_office_phone, history_table.pl_landlord_office_phone_extension, history_table.pl_landlord_mobile_phone, history_table.pl_landlord_email, history_table.pl_landlord_fax, history_table.pl_landlord_city, history_table.pl_landlord_country, history_table.pl_landlord_postal_code, history_table.pl_landlord_state, history_table.pl_landlord_street1, history_table.pl_landlord_street2, history_table.pl_management_first_name, history_table.pl_management_last_name, history_table.pl_management_middle_name, history_table.pl_management_name_suffix, history_table.pl_management_company_name, history_table.pl_management_title, history_table.pl_management_office_phone, history_table.pl_management_office_phone_extension, history_table.pl_management_mobile_phone, history_table.pl_management_email, history_table.pl_management_fax, history_table.pl_management_city, history_table.pl_management_country, history_table.pl_management_postal_code, history_table.pl_management_state, history_table.pl_management_street1, history_table.pl_management_street2, history_table.pl_property_insurance_amount_input_type, history_table.pl_property_tax_amount_input_type, history_table.pl_annual_property_insurance_amount, history_table.pl_annual_property_tax_amount, history_table.pl_monthly_property_insurance_amount, history_table.pl_monthly_hoa_amount, history_table.pl_monthly_mi_amount, history_table.pl_monthly_property_tax_amount, history_table.pl_monthly_lease_ground_rent_amount, history_table.pl_monthly_rent_amount, history_table.pl_monthly_obligation_amount, history_table.pl_use_proposed_property_usage, history_table.pl_property_usage_type, history_table.pl_property_value_amount, history_table.pl_reo_disposition_status_type, history_table.pl_auto_geocode, history_table.pl_auto_geocode_exception, history_table.pl_msa_code, history_table.pl_state_fips, history_table.pl_county_fips, history_table.pl_census_tract, history_table.pl_mh_make, history_table.pl_mh_model, history_table.pl_mh_length, history_table.pl_mh_width, history_table.pl_mh_manufacturer, history_table.pl_mh_serial_number, history_table.pl_mh_hud_label_number, history_table.pl_mh_certificate_of_title_issued, history_table.pl_mh_certificate_of_title_number, history_table.pl_mh_certificate_of_title_type, history_table.pl_mh_loan_purpose_type, history_table.pl_mh_anchored, history_table.pl_coop_company_name, history_table.pl_coop_building_name, history_table.pl_coop_vacant_units, history_table.pl_coop_proprietary_lease_date, history_table.pl_coop_assignment_lease_date, history_table.pl_coop_existing_company_laws_state, history_table.pl_coop_shares_being_purchased, history_table.pl_coop_attorney_in_fact, history_table.pl_coop_stock_certificate_number, history_table.pl_coop_apartment_unit, history_table.pl_rental, history_table.pl_underwriter_comments, history_table.pl_lava_zone_type, history_table.pl_neighborhood_location_type, history_table.pl_site_area, history_table.pl_hud_reo, history_table.pl_va_guaranteed_reo, history_table.pl_va_loan_date, history_table.pl_gross_building_area_square_feet, history_table.pl_project_dwelling_units_sold_count, history_table.pl_prior_owners_title, history_table.pl_prior_owners_title_policy_amount, history_table.pl_prior_owners_title_policy_effective_date, history_table.pl_prior_lenders_title, history_table.pl_prior_lenders_title_policy_amount, history_table.pl_prior_lenders_title_policy_effective_date, history_table.pl_bedroom_count_unit_1, history_table.pl_bedroom_count_unit_2, history_table.pl_bedroom_count_unit_3, history_table.pl_bedroom_count_unit_4, history_table.pl_rent_amount_unit_1, history_table.pl_rent_amount_unit_2, history_table.pl_rent_amount_unit_3, history_table.pl_rent_amount_unit_4, history_table.pl_listed_for_sale_in_last_6_months, history_table.pl_property_in_borrower_trust, history_table.pl_road_type, history_table.pl_water_type, history_table.pl_sanitation_type, history_table.pl_survey_required, history_table.pl_solar_panels_type, history_table.pl_power_purchase_agreement, history_table.pl_solar_panel_provider_name, history_table.pl_seller_acquired_date, history_table.pl_seller_original_cost_amount, history_table.pl_remaining_economic_life_years, history_table.pl_bathroom_count_unit_1, history_table.pl_bathroom_count_unit_2, history_table.pl_bathroom_count_unit_3, history_table.pl_bathroom_count_unit_4, history_table.pl_total_room_count_unit_1, history_table.pl_total_room_count_unit_2, history_table.pl_total_room_count_unit_3, history_table.pl_total_room_count_unit_4, history_table.pl_gross_living_area_square_feet_unit_1, history_table.pl_gross_living_area_square_feet_unit_2, history_table.pl_gross_living_area_square_feet_unit_3, history_table.pl_gross_living_area_square_feet_unit_4, history_table.pl_mh_leasehold__property_interest_type, history_table.pl_tribe_name, history_table.pl_leasehold_begin_date, history_table.pl_lease_number, history_table.pl_property_inspection_required, history_table.pl_hvac_inspection_required, history_table.pl_pest_inspection_required, history_table.pl_radon_inspection_required, history_table.pl_septic_inspection_required, history_table.pl_water_well_inspection_required, history_table.pl_structural_inspection_required, history_table.pl_pest_inspection_required_auto_compute, history_table.pl_management_agent_federal_tax_id, history_table.pl_mh_manufacturer_street_1, history_table.pl_mh_manufacturer_street_2, history_table.pl_mh_manufacturer_city, history_table.pl_mh_manufacturer_state, history_table.pl_mh_manufacturer_postal_code, history_table.pl_mh_manufacturer_phone, history_table.pl_mh_manufacturer_phone_extension, history_table.pl_recording_city_name, history_table.pl_abbreviated_legal_description, history_table.pl_geocode_service_disabled, history_table.pl_vesting_confirmed, history_table.pl_previous_title_manner_held_description, history_table.pl_legal_lot_na, history_table.pl_legal_block_na, history_table.pl_legal_section_na, history_table.pl_legal_description_confirmed, history_table.pl_lead_inspection_required, history_table.pl_calculated_lead_inspection_required, history_table.pl_geocode_system_error, history_table.pl_mixed_use, history_table.pl_mixed_use_verified, history_table.pl_mixed_use_area_square_feet, history_table.pl_mixed_use_area_square_feet_verified, history_table.pl_mixed_use_area_percent, history_table.pl_trust_classification_type, history_table.pl_additional_building_area_square_feet, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.place history_table
LEFT JOIN staging_octane.place staging_table on staging_table.pl_pid = history_table.pl_pid
WHERE staging_table.pl_pid is NULL
  AND not exists (select 1 from history_octane.place deleted_records where deleted_records.pl_pid = history_table.pl_pid and deleted_records.data_source_deleted_flag = True);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100012');

--- proposal --SP-100317
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.proposal
SELECT staging_table.prp_estimated_hard_construction_cost_amount, staging_table.prp_financed_property_improvements, staging_table.prp_pid, staging_table.prp_version, staging_table.prp_decision_lp_request_pid, staging_table.prp_decision_du_request_pid, staging_table.prp_proposal_type, staging_table.prp_description, staging_table.prp_doc_level_type, staging_table.prp_loan_purpose_type, staging_table.prp_name, staging_table.prp_create_datetime, staging_table.prp_effective_funding_date, staging_table.prp_estimated_funding_date, staging_table.prp_calculated_earliest_allowed_consummation_date, staging_table.prp_overridden_earliest_allowed_consummation_date, staging_table.prp_effective_earliest_allowed_consummation_date, staging_table.prp_earliest_allowed_consummation_date_override_reason, staging_table.prp_last_requested_disclosure_date, staging_table.prp_closing_document_sign_datetime, staging_table.prp_scheduled_closing_document_sign_datetime, staging_table.prp_rescission_through_date, staging_table.prp_rescission_notification_date, staging_table.prp_rescission_notification_by, staging_table.prp_rescission_notification_type, staging_table.prp_rescission_effective_date, staging_table.prp_first_payment_date, staging_table.prp_first_payment_date_auto_compute, staging_table.prp_property_usage_type, staging_table.prp_estimated_property_value_amount, staging_table.prp_smart_charges_enabled, staging_table.prp_charges_updated_datetime, staging_table.prp_smart_docs_enabled, staging_table.prp_docs_enabled_datetime, staging_table.prp_request_fha_mip_refund_required, staging_table.prp_request_recording_fees_required, staging_table.prp_request_property_taxes_required, staging_table.prp_property_tax_request_error_messages, staging_table.prp_fha_mip_refund_request_input_error, staging_table.prp_recording_fees_request_input_error, staging_table.prp_property_taxes_request_input_error, staging_table.prp_publish, staging_table.prp_publish_date, staging_table.prp_ipc_auto_compute, staging_table.prp_ipc_limit_percent, staging_table.prp_ipc_maximum_amount_allowed, staging_table.prp_ipc_amount, staging_table.prp_ipc_percent, staging_table.prp_ipc_financing_concession_amount, staging_table.prp_ipc_non_cash_concession_amount, staging_table.prp_sale_price_amount, staging_table.prp_structure_type, staging_table.prp_deal_pid, staging_table.prp_gfe_interest_rate_expiration_date, staging_table.prp_gfe_lock_duration_days, staging_table.prp_gfe_lock_before_settlement_days, staging_table.prp_proposal_expiration_date, staging_table.prp_uuts_master_contact_name, staging_table.prp_uuts_master_contact_title, staging_table.prp_uuts_master_office_phone, staging_table.prp_uuts_master_office_phone_extension, staging_table.prp_underwrite_risk_assessment_type, staging_table.prp_underwriting_comments, staging_table.prp_reserves_auto_compute, staging_table.prp_reserves_amount, staging_table.prp_reserves_months, staging_table.prp_underwrite_disposition_type, staging_table.prp_underwrite_publish_date, staging_table.prp_underwrite_expiration_date, staging_table.prp_usda_gsa_sam_exclusion, staging_table.prp_usda_gsa_sam_checked_date, staging_table.prp_usda_rd_single_family_housing_type, staging_table.prp_underwrite_method_type, staging_table.prp_mi_required, staging_table.prp_decision_credit_score_borrower_pid, staging_table.prp_decision_credit_score, staging_table.prp_estimated_credit_score, staging_table.prp_effective_credit_score, staging_table.prp_mortgagee_builder_seller_relationship, staging_table.prp_fha_prior_agency_case_id, staging_table.prp_fha_prior_agency_case_endorsement_date, staging_table.prp_fha_refinance_authorization_number, staging_table.prp_fha_refinance_authorization_expiration_date, staging_table.prp_fhac_refinance_authorization_messages, staging_table.prp_hud_fha_de_approval_type, staging_table.prp_owner_occupancy_not_required, staging_table.prp_va_monthly_utilities_included, staging_table.prp_va_maintenance_utilities_auto_compute, staging_table.prp_va_monthly_maintenance_utilities_amount, staging_table.prp_va_maintenance_utilities_per_square_feet_amount, staging_table.prp_household_size_count, staging_table.prp_va_past_credit_record_type, staging_table.prp_va_meets_credit_standards, staging_table.prp_va_prior_paid_in_full_loan_number, staging_table.prp_note_date, staging_table.prp_security_instrument_type, staging_table.prp_trustee_pid, staging_table.prp_trustee_name, staging_table.prp_trustee_address_street1, staging_table.prp_trustee_address_street2, staging_table.prp_trustee_address_city, staging_table.prp_trustee_address_state, staging_table.prp_trustee_address_postal_code, staging_table.prp_trustee_address_country, staging_table.prp_trustee_mers_org_id, staging_table.prp_trustee_phone_number, staging_table.prp_fre_ctp_closing_feature_type, staging_table.prp_fre_ctp_first_payment_due_date, staging_table.prp_purchase_contract_date, staging_table.prp_purchase_contract_financing_contingency_date, staging_table.prp_purchase_contract_funding_date, staging_table.prp_effective_property_value_type, staging_table.prp_effective_property_value_amount, staging_table.prp_decision_appraised_value_amount, staging_table.prp_fha_va_reasonable_value_amount, staging_table.prp_cd_clear_date, staging_table.prp_disaster_declaration_check_date_type, staging_table.prp_disaster_declaration_check_date, staging_table.prp_any_disaster_declaration_before_appraisal, staging_table.prp_any_disaster_declaration_after_appraisal, staging_table.prp_any_disaster_declaration, staging_table.prp_early_first_payment, staging_table.prp_property_acquired_through_inheritance, staging_table.prp_property_acquired_through_ancillary_relief, staging_table.prp_delayed_financing_exception_guidelines_applicable, staging_table.prp_delayed_financing_exception_verified, staging_table.prp_effective_property_value_explanation_type, staging_table.prp_taxes_escrowed, staging_table.prp_flood_insurance_applicable, staging_table.prp_windstorm_insurance_applicable, staging_table.prp_earthquake_insurance_applicable, staging_table.prp_arms_length, staging_table.prp_fha_non_arms_length_ltv_exception_type, staging_table.prp_fha_non_arms_length_ltv_exception_verified, staging_table.prp_escrow_cushion_months, staging_table.prp_escrow_cushion_months_auto_compute, staging_table.prp_fha_eligible_maximum_financing, staging_table.prp_hazard_insurance_applicable, staging_table.prp_property_repairs_required_type, staging_table.prp_property_repairs_description, staging_table.prp_property_repairs_cost_amount, staging_table.prp_property_repairs_holdback_calc_type, staging_table.prp_property_repairs_holdback_amount, staging_table.prp_property_repairs_holdback_payer_type, staging_table.prp_property_repairs_holdback_administrator, staging_table.prp_property_repairs_holdback_required_completion_date, staging_table.prp_property_repairs_completed_notification_date, staging_table.prp_property_repairs_inspection_ordered_date, staging_table.prp_property_repairs_inspection_completed_date, staging_table.prp_property_repairs_funds_released_contractor_date, staging_table.prp_anti_steering_lowest_rate_option_rate_percent, staging_table.prp_anti_steering_lowest_rate_option_fee_amount, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount, staging_table.prp_anti_steering_lowest_cost_option_rate_percent, staging_table.prp_anti_steering_lowest_cost_option_fee_amount, staging_table.prp_initial_uw_submit_datetime, staging_table.prp_va_notice_of_value_source_type, staging_table.prp_va_notice_of_value_date, staging_table.prp_va_notice_of_value_estimated_reasonable_value_amount, staging_table.prp_sar_significant_adjustments, staging_table.prp_separate_transaction_for_land_acquisition, staging_table.prp_land_acquisition_transaction_date, staging_table.prp_land_acquisition_price, staging_table.prp_cash_out_reason_home_improvement, staging_table.prp_cash_out_reason_debt_or_debt_consolidation, staging_table.prp_cash_out_reason_personal_use, staging_table.prp_cash_out_reason_future_investment_not_under_contract, staging_table.prp_cash_out_reason_future_investment_under_contract, staging_table.prp_cash_out_reason_other, staging_table.prp_cash_out_reason_other_text, staging_table.prp_decision_veteran_borrower_pid, staging_table.prp_signed_closing_doc_received_datetime, staging_table.prp_other_lender_requires_appraisal, staging_table.prp_other_lender_requires_appraisal_reason, staging_table.prp_texas_equity_determination_datetime, staging_table.prp_texas_equity_conversion_determination_datetime, staging_table.prp_texas_equity_determination_datetime_override, staging_table.prp_texas_equity_determination_datetime_override_reason, staging_table.prp_texas_equity_conversion_determination_datetime_override, staging_table.prp_texas_equity_conversion_determ_datetime_override_reason, staging_table.prp_cema, staging_table.prp_cema_borrower_savings, staging_table.prp_any_vesting_changes, staging_table.prp_vesting_change_titleholder_added, staging_table.prp_vesting_change_titleholder_removed, staging_table.prp_vesting_change_titleholder_name_change, staging_table.prp_deed_taxes_applicable, staging_table.prp_deed_taxes_applicable_explanation, staging_table.prp_deed_taxes_auto_compute, staging_table.prp_deed_taxes_auto_compute_override_reason, staging_table.prp_intent_to_proceed_date, staging_table.prp_intent_to_proceed_type, staging_table.prp_intent_to_proceed_provider_unparsed_name, staging_table.prp_intent_to_proceed_obtainer_unparsed_name, staging_table.prp_cash_out_reason_student_loans, staging_table.prp_household_income_exclusive_edit, staging_table.prp_purchase_contract_received_date, staging_table.prp_down_payment_percent_mode, staging_table.prp_lender_escrow_loan_amount, staging_table.prp_underwrite_disposition_note, staging_table.prp_rescission_applicable, staging_table.prp_area_median_income, staging_table.prp_total_income_to_ami_ratio, staging_table.prp_cr_tracker_url, staging_table.prp_construction_borrower_contribution_amount, staging_table.prp_construction_lot_ownership_status_type, staging_table.prp_intent_to_proceed_provided, staging_table.prp_effective_signing_location_state, staging_table.prp_effective_signing_location_city, staging_table.prp_va_required_guaranty_amount, staging_table.prp_va_amount_used_to_calculate_maximum_guaranty, staging_table.prp_va_actual_guaranty_amount, staging_table.prp_last_corrective_disclosure_processed_datetime, staging_table.prp_user_entered_note_date, staging_table.prp_effective_note_date, staging_table.prp_lender_escrow_loan_due_date, staging_table.prp_va_maximum_base_loan_amount, staging_table.prp_va_maximum_funding_fee_amount, staging_table.prp_va_maximum_total_loan_amount, staging_table.prp_va_required_cash_amount, staging_table.prp_va_guaranty_percent, staging_table.prp_gse_version_type, staging_table.prp_minimum_household_income_amount, staging_table.prp_minimum_residual_income_amount, staging_table.prp_minimum_residual_income_auto_compute, staging_table.prp_financed_property_improvements_category_type, staging_table.prp_adjusted_as_is_value_amount, staging_table.prp_after_improved_value_amount, staging_table.prp_disclosure_action_type, staging_table.prp_hud_consultant, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_estimated_hard_construction_cost_amount, history_table.prp_financed_property_improvements, history_table.prp_pid, history_table.prp_version + 1, history_table.prp_decision_lp_request_pid, history_table.prp_decision_du_request_pid, history_table.prp_proposal_type, history_table.prp_description, history_table.prp_doc_level_type, history_table.prp_loan_purpose_type, history_table.prp_name, history_table.prp_create_datetime, history_table.prp_effective_funding_date, history_table.prp_estimated_funding_date, history_table.prp_calculated_earliest_allowed_consummation_date, history_table.prp_overridden_earliest_allowed_consummation_date, history_table.prp_effective_earliest_allowed_consummation_date, history_table.prp_earliest_allowed_consummation_date_override_reason, history_table.prp_last_requested_disclosure_date, history_table.prp_closing_document_sign_datetime, history_table.prp_scheduled_closing_document_sign_datetime, history_table.prp_rescission_through_date, history_table.prp_rescission_notification_date, history_table.prp_rescission_notification_by, history_table.prp_rescission_notification_type, history_table.prp_rescission_effective_date, history_table.prp_first_payment_date, history_table.prp_first_payment_date_auto_compute, history_table.prp_property_usage_type, history_table.prp_estimated_property_value_amount, history_table.prp_smart_charges_enabled, history_table.prp_charges_updated_datetime, history_table.prp_smart_docs_enabled, history_table.prp_docs_enabled_datetime, history_table.prp_request_fha_mip_refund_required, history_table.prp_request_recording_fees_required, history_table.prp_request_property_taxes_required, history_table.prp_property_tax_request_error_messages, history_table.prp_fha_mip_refund_request_input_error, history_table.prp_recording_fees_request_input_error, history_table.prp_property_taxes_request_input_error, history_table.prp_publish, history_table.prp_publish_date, history_table.prp_ipc_auto_compute, history_table.prp_ipc_limit_percent, history_table.prp_ipc_maximum_amount_allowed, history_table.prp_ipc_amount, history_table.prp_ipc_percent, history_table.prp_ipc_financing_concession_amount, history_table.prp_ipc_non_cash_concession_amount, history_table.prp_sale_price_amount, history_table.prp_structure_type, history_table.prp_deal_pid, history_table.prp_gfe_interest_rate_expiration_date, history_table.prp_gfe_lock_duration_days, history_table.prp_gfe_lock_before_settlement_days, history_table.prp_proposal_expiration_date, history_table.prp_uuts_master_contact_name, history_table.prp_uuts_master_contact_title, history_table.prp_uuts_master_office_phone, history_table.prp_uuts_master_office_phone_extension, history_table.prp_underwrite_risk_assessment_type, history_table.prp_underwriting_comments, history_table.prp_reserves_auto_compute, history_table.prp_reserves_amount, history_table.prp_reserves_months, history_table.prp_underwrite_disposition_type, history_table.prp_underwrite_publish_date, history_table.prp_underwrite_expiration_date, history_table.prp_usda_gsa_sam_exclusion, history_table.prp_usda_gsa_sam_checked_date, history_table.prp_usda_rd_single_family_housing_type, history_table.prp_underwrite_method_type, history_table.prp_mi_required, history_table.prp_decision_credit_score_borrower_pid, history_table.prp_decision_credit_score, history_table.prp_estimated_credit_score, history_table.prp_effective_credit_score, history_table.prp_mortgagee_builder_seller_relationship, history_table.prp_fha_prior_agency_case_id, history_table.prp_fha_prior_agency_case_endorsement_date, history_table.prp_fha_refinance_authorization_number, history_table.prp_fha_refinance_authorization_expiration_date, history_table.prp_fhac_refinance_authorization_messages, history_table.prp_hud_fha_de_approval_type, history_table.prp_owner_occupancy_not_required, history_table.prp_va_monthly_utilities_included, history_table.prp_va_maintenance_utilities_auto_compute, history_table.prp_va_monthly_maintenance_utilities_amount, history_table.prp_va_maintenance_utilities_per_square_feet_amount, history_table.prp_household_size_count, history_table.prp_va_past_credit_record_type, history_table.prp_va_meets_credit_standards, history_table.prp_va_prior_paid_in_full_loan_number, history_table.prp_note_date, history_table.prp_security_instrument_type, history_table.prp_trustee_pid, history_table.prp_trustee_name, history_table.prp_trustee_address_street1, history_table.prp_trustee_address_street2, history_table.prp_trustee_address_city, history_table.prp_trustee_address_state, history_table.prp_trustee_address_postal_code, history_table.prp_trustee_address_country, history_table.prp_trustee_mers_org_id, history_table.prp_trustee_phone_number, history_table.prp_fre_ctp_closing_feature_type, history_table.prp_fre_ctp_first_payment_due_date, history_table.prp_purchase_contract_date, history_table.prp_purchase_contract_financing_contingency_date, history_table.prp_purchase_contract_funding_date, history_table.prp_effective_property_value_type, history_table.prp_effective_property_value_amount, history_table.prp_decision_appraised_value_amount, history_table.prp_fha_va_reasonable_value_amount, history_table.prp_cd_clear_date, history_table.prp_disaster_declaration_check_date_type, history_table.prp_disaster_declaration_check_date, history_table.prp_any_disaster_declaration_before_appraisal, history_table.prp_any_disaster_declaration_after_appraisal, history_table.prp_any_disaster_declaration, history_table.prp_early_first_payment, history_table.prp_property_acquired_through_inheritance, history_table.prp_property_acquired_through_ancillary_relief, history_table.prp_delayed_financing_exception_guidelines_applicable, history_table.prp_delayed_financing_exception_verified, history_table.prp_effective_property_value_explanation_type, history_table.prp_taxes_escrowed, history_table.prp_flood_insurance_applicable, history_table.prp_windstorm_insurance_applicable, history_table.prp_earthquake_insurance_applicable, history_table.prp_arms_length, history_table.prp_fha_non_arms_length_ltv_exception_type, history_table.prp_fha_non_arms_length_ltv_exception_verified, history_table.prp_escrow_cushion_months, history_table.prp_escrow_cushion_months_auto_compute, history_table.prp_fha_eligible_maximum_financing, history_table.prp_hazard_insurance_applicable, history_table.prp_property_repairs_required_type, history_table.prp_property_repairs_description, history_table.prp_property_repairs_cost_amount, history_table.prp_property_repairs_holdback_calc_type, history_table.prp_property_repairs_holdback_amount, history_table.prp_property_repairs_holdback_payer_type, history_table.prp_property_repairs_holdback_administrator, history_table.prp_property_repairs_holdback_required_completion_date, history_table.prp_property_repairs_completed_notification_date, history_table.prp_property_repairs_inspection_ordered_date, history_table.prp_property_repairs_inspection_completed_date, history_table.prp_property_repairs_funds_released_contractor_date, history_table.prp_anti_steering_lowest_rate_option_rate_percent, history_table.prp_anti_steering_lowest_rate_option_fee_amount, history_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent, history_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount, history_table.prp_anti_steering_lowest_cost_option_rate_percent, history_table.prp_anti_steering_lowest_cost_option_fee_amount, history_table.prp_initial_uw_submit_datetime, history_table.prp_va_notice_of_value_source_type, history_table.prp_va_notice_of_value_date, history_table.prp_va_notice_of_value_estimated_reasonable_value_amount, history_table.prp_sar_significant_adjustments, history_table.prp_separate_transaction_for_land_acquisition, history_table.prp_land_acquisition_transaction_date, history_table.prp_land_acquisition_price, history_table.prp_cash_out_reason_home_improvement, history_table.prp_cash_out_reason_debt_or_debt_consolidation, history_table.prp_cash_out_reason_personal_use, history_table.prp_cash_out_reason_future_investment_not_under_contract, history_table.prp_cash_out_reason_future_investment_under_contract, history_table.prp_cash_out_reason_other, history_table.prp_cash_out_reason_other_text, history_table.prp_decision_veteran_borrower_pid, history_table.prp_signed_closing_doc_received_datetime, history_table.prp_other_lender_requires_appraisal, history_table.prp_other_lender_requires_appraisal_reason, history_table.prp_texas_equity_determination_datetime, history_table.prp_texas_equity_conversion_determination_datetime, history_table.prp_texas_equity_determination_datetime_override, history_table.prp_texas_equity_determination_datetime_override_reason, history_table.prp_texas_equity_conversion_determination_datetime_override, history_table.prp_texas_equity_conversion_determ_datetime_override_reason, history_table.prp_cema, history_table.prp_cema_borrower_savings, history_table.prp_any_vesting_changes, history_table.prp_vesting_change_titleholder_added, history_table.prp_vesting_change_titleholder_removed, history_table.prp_vesting_change_titleholder_name_change, history_table.prp_deed_taxes_applicable, history_table.prp_deed_taxes_applicable_explanation, history_table.prp_deed_taxes_auto_compute, history_table.prp_deed_taxes_auto_compute_override_reason, history_table.prp_intent_to_proceed_date, history_table.prp_intent_to_proceed_type, history_table.prp_intent_to_proceed_provider_unparsed_name, history_table.prp_intent_to_proceed_obtainer_unparsed_name, history_table.prp_cash_out_reason_student_loans, history_table.prp_household_income_exclusive_edit, history_table.prp_purchase_contract_received_date, history_table.prp_down_payment_percent_mode, history_table.prp_lender_escrow_loan_amount, history_table.prp_underwrite_disposition_note, history_table.prp_rescission_applicable, history_table.prp_area_median_income, history_table.prp_total_income_to_ami_ratio, history_table.prp_cr_tracker_url, history_table.prp_construction_borrower_contribution_amount, history_table.prp_construction_lot_ownership_status_type, history_table.prp_intent_to_proceed_provided, history_table.prp_effective_signing_location_state, history_table.prp_effective_signing_location_city, history_table.prp_va_required_guaranty_amount, history_table.prp_va_amount_used_to_calculate_maximum_guaranty, history_table.prp_va_actual_guaranty_amount, history_table.prp_last_corrective_disclosure_processed_datetime, history_table.prp_user_entered_note_date, history_table.prp_effective_note_date, history_table.prp_lender_escrow_loan_due_date, history_table.prp_va_maximum_base_loan_amount, history_table.prp_va_maximum_funding_fee_amount, history_table.prp_va_maximum_total_loan_amount, history_table.prp_va_required_cash_amount, history_table.prp_va_guaranty_percent, history_table.prp_gse_version_type, history_table.prp_minimum_household_income_amount, history_table.prp_minimum_residual_income_amount, history_table.prp_minimum_residual_income_auto_compute, history_table.prp_financed_property_improvements_category_type, history_table.prp_adjusted_as_is_value_amount, history_table.prp_after_improved_value_amount, history_table.prp_disclosure_action_type, history_table.prp_hud_consultant, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal deleted_records
                  WHERE deleted_records.prp_pid = history_table.prp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100317');

--- construction_cost --SP-100161
UPDATE mdi.table_input_step
SET sql='
--finding records to insert into history_octane.construction_cost
SELECT staging_table.coc_impeding_draw_discrepancy, staging_table.coc_draw_discrepancy_text, staging_table.coc_charge_type, staging_table.coc_pid, staging_table.coc_version, staging_table.coc_proposal_pid, staging_table.coc_construction_cost_category_type, staging_table.coc_construction_cost_funding_type, staging_table.coc_construction_cost_status_type, staging_table.coc_construction_cost_payee_type, staging_table.coc_create_datetime, staging_table.coc_construction_cost_amount, staging_table.coc_construction_cost_notes, staging_table.coc_contractor_pid, staging_table.coc_proposal_contractor_pid, staging_table.coc_payee, staging_table.coc_permit_pid, staging_table.coc_category_type_label, staging_table.coc_calculation_percentage, staging_table.coc_construction_cost_calculation_type, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.construction_cost staging_table
LEFT JOIN history_octane.construction_cost history_table
          ON staging_table.coc_pid = history_table.coc_pid AND staging_table.coc_version = history_table.coc_version
WHERE history_table.coc_pid IS NULL
UNION ALL
SELECT history_table.coc_impeding_draw_discrepancy, history_table.coc_draw_discrepancy_text, history_table.coc_charge_type, history_table.coc_pid, history_table.coc_version + 1, history_table.coc_proposal_pid, history_table.coc_construction_cost_category_type, history_table.coc_construction_cost_funding_type, history_table.coc_construction_cost_status_type, history_table.coc_construction_cost_payee_type, history_table.coc_create_datetime, history_table.coc_construction_cost_amount, history_table.coc_construction_cost_notes, history_table.coc_contractor_pid, history_table.coc_proposal_contractor_pid, history_table.coc_payee, history_table.coc_permit_pid, history_table.coc_category_type_label, history_table.coc_calculation_percentage, history_table.coc_construction_cost_calculation_type, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.construction_cost history_table
LEFT JOIN staging_octane.construction_cost staging_table
          ON staging_table.coc_pid = history_table.coc_pid
WHERE staging_table.coc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.construction_cost deleted_records
                  WHERE deleted_records.coc_pid = history_table.coc_pid AND deleted_records.data_source_deleted_flag = TRUE);'
WHERE process_dwid = (SELECT dwid FROM mdi.process WHERE name='SP-100161');

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_new_column_field_data (
                                                      table_name TEXT,
                                                      field_name TEXT,
                                                      key_field_flag BOOLEAN,
                                                      field_order INTEGER);

INSERT INTO temp_new_column_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('loan_charge_payer_item_source_type', 'code', FALSE, 1),
       ('loan_charge_payer_item_source_type', 'value', FALSE, 2),

       ('loan_charge_payer_item', 'lcpi_pid', FALSE, 1),
       ('loan_charge_payer_item', 'lcpi_version', FALSE, 2),
       ('loan_charge_payer_item', 'lcpi_item_amount', FALSE, 3),
       ('loan_charge_payer_item', 'lcpi_loan_charge_payer_item_source_type', FALSE, 4),
       ('loan_charge_payer_item', 'lcpi_loan_charge_pid', FALSE, 5),
       ('loan_charge_payer_item', 'lcpi_charge_payer_type', FALSE, 6),
       ('loan_charge_payer_item', 'lcpi_paid_by', FALSE, 7),
       ('loan_charge_payer_item', 'lcpi_poc', FALSE, 8),
       ('loan_charge_payer_item', 'lcpi_charge_wire_action_auto_compute', FALSE, 9),
       ('loan_charge_payer_item', 'lcpi_charge_wire_action_type', FALSE, 10),

       ('wf_prereq_set', 'wps_pid', FALSE, 1),
       ('wf_prereq_set', 'wps_version', FALSE, 2),
       ('wf_prereq_set', 'wps_account_pid', FALSE, 3),
       ('wf_prereq_set', 'wps_wf_prereq_set_name', FALSE, 4),

       ('wf_prereq', 'wp_pid', FALSE, 1),
       ('wf_prereq', 'wp_version', FALSE, 2),
       ('wf_prereq', 'wp_wf_prereq_set_pid', FALSE, 3),
       ('wf_prereq', 'wp_wf_step_pid', FALSE, 4);

-- Insert edw_field_definition data for new staging_octane columns
INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_new_column_field_data.field_name, temp_new_column_field_data.key_field_flag
FROM temp_new_column_field_data
    JOIN mdi.edw_table_definition
        ON temp_new_column_field_data.table_name = edw_table_definition.table_name
            AND edw_table_definition.schema_name = 'staging_octane';

-- Insert edw_field_definition data for new history_octane columns
INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
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
