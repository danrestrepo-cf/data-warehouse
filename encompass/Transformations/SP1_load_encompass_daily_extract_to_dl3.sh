#!/bin/bash
# 
# Environment Variables/Parameters
# 
# log_transformation_table_name - Name of the transformation logging table.
# log_channel_table_name - Name of the channel logging table.
# log_file_extension_for_aws - The file extension for the log file that contains the records if the data in the row is parsed successfully and could be inserted into the database.
# log_path_for_aws - The path for the log file that contains the records if the data in the row is parsed successfully or not.
# input_csv_path_and_filename - The full file path where the input CSV file is located.
# log_interval - How often to flush logs to the disk/database (in seconds).
# log_metrics_table_name - Name of the metrics logging table.
# log_performance_table_name - Name of the performance logging table.
# log_record_timeout - How often to remove logs from the database (in days).
# log_step_table_name - Name of the step logging table.
# log_table_schema - The name of the database schema the log tables are in.
# log_filename_parse_ok_insert_fail - The filename for the log file that contains the records if the data in the row is parsed successfully but could not be inserted into the database.
# log_filename_parse_ok_insert_ok - The filename for the log file that contains the records if the data in the row is parsed successfully and could be inserted into the database.
# log_filename_parse_fail_insert_ok - The filename for the log file that contains the records if the data in the row failed to parse but could be inserted into the database.
# log_filename_parse_fail_insert_fail - The filename for the log file that contains the records if the data in the row failed to parse and could not be inserted into the database.
# postgres_transform_database_name - The name of the database the transform will use.
# postgres_transform_hostname - The hostname to the database system.
# postgres_transform_password - The password to connect to the database system.
# postgres_transform_port - The port to connect to the database system.
# postgres_transform_username - The username to connect to the database system.
# sql_schema_name - The name of the database schema the Encompass data will flow into.
# sql_target_table_name_error - The name of the table where errors are saved if they contain data that can't be validated.
# sql_target_table_name_success - The name of the table where rows are successfully submitted into the data lake 3.


export pan_batch_script_file_location="/pdi/data-integration/pan.sh"
export transformation_file_location="./load_encompass_daily_extract_to_dl3_SP1.ktr"
export pan_log_level="Debug"
${pan_batch_script_file_location} -file:"${transformation_file_location}" -level:${pan_log_level} -param:"log_transformation_table_name=${log_transformation_table_name}" -param:"log_channel_table_name=${log_channel_table_name}" -param:"input_csv_path_and_filename=${input_csv_path_and_filename}" -param:"log_interval=${log_interval}" -param:"log_metrics_table_name=${log_metrics_table_name}" -param:"log_performance_table_name=${log_performance_table_name}" -param:"log_record_timeout=${log_record_timeout}" -param:"log_step_table_name=${log_step_table_name}" -param:"log_table_schema=${log_table_schema}" -param:"postgres_transform_database_name=${postgres_transform_database_name}" -param:"postgres_transform_hostname=${postgres_transform_hostname}" -param:"postgres_transform_password=${postgres_transform_password}" -param:"postgres_transform_port=${postgres_transform_port}" -param:"postgres_transform_username=${postgres_transform_username}" -param:"sql_schema_name=${sql_schema_name}" -param:"sql_target_table_name_error=${sql_target_table_name_error}" -param:"sql_target_table_name_success=${sql_target_table_name_success}"