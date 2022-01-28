--
-- EDW | Add Octane table deal_stage data EDW so it is reportable at the loan level - https://app.asana.com/0/0/1200811462378267
--

ALTER TABLE star_loan.loan_fact
    ADD current_transaction_stage_from_date_dwid BIGINT;

ALTER TABLE star_loan.transaction_dim
    ADD current_transaction_stage VARCHAR(1024)
    , ADD current_transaction_stage_code VARCHAR(128);

-- test data

SELECT true AS include_record
    , deal.*
    , etl_log.etl_end_date_time
FROM history_octane.deal
    LEFT JOIN history_octane.deal AS history_records
        ON deal.d_pid = history_records.d_pid
            AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
    JOIN star_common.etl_log
        ON deal.etl_batch_id = etl_log.etl_batch_id
WHERE history_records.d_pid IS NULL;

select * from star_common.etl_log;


insert into star_common. etl_log
(dwid, etl_batch_id, etl_start_date_time, etl_end_date_time, status, process_name, controller_job_batch_id, input_json, output_json, input_rows_read, input_step_duration_ms, output_rows_inserted, output_rows_updated, output_rows_deleted, output_rows_rejected, output_step_duration_ms)
VALUES
(1, 'batch_id_1', now(), now(), 'finished', 'SAMPLE-ETL',0, '','',0,0,0,0,0,0,0);

INSERT INTO history_octane.proposal
(data_source_updated_datetime, data_source_deleted_flag, prp_pid, prp_version, etl_batch_id)
values
(now(), false, 200, 1, 'batch_id_1');

INSERT INTO history_octane.deal
(data_source_updated_datetime, data_source_deleted_flag, d_pid, d_version, d_active_proposal_pid, etl_batch_id)
values
(now(),false,100,1,200,'batch_id_1');

INSERT INTO history_octane.deal_stage
(data_source_updated_datetime, data_source_deleted_flag, dst_pid, dst_version, dst_deal_pid, dst_deal_stage_type, dst_from_date, dst_from_datetime, dst_through_date, dst_through_datetime, dst_duration_seconds, dst_business_hours_duration_seconds, etl_batch_id)
VALUES
(now(), false, 300, 1, 100, 'STARTED', now() - interval '1' day,now() - interval '1', NOW(), NOW(), 86400, 86400, 'batch_id_1'),
(now(), false, 301, 1, 100, 'PREQUAL', now(),now(), NULL, NULL, NULL, NULL, 'batch_id_1');

INSERT INTO history_octane.deal_stage_type
(data_source_updated_datetime, data_source_deleted_flag, code, value, etl_batch_id)
VALUES
(now(), false, 'STARTED', 'Now in started', 'batch_id_1'),
(now(), false, 'PREQUAL', 'Now in prequal', 'batch_id_1');

