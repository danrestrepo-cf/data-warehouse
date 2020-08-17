-------------------------------------------------------------------------------
--  NAME
--      Add Staging Encompass Tables
--
--  ASANA
--      https://app.asana.com/0/265828915819547/1156662690313663
--
--  DESCRIPTION/PURPOSE
--      This script adds the tables that are needed to stage Encompass loan data
--      into the Enterprise Data Warehouse (EDW).
--
-------------------------------------------------------------------------------

--Log Tables for etl job
-- Table: log.log_encompass_etl_job_channel
CREATE TABLE log.log_encompass_etl_job_channel
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


-- Table: log.log_encompass_etl_job_log
CREATE TABLE log.log_encompass_etl_job_log
(
	channel_id VARCHAR(255),
	id_job INTEGER,
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
	client VARCHAR(255)
);


-- Table: log.log_encompass_etl_job_entry
CREATE TABLE log.log_encompass_etl_job_entry
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
	copy_nr INTEGER
);


--Log Tables for raw job
-- Table: log.log_encompass_raw_job_channel
CREATE TABLE log.log_encompass_raw_job_channel
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


-- Table: log.log_encompass_raw_job_log
CREATE TABLE log.log_encompass_raw_job_log
(
	channel_id VARCHAR(255),
	id_job INTEGER,
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
	client VARCHAR(255)
);


-- Table: log.log_encompass_raw_job_entry
CREATE TABLE log.log_encompass_raw_job_entry
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
	copy_nr INTEGER
);


--Log Tables for Transformation01
-- Table: log.log_encompass_raw_transformation01_channel
CREATE TABLE log.log_encompass_raw_transformation01_channel
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


-- Table: log.log_encompass_raw_transformation01_metric
CREATE TABLE log.log_encompass_raw_transformation01_metric
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


-- Table: log.log_encompass_raw_transformation01_performance
CREATE TABLE log.log_encompass_raw_transformation01_performance
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


-- Table: log.log_encompass_raw_transformation01_step
CREATE TABLE log.log_encompass_raw_transformation01_step
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


-- Table: log.log_encompass_raw_transformation01_transformation
CREATE TABLE log.log_encompass_raw_transformation01_transformation
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


--Log Tables for Transformation02
-- Table: log.log_encompass_raw_transformation02_channel
CREATE TABLE log.log_encompass_raw_transformation02_channel
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


-- Table: log.log_encompass_raw_transformation02_metric
CREATE TABLE log.log_encompass_raw_transformation02_metric
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


-- Table: log.log_encompass_raw_transformation02_performance
CREATE TABLE log.log_encompass_raw_transformation02_performance
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


-- Table: log.log_encompass_raw_transformation02_step
CREATE TABLE log.log_encompass_raw_transformation02_step
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


-- Table: log.log_encompass_raw_transformation02_transformation
CREATE TABLE log.log_encompass_raw_transformation02_transformation
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






--Log Tables for raw job
-- Table:  log.log_encompass_sanitize_job_channel
CREATE TABLE  log.log_encompass_sanitize_channel
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


-- Table:  log.log_encompass_sanitize_job
CREATE TABLE  log.log_encompass_sanitize_job
(
	channel_id VARCHAR(255),
	id_job INTEGER,
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
	client VARCHAR(255)
);


-- Table:  log.log_encompass_sanitize_entry
CREATE TABLE  log.log_encompass_sanitize_entry
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
	copy_nr INTEGER
);





--Log Tables for Transformation
-- Table:  log.log_encompass_sanitize_transformation_channels
CREATE TABLE  log.log_encompass_sanitize_transformation_channels
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


-- Table:  log.log_encompass_raw_transformation_metrics
CREATE TABLE  log.log_encompass_sanitize_transformation_metrics
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


-- Table:  log.log_encompass_raw_transformation_performance
CREATE TABLE  log.log_encompass_sanitize_transformation_performance
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


-- Table:  log.log_encompass_raw_transformation_step
CREATE TABLE  log.log_encompass_sanitize_transformation_step
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


-- Table:  log.log_encompass_raw_transformation_transformation
CREATE TABLE  log.log_encompass_sanitize_transformation_transformation
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




-- Indexes:
CREATE INDEX IDX_log_encompass_etl_job_log_1 ON log.log_encompass_etl_job_log (id_job);
CREATE INDEX IDX_log_encompass_etl_job_log_2 ON log.log_encompass_etl_job_log (errors, status, jobname);

CREATE INDEX IDX_log_encompass_etl_job_entry_1 ON log.log_encompass_etl_job_entry (id_batch);

CREATE INDEX IDX_log_encompass_raw_job_log_1 ON log.log_encompass_raw_job_log (id_job);
CREATE INDEX IDX_log_encompass_raw_job_log_2 ON log.log_encompass_raw_job_log (errors, status, jobname);

CREATE INDEX IDX_log_encompass_raw_job_entry_1 ON log.log_encompass_raw_job_entry (id_batch);

CREATE INDEX idx_encompass_log_encompass_raw_transformation01_tr_1
	ON log.log_encompass_raw_transformation01_transformation (id_batch);
CREATE INDEX idx_encompass_log_encompass_raw_transformation01_tr_2
	ON log.log_encompass_raw_transformation01_transformation (errors, status, transname);

CREATE INDEX idx_encompass_log_encompass_raw_transformation02_tr_1
	ON log.log_encompass_raw_transformation02_transformation (id_batch);
CREATE INDEX idx_encompass_log_encompass_raw_transformation02_tr_2
	ON log.log_encompass_raw_transformation02_transformation (errors, status, transname);

