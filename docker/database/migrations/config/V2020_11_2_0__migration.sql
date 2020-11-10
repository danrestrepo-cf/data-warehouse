-------------------------------------------------------------------------------
--  NAME
--      Add Pentaho logging tables and fix releases v2020.11.1.0 through v2020.11.1.2
--
--  ASANA
--      https://app.asana.com/0/0/1199157885204349
--
--  DESCRIPTION/PURPOSE
--      This script adds the logging tables needed by the MDI process to the config database.
--      Configuration changes for SP8.1, SP9.1, and SP10.1 are included as well as they did not
--      pass QA review when they were deployed on 11/6/2020.
--
-- PROGRAMMING NOTES
--     None
--
-------------------------------------------------------------------------------

CREATE SEQUENCE IF NOT EXISTS log.pentaho_logging_sequence AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE;

CREATE TABLE log.job_channel
(
    id_batch INTEGER,
    channel_id VARCHAR(255),
    log_date TIMESTAMP,
    logging_object_type VARCHAR(255),
    object_name VARCHAR(255),
    object_copy VARCHAR(255),
    repository_directory VARCHAR(255),
    filename VARCHAR(255),
    object_id VARCHAR(255),
    object_revision VARCHAR(255),
    parent_channel_id VARCHAR(255),
    root_channel_id VARCHAR(255),
    loggingseq BIGSERIAL NOT NULL
        CONSTRAINT job_channel_pkey
            PRIMARY KEY
);

CREATE TABLE log.job_entry
(
    id_batch INTEGER,
    channel_id VARCHAR(255),
    log_date TIMESTAMP,
    transname VARCHAR(255),
    stepname VARCHAR(255),
    lines_read BIGINT,
    lines_written BIGINT,
    lines_updated BIGINT,
    lines_input BIGINT,
    lines_output BIGINT,
    lines_rejected BIGINT,
    errors BIGINT,
    "RESULT" VARCHAR(5),
    nr_result_rows BIGINT,
    nr_result_files BIGINT,
    log_field TEXT,
    copy_nr INTEGER,
    loggingseq BIGSERIAL NOT NULL
        CONSTRAINT job_entry_pkey
            PRIMARY KEY
);

CREATE INDEX idx_job_entry_1
    ON log.job_entry (id_batch);

CREATE TABLE log.job_log
(
    id_job INTEGER,
    channel_id VARCHAR(255),
    jobname VARCHAR(255),
    status VARCHAR(15),
    lines_read BIGINT,
    lines_written BIGINT,
    lines_updated BIGINT,
    lines_input BIGINT,
    lines_output BIGINT,
    lines_rejected BIGINT,
    errors BIGINT,
    startdate TIMESTAMP,
    enddate TIMESTAMP,
    logdate TIMESTAMP,
    depdate TIMESTAMP,
    replaydate TIMESTAMP,
    log_field TEXT,
    executing_server VARCHAR(255),
    executing_user VARCHAR(255),
    start_job_entry VARCHAR(255),
    client VARCHAR(255),
    loggingseq BIGSERIAL NOT NULL
        CONSTRAINT job_log_pkey
            PRIMARY KEY
);


CREATE INDEX idx_job_log_1
    ON log.job_log (id_job);

CREATE INDEX idx_job_log_2
    ON log.job_log (errors, status, jobname);

CREATE TABLE log.transformation_metrics
(
    id_batch INTEGER,
    channel_id VARCHAR(255),
    log_date TIMESTAMP,
    metrics_date TIMESTAMP,
    metrics_code VARCHAR(255),
    metrics_description VARCHAR(255),
    metrics_subject VARCHAR(255),
    metrics_type VARCHAR(255),
    metrics_value BIGINT
);


CREATE TABLE log.transformation_step
(
    id_batch INTEGER,
    channel_id VARCHAR(255),
    log_date TIMESTAMP,
    transname VARCHAR(255),
    stepname VARCHAR(255),
    step_copy SMALLINT,
    lines_read BIGINT,
    lines_written BIGINT,
    lines_updated BIGINT,
    lines_input BIGINT,
    lines_output BIGINT,
    lines_rejected BIGINT,
    errors BIGINT,
    log_field TEXT
);


CREATE TABLE log.transformation_channel
(
    id_batch INTEGER,
    channel_id VARCHAR(255),
    log_date TIMESTAMP,
    logging_object_type VARCHAR(255),
    object_name VARCHAR(255),
    object_copy VARCHAR(255),
    repository_directory VARCHAR(255),
    filename VARCHAR(255),
    object_id VARCHAR(255),
    object_revision VARCHAR(255),
    parent_channel_id VARCHAR(255),
    root_channel_id VARCHAR(255)
);


CREATE TABLE log.transformation_performance
(
    id_batch INTEGER,
    seq_nr INTEGER,
    logdate TIMESTAMP,
    transname VARCHAR(255),
    stepname VARCHAR(255),
    step_copy INTEGER,
    lines_read BIGINT,
    lines_written BIGINT,
    lines_updated BIGINT,
    lines_input BIGINT,
    lines_output BIGINT,
    lines_rejected BIGINT,
    errors BIGINT,
    input_buffer_rows BIGINT,
    output_buffer_rows BIGINT
);


CREATE TABLE log.transformation_transformation
(
    id_batch INTEGER,
    channel_id VARCHAR(255),
    transname VARCHAR(255),
    status VARCHAR(15),
    lines_read BIGINT,
    lines_written BIGINT,
    lines_updated BIGINT,
    lines_input BIGINT,
    lines_output BIGINT,
    lines_rejected BIGINT,
    errors BIGINT,
    startdate TIMESTAMP,
    enddate TIMESTAMP,
    logdate TIMESTAMP,
    depdate TIMESTAMP,
    replaydate TIMESTAMP,
    log_field TEXT,
    executing_server VARCHAR(255),
    executing_user VARCHAR(255),
    client VARCHAR(255)
);


CREATE INDEX idx_transformation_transformation_1
    ON log.transformation_transformation (id_batch);

CREATE INDEX idx_transformation_transformation_2
    ON log.transformation_transformation (errors, status, transname);


update mdi.csv_file_input_step set filename='/input/dmi-V35-state.csv' where dwid=1;
update mdi.csv_file_input_step set filename='/input/dmi-V35-national.csv' where dwid=2;
update mdi.microsoft_excel_input_step set filename='/input/dmi-V35.xls', sheet_start_row = 4 where dwid=1;

update mdi.csv_file_input_field set field_type='Number' where dwid in (9,11);
update mdi.csv_file_input_field set field_type='Integer' where dwid = 10;
