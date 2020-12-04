-- create additional field to csv input to track where the input data came from
ALTER TABLE
    mdi.csv_file_input_step
    ADD
        data_source_dwid BIGINT
;

-- populate values for csv input
UPDATE
    mdi.csv_file_input_step
SET
    data_source_dwid=3
WHERE
    process_dwid in (1, 2) -- update for SP8.1 and SP9.1
;


-- create additional field to excel input to track where the input data came from
ALTER TABLE
    mdi.microsoft_excel_input_step
    ADD
        data_source_dwid BIGINT
;

-- populate values for excel input
UPDATE
    mdi.microsoft_excel_input_step
SET
    data_source_dwid=3
WHERE
        process_dwid=3 -- update for SP10.1
;