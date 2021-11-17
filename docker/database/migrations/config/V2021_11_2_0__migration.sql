--
-- EDW | Update lambda to allow only one running ETL per target table at a time
-- https://app.asana.com/0/0/1201354667788164
--

-- mdi.process
UPDATE mdi.process
    SET name = 'SP-200001-insert'
    WHERE name = 'SP-200001';

UPDATE mdi.process
    SET name = 'SP-200001-delete'
    WHERE name = 'SP-200002';

UPDATE mdi.process
    SET name = 'SP-300001-insert-update'
    WHERE name = 'SP-300001';

UPDATE mdi.process
    SET name = 'SP-300001-delete'
    WHERE name = 'SP-300002';

-- mdi.state_machine_definition
UPDATE mdi.state_machine_definition
    SET name = 'SP-200001-insert'
    WHERE name = 'SP-200001';

UPDATE mdi.state_machine_definition
    SET name = 'SP-200001-delete'
    WHERE name = 'SP-200002';

UPDATE mdi.state_machine_definition
    SET name = 'SP-300001-insert-update'
    WHERE name = 'SP-300001';

UPDATE mdi.state_machine_definition
    SET name = 'SP-300001-delete'
    WHERE name = 'SP-300002';

--
-- EDW | history_octane - add etl_batch_id column to all existing tables and update metadata accordingly
-- https://app.asana.com/0/0/1201374340358777
--

--insert table_output_field records for etl_batch_id in every history_octane table
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, 'etl_batch_id', 'etl_batch_id', 0, FALSE
FROM mdi.table_output_step
WHERE table_output_step.target_schema = 'history_octane';

--insert edw_field_definition records for etl_batch_id in every history_octane table
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, data_type)
SELECT edw_table_definition.dwid, 'etl_batch_id', FALSE, NULL, 'TEXT'
FROM mdi.edw_table_definition
WHERE edw_table_definition.schema_name = 'history_octane';
