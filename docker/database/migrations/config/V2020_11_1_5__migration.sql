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

-- add NOT NULL to newly created field since all rows have a value now
ALTER TABLE
    mdi.table_output_field
    ALTER COLUMN
        is_sensitive SET NOT NULL;
