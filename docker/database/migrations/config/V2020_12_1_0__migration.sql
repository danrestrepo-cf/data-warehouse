-- add field needed to identify sensitive fields
ALTER TABLE
    mdi.table_output_field
ADD
    is_sensitive BOOLEAN;

-- set all fields that are configured to output to a table to not sensitive
UPDATE
    mdi.table_output_field
SET
    is_sensitive=FALSE
WHERE
    table_output_field.is_sensitive IS NULL;

-- add NOT NULL to newly created field
ALTER TABLE
    mdi.table_output_field
    ALTER COLUMN
        is_sensitive SET NOT NULL;

-- -- manually set sensitive fields used for testing
-- UPDATE
--     mdi.table_output_field
-- SET
--     is_sensitive=TRUE
-- WHERE
--         dwid IN
--         (
--               4 -- unpaid_balance in SP8.1
--             ,13 -- unpaid_balance in SP9.1
--             ,18 -- unpaid_balance in SP10.1
--         );
