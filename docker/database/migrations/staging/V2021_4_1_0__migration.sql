--
-- EDW | NMLS Call Report State table | Rename average_loan_size column, affected views
-- (https://app.asana.com/0/0/1200094798056228)
--

-- Drop nmls_call_report_state view
DROP VIEW IF EXISTS octane_data_mart.nmls_call_report_state;

-- Rename average_loan_size column in view's source table
ALTER TABLE staging_compliance.nmls_call_report_state
    RENAME COLUMN average_loan_size TO average_unpaid_balance;

-- Re-create view with updated column name
CREATE VIEW octane_data_mart.nmls_call_report_state(mcr_field_id, mcr_description, state_type, total_unpaid_balance_amount, loan_count, average_unpaid_balance_amount, report_quarter) AS
SELECT nmls_call_report_state.mcr_field_id,
       nmls_call_report_state.mcr_description,
       nmls_call_report_state.state_type,
       nmls_call_report_state.total_unpaid_balance AS total_unpaid_balance_amount,
       nmls_call_report_state.loan_count,
       nmls_call_report_state.average_unpaid_balance AS average_unpaid_balance_amount,
       nmls_call_report_state.report_quarter
FROM staging_compliance.nmls_call_report_state;


--
-- EDW | Add zero record to date dimension table, update weekday_chronological field
--

-- Alter date dimension table to remove NOT NULL constraints from all non-dwid fields with NOT NULL constraints
ALTER TABLE star_common.date_dim ALTER COLUMN value DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN date_format_iso_8601 DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN date_format_us DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_month_suffix DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_chronological DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_year DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_quarter DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_month DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_week DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_first_day_of_year DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_last_day_of_year DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_first_day_of_quarter DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_last_day_of_quarter DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_first_day_of_month DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_last_day_of_month DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_first_day_of_week DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_last_day_of_week DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_weekday DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_weekend DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_week_name DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_week_name_short DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN day_of_week_name_letter DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_leap_year DROP NOT NULL;
ALTER TABLE star_common.date_dim ALTER COLUMN is_leap_day DROP NOT NULL;

-- Insert a row into the star_common.date_dim table that has a dwid value of 0 and NULLs in all other fields
INSERT INTO star_common.date_dim (dwid, value, date_format_iso_8601, date_format_us, day_of_month_suffix, day_chronological,
    weekday_chronological, day_of_year, day_of_quarter, day_of_month, day_of_week, is_first_day_of_year, is_last_day_of_year,
    is_first_day_of_quarter, is_last_day_of_quarter, is_first_day_of_month, is_last_day_of_month, is_first_day_of_week,
    is_last_day_of_week, is_weekday, is_weekend, day_of_week_name, day_of_week_name_short, day_of_week_name_letter,
    is_leap_year, is_leap_day, week_of_year, quarter_of_year, quarter_chronological, quarter_name, year, month_of_year,
    days_in_month, first_day_of_month, last_day_of_month, first_day_of_week, week_name, week_format_iso_8601)
VALUES (0 ,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Remove trailing whitespace from values in day_of_week_name field
UPDATE star_common.date_dim
    SET day_of_week_name = TRIM(TRAILING FROM day_of_week_name);

-- Populate weekday_chronological column for rows that correspond to Saturdays or Sundays
-- Saturdays:
UPDATE star_common.date_dim
    SET weekday_chronological = (
        SELECT monday.weekday_chronological
        FROM star_common.date_dim monday
        WHERE monday.value = date_dim.value + INTERVAL '2 DAY'
        )
    WHERE date_dim.day_of_week_name = 'Saturday';
-- Sundays:
UPDATE star_common.date_dim
SET weekday_chronological = (
    SELECT monday.weekday_chronological
    FROM star_common.date_dim monday
    WHERE monday.value = date_dim.value + INTERVAL '1 DAY'
)
WHERE date_dim.day_of_week_name = 'Sunday';