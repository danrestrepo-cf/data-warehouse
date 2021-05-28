--
-- EDW | config db - move new looker_yes_no type from flyway schema to mdi schema
-- https://app.asana.com/0/0/1200396657976213
--
--create new version of looker_yes_no type in mdi schema
CREATE TYPE mdi.looker_yes_no AS ENUM ('yes', 'no');

--update reporting_hidden column to use the new type
ALTER TABLE mdi.edw_field_definition
    ALTER COLUMN reporting_hidden TYPE mdi.looker_yes_no USING TEXT(reporting_hidden)::mdi.looker_yes_no;

-- remove old type
DROP TYPE flyway.looker_yes_no;
