---
--- Date dimension phase 2: https://app.asana.com/0/0/1199527286976958
---

-- add the fields to the date_dim table
ALTER TABLE star_common.date_dim
    ADD COLUMN week_of_year SMALLINT
    , ADD COLUMN quarter_of_year SMALLINT
    , ADD COLUMN quarter_chronological INTEGER
    , ADD COLUMN quarter_name CHAR(6)
    , ADD COLUMN year SMALLINT
    , ADD COLUMN month_of_year SMALLINT
    , ADD COLUMN days_in_month SMALLINT
    , ADD COLUMN first_day_of_month DATE
    , ADD COLUMN last_day_of_month DATE
    , ADD COLUMN first_day_of_week DATE
    , ADD COLUMN week_name TEXT
    , ADD COLUMN week_format_iso_8601 VARCHAR(3);

-- add values to the newly defined fields
UPDATE star_common.date_dim
SET   week_of_year = to_char(value, 'IW')::SMALLINT
    , quarter_of_year = to_char(value, 'Q')::SMALLINT
    , quarter_chronological = (date_part('year', value) - date_part('year', '01-01-1970'::DATE)) * 4 + to_char(value, 'Q')::INTEGER
    , quarter_name = to_char(value, 'YYYY')::TEXT || 'Q' || to_char(value, 'Q')::TEXT
    , year = to_char(value, 'YYYY')::SMALLINT
    , month_of_year = to_char(value, 'MM')::SMALLINT
    , days_in_month = extract(day from (date_trunc('month', value) + '1 MONTH'::INTERVAL) - '1 DAY'::INTERVAL)::SMALLINT
    , first_day_of_month = date_trunc('month', value)::DATE
    , last_day_of_month = ((date_trunc('month', value) + '1 month'::INTERVAL) - '1 day'::INTERVAL)::DATE
    , week_name = 'Week of ' || (value - ((6 + cast(extract(ISODOW FROM value) AS int)) % 7))::TEXT
    , week_format_iso_8601 = 'W' || to_char(value, 'IW')
    , first_day_of_week = value - ((6 + cast(extract(ISODOW FROM value) AS int)) % 7);
