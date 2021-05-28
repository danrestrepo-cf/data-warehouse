--
-- EDW | edw_field_definition table: reporting_hidden field has yes/no AND true/false as possible values
-- https://app.asana.com/0/0/1200391232357557
--

-- fix existing value errors in reporting_hidden
UPDATE mdi.edw_field_definition
SET reporting_hidden = 'yes'
WHERE reporting_hidden = 'true';

UPDATE mdi.edw_field_definition
SET reporting_hidden = 'no'
WHERE reporting_hidden = 'false';

--prevent similar errors in the future
CREATE TYPE looker_yes_no AS ENUM ('yes', 'no');

ALTER TABLE mdi.edw_field_definition
    ALTER COLUMN reporting_hidden TYPE looker_yes_no USING reporting_hidden::looker_yes_no;
