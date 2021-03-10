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
SET   week_of_year = extract(week from value)
    , quarter_of_year = extract(quarter from value)
    , quarter_chronological = (extract(year from value) - extract(year from '01-01-1970'::DATE)) * 4 + extract(quarter from value)
    , quarter_name = extract(year from value)  || 'Q' || extract(quarter from value)
    , year = extract(year from value)
    , month_of_year = extract(month from value)
    , days_in_month = extract(day from (date_trunc('month', value) + '1 MONTH'::INTERVAL) - '1 DAY'::INTERVAL)
    , first_day_of_month = date_trunc('month', value)
    , last_day_of_month = ((date_trunc('month', value) + '1 month'::INTERVAL) - '1 day'::INTERVAL)
    , first_day_of_week = value - ((6 + cast(extract(isodow from value) AS int)) % 7)
    , week_name = 'Week of ' || (value - ((6 + cast(extract(isodow from value) AS int)) % 7))
    , week_format_iso_8601 = 'W' || to_char(value, 'IW'); -- this is using to_char to simplify the logic since extract() returns a double and we want the leading zero
