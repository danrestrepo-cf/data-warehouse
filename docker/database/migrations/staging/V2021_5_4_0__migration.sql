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
