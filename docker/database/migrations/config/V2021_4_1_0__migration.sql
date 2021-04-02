--
--  EDW - Change data type on CSV File Input field config table from bigserial to bigint (https://app.asana.com/0/0/1199550969880905/)
--

ALTER TABLE mdi.csv_file_input_field ALTER COLUMN csv_file_input_step_dwid DROP DEFAULT;
DROP SEQUENCE mdi.csv_file_input_field_csv_file_input_step_dwid_seq;
