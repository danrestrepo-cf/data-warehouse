-- add field needed to identify sensitive fields and set all fields
-- that are configured to output to a table to not sensitive
ALTER TABLE
    mdi.table_output_field
ADD
    is_sensitive BOOLEAN default FALSE NOT NULL;

-- remove default value from field
ALTER TABLE
    mdi.table_output_field
    ALTER COLUMN
        is_sensitive DROP default;

-- set all fields that are configured to output to a table to not sensitive
UPDATE
    mdi.table_output_field
SET
    is_sensitive=FALSE
WHERE 1=1;

-- manually set sensitive fields
UPDATE
    mdi.table_output_field
SET
    is_sensitive=TRUE
WHERE
        dwid IN
        (
              4 -- unpaid_balance in SP8.1
            ,13 -- unpaid_balance in SP9.1
            ,18 -- unpaid_balance in SP10.1
        );
