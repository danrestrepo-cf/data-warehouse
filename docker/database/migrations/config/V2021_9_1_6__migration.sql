--
-- EDW | Octane catch-up: Rename wf_wait_until_time_slice table
-- https://app.asana.com/0/0/1201003816146617
--

-- edw_table_definition
UPDATE mdi.edw_table_definition
    SET table_name = 'wf_polling_time_slice'
    WHERE table_name = 'wf_wait_until_time_slice';

-- process
UPDATE mdi.process
    SET description = 'ETL to copy wf_polling_time_slice data from staging_octane to history_octane'
    WHERE description = 'ETL to copy wf_wait_until_time_slice data from staging_octane to history_octane';

UPDATE mdi.table_output_step
    SET target_table = 'wf_polling_time_slice'
    WHERE target_table = 'wf_wait_until_time_slice';

-- table_input_step
UPDATE mdi.table_input_step
    SET sql = '--finding records to insert into history_octane.wf_polling_time_slice
SELECT staging_table.wts_pid
, staging_table.wts_version
, staging_table.wts_time_slice
, staging_table.wts_when_fired
, staging_table.wts_when_complete
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.wf_polling_time_slice staging_table
         LEFT JOIN history_octane.wf_polling_time_slice history_table on staging_table.wts_pid = history_table.wts_pid and staging_table.wts_version = history_table.wts_version
WHERE history_table.wts_pid is NULL
UNION ALL
SELECT history_table.wts_pid
, history_table.wts_version+1
, history_table.wts_time_slice
, history_table.wts_when_fired
, history_table.wts_when_complete
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.wf_polling_time_slice history_table
         LEFT JOIN staging_octane.wf_polling_time_slice staging_table on staging_table.wts_pid = history_table.wts_pid
WHERE staging_table.wts_pid is NULL
  AND not exists (select 1 from history_octane.wf_polling_time_slice deleted_records where deleted_records.wts_pid = history_table.wts_pid and deleted_records.data_source_deleted_flag = True)
'
    WHERE dwid = (
        SELECT table_input_step.dwid
        FROM mdi.process
            JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
            JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
                AND table_output_step.target_table = 'wf_polling_time_slice'
        );

UPDATE mdi.state_machine_definition
    SET comment = 'ETL to copy wf_polling_time_slice data from staging_octane to history_octane'
    WHERE comment = 'ETL to copy wf_wait_until_time_slice data from staging_octane to history_octane';
