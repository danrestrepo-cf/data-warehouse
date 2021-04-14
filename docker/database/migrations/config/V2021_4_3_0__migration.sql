--
-- EDW | Update SP8.2, SP9.2, SP10.2 to not truncate target tables and update data types for monetary value fields
-- (https://app.asana.com/0/0/1200180166290103)
--

UPDATE mdi.csv_file_input_field
SET field_type = 'Number', field_format = '#.#'
FROM mdi.process
    JOIN mdi.csv_file_input_step ON process.dwid = csv_file_input_step.process_dwid
WHERE csv_file_input_step.dwid = csv_file_input_field.csv_file_input_step_dwid
  AND csv_file_input_field.field_name IN ('upb', 'avg_loan_size')
  AND process.name = 'SP10.1';

UPDATE mdi.table_output_step
SET truncate_table = 'N'
FROM mdi.process
WHERE process.dwid = table_output_step.process_dwid
    AND process.name IN ('SP8.2', 'SP9.2', 'SP10.2');
