---
--- Add Encompass MCR related fields to EDW: https://app.asana.com/0/0/1193468447043569
---

-- add the fields to the date_dim table
ALTER TABLE star_common.date_dim ADD COLUMN week_of_year SMALLINT;
ALTER TABLE star_common.date_dim ADD COLUMN quarter_of_year SMALLINT;
ALTER TABLE star_common.date_dim ADD COLUMN quarter_chronological INTEGER;
ALTER TABLE star_common.date_dim ADD COLUMN quarter_name CHAR(6);
ALTER TABLE star_common.date_dim ADD COLUMN year SMALLINT;
ALTER TABLE star_common.date_dim ADD COLUMN month_of_year SMALLINT;
ALTER TABLE star_common.date_dim ADD COLUMN days_in_month SMALLINT;
ALTER TABLE star_common.date_dim ADD COLUMN first_day_of_month DATE;
ALTER TABLE star_common.date_dim ADD COLUMN last_day_of_month DATE;
ALTER TABLE star_common.date_dim ADD COLUMN first_day_of_week DATE;
ALTER TABLE star_common.date_dim ADD COLUMN week_name TEXT;
ALTER TABLE star_common.date_dim ADD COLUMN week_format_iso_8601 VARCHAR(3);

-- add values to the newly defined fields
UPDATE star_common.date_dim SET week_of_year = to_char(value, 'WW')::SMALLINT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET quarter_of_year = to_char(value, 'Q')::SMALLINT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET quarter_chronological = to_char(value, 'WW')::SMALLINT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET quarter_name = to_char(value, 'YYYY')::TEXT || 'Q' || to_char(value, 'Q')::TEXT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET year = to_char(value, 'YYYY')::SMALLINT || 'Q' || quarter_name WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET month_of_year = to_char(value, 'MM')::SMALLINT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET days_in_month = extract('days', date_trunc('month', value) + '1 MONTH'::INTERVAL - '1 DAY'::INTERVAL)::SMALLINT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET first_day_of_month = date_trunc('month', value)::DATE WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET last_day_of_month = ((date_trunc('month', value) + '1 month'::INTERVAL) - '1 day'::INTERVAL)::DATE WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET first_day_of_week = value - ((6 + cast(extract(dow FROM value) AS int)) % 7) WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET week_name = 'Week of ' || (value - ((6 + cast(extract(dow FROM value) AS int)) % 7))::TEXT WHERE 1=1; -- force the query to work
UPDATE star_common.date_dim SET week_format_iso_8601 = 'W' || to_char(value, 'WW')::SMALLINT WHERE week_of_year > 9;
UPDATE star_common.date_dim SET week_format_iso_8601 = 'W0' || to_char(value, 'WW')::SMALLINT WHERE week_of_year <= 9;
