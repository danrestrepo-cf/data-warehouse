--
--  EDW - Change data type on CSV File Input field config table from bigserial to bigint (https://app.asana.com/0/0/1199550969880905/)
--

ALTER TABLE mdi.csv_file_input_field ALTER COLUMN csv_file_input_step_dwid DROP DEFAULT;
DROP SEQUENCE mdi.csv_file_input_field_csv_file_input_step_dwid_seq;

--
-- EDW | NMLS Call Report State table | Rename average_loan_size column, affected views
-- (https://app.asana.com/0/0/1200094798056228)
--

-- Update mdi.config.table_output_field table
-- For dwid = 27 change the database_field_name column’s value from average_loan_size to average_unpaid_balance
UPDATE mdi.table_output_field
    SET database_field_name = 'average_unpaid_balance'
    WHERE dwid = 27;