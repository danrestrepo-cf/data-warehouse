\COPY dmi.nmls_call_report_state (data_source_dwid, input_filename, mcr_code, mcr_description, state_code, sum_of_upb, loan_count, avg_loan_size, report_quarter) TO '/input/actual_output.csv' WITH (FORMAT CSV,HEADER);