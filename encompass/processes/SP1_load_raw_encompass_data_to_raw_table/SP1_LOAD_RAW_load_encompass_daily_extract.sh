#!/bin/bash
# 
# Environment Variables/Parameters
# 
# input_csv_path_and_filename - The full file path where the input CSV file is located.
# database_name - The name of the database the transform will use.
# database_hostname - The hostname to the database system.
# database_password - The password to connect to the database system.
# database_port - The port to connect to the database system.
# database_username - The username to connect to the database system.


export pan_batch_script_file_location="/pdi/data-integration/pan.sh"
export transformation_file_location="./SP1_load_encompass_daily_extract.ktr"
export kettle_home_path="/Volumes/Elements/data-integration/data/"

# Rowlevel, Debug, Error, Basic
export pan_log_level="Debug"
${pan_batch_script_file_location} -DKETTLE_HOME="${kettle_home_path}" -file:"${transformation_file_location}" -level:${pan_log_level} -param:"input_csv_path_and_filename=${input_csv_path_and_filename}" -param:"database_name=${database_name}" -param:"database_hostname=${database_hostname}" -param:"database_password=${database_password}" -param:"database_port=${database_port}" -param:"database_username=${database_username}" 