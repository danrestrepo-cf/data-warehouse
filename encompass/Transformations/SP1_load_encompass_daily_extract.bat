rem 
rem Environment Variables/Parameters
rem 

rem input_csv_path_and_filename - The full file path where the input CSV file is located.
rem database_name - The name of the database the transform will use.
rem database_hostname - The hostname to the database system.
rem database_password - The password to connect to the database system.
rem database_port - The port to connect to the database system.
rem database_username - The username to connect to the database system.



set pan_batch_script_file_location="C:\pdi\data-integration\pan.bat"
set transformation_file_location="%HOMEDRIVE%%HOMEPATH%\Documents\GitHub\etl\encompass\Transformations\SP1_load_encompass_daily_extract.ktr"

rem Rowlevel, Debug, Error, Basic
set pan_log_level=Debug

call %pan_batch_script_file_location% /file:"%transformation_file_location%" /level:%pan_log_level% /param:"input_csv_path_and_filename=%input_csv_path_and_filename%" /param:"database_name=%database_name%" /param:"database_hostname=%database_hostname%" /param:"database_password=%database_password%" /param:"database_port=%database_port%" /param:"database_username=%database_username%"

