--
-- EDW | Improve docker-up.sh execution time - https://app.asana.com/0/0/1201360578080564
--

create sequence log.pentaho_logging_sequence;
create type mdi.pentaho_db_connection_name as enum ('Ingress DB Connection', 'Config DB Connection', 'Staging DB Connection');
create type mdi.pentaho_field_currency as enum ('$');
create type mdi.pentaho_field_decimal as enum ('.');
create type mdi.pentaho_field_format as enum ('mixed', 'DOS', 'Unix');
create type mdi.pentaho_field_type as enum ('String', 'Date', 'Integer', 'Number', 'BigNumber', 'Binary', 'Timestamp', 'Internet Address');
create type mdi.pentaho_spreadsheet_type as enum ('JXL', 'POI', 'SAX_POI', 'ODS');
create type mdi.pentaho_trim_type as enum ('both', 'right', 'left', 'none');
create type mdi.pentaho_y_or_n as enum ('Y', 'N');
create type mdi.looker_yes_no as enum ('yes', 'no');

create table log.log_encompass_etl_job_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.log_encompass_etl_job_log
(
    channel_id varchar(255),
    id_job integer,
    jobname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    start_job_entry varchar(255),
    client varchar(255)
);

create index idx_log_encompass_etl_job_log_1 on log.log_encompass_etl_job_log (id_job);
create index idx_log_encompass_etl_job_log_2 on log.log_encompass_etl_job_log (errors, status, jobname);

create table log.log_encompass_etl_job_entry
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    "RESULT" varchar(5),
    nr_result_rows bigint,
    nr_result_files bigint,
    log_field text,
    copy_nr integer
);

create index idx_log_encompass_etl_job_entry_1 on log.log_encompass_etl_job_entry (id_batch);

create table log.log_encompass_raw_job_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.log_encompass_raw_job_log
(
    channel_id varchar(255),
    id_job integer,
    jobname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    start_job_entry varchar(255),
    client varchar(255)
);

create index idx_log_encompass_raw_job_log_1 on log.log_encompass_raw_job_log (id_job);

create index idx_log_encompass_raw_job_log_2 on log.log_encompass_raw_job_log (errors, status, jobname);

create table log.log_encompass_raw_job_entry
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    "RESULT" varchar(5),
    nr_result_rows bigint,
    nr_result_files bigint,
    log_field text,
    copy_nr integer
);

create index idx_log_encompass_raw_job_entry_1
    on log.log_encompass_raw_job_entry (id_batch);

create table log.log_encompass_raw_transformation01_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.log_encompass_raw_transformation01_metric
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    metrics_date timestamp,
    metrics_code varchar(255),
    metrics_description varchar(255),
    metrics_subject varchar(255),
    metrics_type varchar(255),
    metrics_value bigint
);

create table log.log_encompass_raw_transformation01_performance
(
    id_batch integer,
    seq_nr integer,
    logdate timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);

create table log.log_encompass_raw_transformation01_step
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy smallint,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    log_field text
);

create table log.log_encompass_raw_transformation01_transformation
(
    id_batch integer,
    channel_id varchar(255),
    transname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    client varchar(255)
);

create index idx_encompass_log_encompass_raw_transformation01_tr_1
    on log.log_encompass_raw_transformation01_transformation (id_batch);

create index idx_encompass_log_encompass_raw_transformation01_tr_2
    on log.log_encompass_raw_transformation01_transformation (errors, status, transname);

create table log.log_encompass_raw_transformation02_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.log_encompass_raw_transformation02_metric
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    metrics_date timestamp,
    metrics_code varchar(255),
    metrics_description varchar(255),
    metrics_subject varchar(255),
    metrics_type varchar(255),
    metrics_value bigint
);

create table log.log_encompass_raw_transformation02_performance
(
    id_batch integer,
    seq_nr integer,
    logdate timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);

create table log.log_encompass_raw_transformation02_step
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy smallint,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    log_field text
);

create table log.log_encompass_raw_transformation02_transformation
(
    id_batch integer,
    channel_id varchar(255),
    transname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    client varchar(255)
);

create index idx_encompass_log_encompass_raw_transformation02_tr_1
    on log.log_encompass_raw_transformation02_transformation (id_batch);

create index idx_encompass_log_encompass_raw_transformation02_tr_2
    on log.log_encompass_raw_transformation02_transformation (errors, status, transname);

create table log.log_encompass_sanitize_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.log_encompass_sanitize_job
(
    channel_id varchar(255),
    id_job integer,
    jobname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    start_job_entry varchar(255),
    client varchar(255)
);

create table log.log_encompass_sanitize_entry
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    "RESULT" varchar(5),
    nr_result_rows bigint,
    nr_result_files bigint,
    log_field text,
    copy_nr integer
);

create table log.log_encompass_sanitize_transformation_channels
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.log_encompass_sanitize_transformation_metrics
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    metrics_date timestamp,
    metrics_code varchar(255),
    metrics_description varchar(255),
    metrics_subject varchar(255),
    metrics_type varchar(255),
    metrics_value bigint
);

create table log.log_encompass_sanitize_transformation_performance
(
    id_batch integer,
    seq_nr integer,
    logdate timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);

create table log.log_encompass_sanitize_transformation_step
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy smallint,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    log_field text
);

create table log.log_encompass_sanitize_transformation_transformation
(
    id_batch integer,
    channel_id varchar(255),
    transname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    client varchar(255)
);

create table mdi.process
(
    dwid bigserial not null
        constraint pk_process
            primary key,
    name text not null,
    description text not null
);

create table mdi.csv_file_input_step
(
    dwid bigserial not null
        constraint pk_csv_file_input_step
            primary key,
    process_dwid bigint not null
        constraint fk_csv_file_input_step_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    header_present mdi.pentaho_y_or_n not null,
    delimiter text not null,
    enclosure char not null,
    buffersize integer not null,
    lazy_conversion mdi.pentaho_y_or_n not null,
    newline_possible mdi.pentaho_y_or_n not null,
    add_filename_result mdi.pentaho_y_or_n not null,
    file_format mdi.pentaho_field_format not null,
    file_encoding text not null,
    include_filename mdi.pentaho_y_or_n not null,
    process_in_parallel mdi.pentaho_y_or_n not null,
    filename_field text,
    row_num_field text,
    data_source_dwid bigint
);

create table mdi.csv_file_input_field
(
    dwid bigserial not null
        constraint pk_csv_file_input_field
            primary key,
    csv_file_input_step_dwid bigint not null
        constraint fk_csv_file_input_field_1
            references mdi.csv_file_input_step
            on update restrict on delete restrict
            deferrable initially deferred,
    field_name text not null,
    field_type mdi.pentaho_field_type not null,
    field_format text,
    field_length integer,
    field_precision integer,
    field_currency mdi.pentaho_field_currency default '$'::mdi.pentaho_field_currency,
    field_decimal mdi.pentaho_field_decimal default '.'::mdi.pentaho_field_decimal,
    field_group text default ','::text,
    field_trim_type mdi.pentaho_trim_type,
    field_order numeric not null
);

create table mdi.microsoft_excel_input_step
(
    dwid bigserial not null
        constraint pk_microsoft_excel_input_step
            primary key,
    process_dwid bigint not null
        constraint fk_microsoft_excel_input_step_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    spreadsheet_type mdi.pentaho_spreadsheet_type not null,
    filemask text,
    exclude_filemask text,
    file_required mdi.pentaho_y_or_n not null,
    include_subfolders mdi.pentaho_y_or_n not null,
    sheet_name text not null,
    sheet_start_row integer not null,
    sheet_start_col integer not null,
    data_source_dwid bigint
);

create table mdi.microsoft_excel_input_field
(
    dwid bigserial not null
        constraint pk_microsoft_excel_input_field
            primary key,
    microsoft_excel_input_step_dwid bigint not null
        constraint fk_microsoft_excel_input_field_1
            references mdi.microsoft_excel_input_step
            on update restrict on delete restrict
            deferrable initially deferred,
    field_name text not null,
    field_type mdi.pentaho_field_type not null,
    field_format text,
    field_length integer,
    field_precision integer,
    field_currency mdi.pentaho_field_currency default '$'::mdi.pentaho_field_currency,
    field_decimal mdi.pentaho_field_decimal default '.'::mdi.pentaho_field_decimal,
    field_group text default ','::text,
    field_trim_type mdi.pentaho_trim_type,
    field_order numeric not null
);

create table mdi.table_output_step
(
    dwid bigserial not null
        constraint pk_table_output_step
            primary key,
    process_dwid bigint not null
        constraint fk_table_output_step_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    target_schema text not null,
    target_table text not null,
    commit_size integer not null,
    partitioning_field text,
    table_name_field text,
    auto_generated_key_field text,
    partition_data_per text,
    table_name_defined_in_field mdi.pentaho_y_or_n not null,
    return_auto_generated_key_field text,
    truncate_table mdi.pentaho_y_or_n not null,
    connectionname text not null,
    partition_over_tables mdi.pentaho_y_or_n,
    specify_database_fields mdi.pentaho_y_or_n not null,
    ignore_insert_errors mdi.pentaho_y_or_n not null,
    use_batch_update mdi.pentaho_y_or_n not null
);

create table mdi.table_output_field
(
    dwid bigserial not null
        constraint pk_table_output_field
            primary key,
    table_output_step_dwid bigint not null
        constraint fk_table_output_field_1
            references mdi.table_output_step
            on update restrict on delete restrict
            deferrable initially deferred,
    database_field_name text not null,
    database_stream_name text not null,
    field_order numeric not null,
    is_sensitive boolean not null
);

create table log.job_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255),
    loggingseq bigserial not null
        constraint job_channel_pkey
            primary key
);

create table log.job_entry
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    "RESULT" varchar(5),
    nr_result_rows bigint,
    nr_result_files bigint,
    log_field text,
    copy_nr integer,
    loggingseq bigserial not null
        constraint job_entry_pkey
            primary key
);

create index idx_job_entry_1
    on log.job_entry (id_batch);

create table log.job_log
(
    id_job integer,
    channel_id varchar(255),
    jobname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    start_job_entry varchar(255),
    client varchar(255),
    loggingseq bigserial not null
        constraint job_log_pkey
            primary key
);

create index idx_job_log_1
    on log.job_log (id_job);

create index idx_job_log_2
    on log.job_log (errors, status, jobname);

create table log.transformation_metrics
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    metrics_date timestamp,
    metrics_code varchar(255),
    metrics_description varchar(255),
    metrics_subject varchar(255),
    metrics_type varchar(255),
    metrics_value bigint
);

create table log.transformation_step
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy smallint,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    log_field text
);

create table log.transformation_channel
(
    id_batch integer,
    channel_id varchar(255),
    log_date timestamp,
    logging_object_type varchar(255),
    object_name varchar(255),
    object_copy varchar(255),
    repository_directory varchar(255),
    filename varchar(255),
    object_id varchar(255),
    object_revision varchar(255),
    parent_channel_id varchar(255),
    root_channel_id varchar(255)
);

create table log.transformation_performance
(
    id_batch integer,
    seq_nr integer,
    logdate timestamp,
    transname varchar(255),
    stepname varchar(255),
    step_copy integer,
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    input_buffer_rows bigint,
    output_buffer_rows bigint
);

create table log.transformation_transformation
(
    id_batch integer,
    channel_id varchar(255),
    transname varchar(255),
    status varchar(15),
    lines_read bigint,
    lines_written bigint,
    lines_updated bigint,
    lines_input bigint,
    lines_output bigint,
    lines_rejected bigint,
    errors bigint,
    startdate timestamp,
    enddate timestamp,
    logdate timestamp,
    depdate timestamp,
    replaydate timestamp,
    log_field text,
    executing_server varchar(255),
    executing_user varchar(255),
    client varchar(255)
);

create index idx_transformation_transformation_1
    on log.transformation_transformation (id_batch);

create index idx_transformation_transformation_2
    on log.transformation_transformation (errors, status, transname);

create table mdi.table_input_step
(
    dwid bigserial not null
        constraint table_input_step_pk
            primary key,
    process_dwid bigint not null,
    data_source_dwid bigint,
    sql text not null,
    limit_size integer default 0 not null,
    execute_for_each_row mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    replace_variables mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    enable_lazy_conversion mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    cached_row_meta mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    connectionname mdi.pentaho_db_connection_name not null
);

create table mdi.insert_update_step
(
    dwid bigserial not null
        constraint pk_insert_update_step
            primary key,
    process_dwid bigint not null
        constraint fk_insert_update_step_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    connectionname text not null,
    schema_name text not null,
    table_name text not null,
    commit_size integer not null,
    do_not mdi.pentaho_y_or_n not null
);

create table mdi.insert_update_key
(
    dwid bigserial not null
        constraint pk_insert_update_key
            primary key,
    insert_update_step_dwid bigint not null
        constraint fk_insert_update_key_1
            references mdi.insert_update_step
            on update restrict on delete restrict
            deferrable initially deferred,
    key_lookup text not null,
    key_stream1 text not null,
    key_stream2 text,
    key_condition text not null
);

create table mdi.insert_update_field
(
    dwid bigserial not null
        constraint pk_insert_update_field
            primary key,
    insert_update_step_dwid bigint not null
        constraint fk_insert_update_field_1
            references mdi.insert_update_step
            on update restrict on delete restrict
            deferrable initially deferred,
    update_lookup text not null,
    update_stream text not null,
    update_flag mdi.pentaho_y_or_n not null,
    is_sensitive boolean not null
);

create table mdi.state_machine_step
(
    dwid bigserial not null
        constraint pk_state_machine_step
            primary key,
    process_dwid bigint not null
        constraint fk_state_machine_step_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    next_process_dwid bigint
        constraint fk_state_machine_step_2
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred
);

create table mdi.state_machine_definition
(
    dwid bigserial not null
        constraint pk_state_machine_definition
            primary key,
    process_dwid bigint not null
        constraint fk_state_machine_definition_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    name text not null,
    comment text not null,
    cron_schedule text
);

create table mdi.json_output_field
(
    dwid bigserial not null
        constraint pk_json_output_field
            primary key,
    process_dwid bigint not null
        constraint fk_json_output_field_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    field_name text not null
);

create table mdi.edw_table_definition
(
    dwid bigserial not null
        constraint pk_edw_table_definition
            primary key,
    database_name text not null,
    schema_name text not null,
    table_name text not null,
    primary_source_edw_table_definition_dwid bigint
        constraint fk_edw_table_definition_1
            references mdi.edw_table_definition
            on update restrict on delete restrict
            deferrable initially deferred
);

create table mdi.edw_join_definition
(
    dwid bigserial not null
        constraint pk_edw_join_definition
            primary key,
    primary_edw_table_definition_dwid bigint not null
        constraint fk_edw_join_definition_1
            references mdi.edw_table_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    target_edw_table_definition_dwid bigint not null
        constraint fk_edw_join_definition_2
            references mdi.edw_table_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    join_type text not null,
    join_condition text
);

create table mdi.edw_join_tree_definition
(
    dwid bigserial not null
        constraint pk_edw_join_tree_definition
            primary key,
    root_join_dwid bigint not null
        constraint fk_join_tree_definition_1
            references mdi.edw_join_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    sibling_join_tree_dwid bigint
        constraint fk_join_tree_definition_2
            references mdi.edw_join_tree_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    child_join_tree_dwid bigint
        constraint fk_join_tree_definition_3
            references mdi.edw_join_tree_definition
            on update restrict on delete restrict
            deferrable initially deferred
);

create table mdi.edw_field_definition
(
    dwid bigserial not null
        constraint pk_edw_field_definition
            primary key,
    edw_table_definition_dwid bigint not null
        constraint fk_edw_field_definition_1
            references mdi.edw_table_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    field_name text not null,
    key_field_flag boolean not null,
    source_edw_field_definition_dwid bigint
        constraint fk_edw_field_definition_2
            references mdi.edw_field_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    field_source_calculation text,
    source_edw_join_tree_definition_dwid bigint
        constraint fk_edw_field_definition_4
            references mdi.edw_join_tree_definition
            on update restrict on delete restrict
            deferrable initially deferred,
    data_type text,
    reporting_label text,
    reporting_description text,
    reporting_hidden mdi.looker_yes_no,
    reporting_key_flag boolean
);

create table mdi.delete_step
(
    dwid bigserial not null
        constraint pk_delete_step
            primary key,
    process_dwid bigint not null
        constraint fk_delete_step_1
            references mdi.process
            on update restrict on delete restrict
            deferrable initially deferred,
    connectionname text not null,
    schema_name text not null,
    table_name text not null,
    commit_size integer not null
);

create table mdi.delete_key
(
    dwid bigserial not null
        constraint pk_delete_key
            primary key,
    delete_step_dwid bigint not null
        constraint fk_delete_key_1
            references mdi.delete_step
            on update restrict on delete restrict
            deferrable initially deferred,
    table_name_field text not null,
    stream_fieldname_1 text not null,
    stream_fieldname_2 text not null,
    comparator text not null,
    is_sensitive boolean not null
);
