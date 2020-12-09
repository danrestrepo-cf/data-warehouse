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
    process_dwid IN ( 1, 2 ) -- update for SP8.1 and SP9.1
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
    process_dwid = 3 -- update for SP10.1
;

--
-- create settings table for Table Input step in Pentaho
--
CREATE TABLE mdi.table_input_step
(
    dwid BIGSERIAL NOT NULL
        CONSTRAINT table_input_step_pk
            PRIMARY KEY,
    process_dwid BIGINT NOT NULL,
    data_source_dwid BIGINT,
    sql TEXT NOT NULL,
    limit_size integer default 0, -- default to zero so Pentaho will return ALL rows queried
    execute_for_each_row mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    replace_variables mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    enable_lazy_conversion mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    cached_row_meta mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    connectionname mdi.PENTAHO_DB_CONNECTION_NAME NOT NULL
);
