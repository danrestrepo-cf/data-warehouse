--
-- EDW Field Definitions | Validate the fields listed as key fields for transaction_dim are correct ( https://app.asana.com/0/0/1200373839614516 )
--

UPDATE
    mdi.edw_field_definition
SET
    key_field_flag = TRUE
WHERE
    dwid IN (
        SELECT
            f.dwid
        FROM
            mdi.edw_field_definition f
                JOIN mdi.edw_table_definition t
                ON f.edw_table_definition_dwid = t.dwid
        WHERE
            t.schema_name = 'star_loan'
            AND t.table_name = 'transaction_dim'
            AND f.field_name IN ( 'deal_pid', 'active_proposal_pid' )
    )
;

--
-- EDW | Modify hmda_purchaser_of_loan_dim to include separate columns for each year and build ETL to populate this dimension
-- https://app.asana.com/0/0/1200259416383677
--

ALTER TABLE star_loan.hmda_purchaser_of_loan_dim
    DROP COLUMN code,
    DROP COLUMN value,
    DROP COLUMN year,
    ADD COLUMN code_2017 VARCHAR(128),
    ADD COLUMN value_2017 VARCHAR(1024),
    ADD COLUMN code_2018 VARCHAR(128),
    ADD COLUMN value_2018 VARCHAR(1024);
