CREATE TABLE star_common.date_dim (
    dwid INTEGER PRIMARY KEY
    , value DATE NOT NULL
    , date_format_iso_8601 CHAR(10) NOT NULL
	, date_format_us CHAR(10) NOT NULL
    , day_of_month_suffix VARCHAR(4) NOT NULL
    , day_chronological INTEGER NOT NULL
    , weekday_chronological INTEGER NULL
    , day_of_year SMALLINT NOT NULL
    , day_of_quarter SMALLINT NOT NULL
    , day_of_month SMALLINT NOT NULL
    , day_of_week SMALLINT NOT NULL
    , is_first_day_of_year BOOLEAN NOT NULL
    , is_last_day_of_year BOOLEAN NOT NULL
    , is_first_day_of_quarter BOOLEAN NOT NULL
    , is_last_day_of_quarter BOOLEAN NOT NULL
    , is_first_day_of_month BOOLEAN NOT NULL
    , is_last_day_of_month BOOLEAN NOT NULL
    , is_first_day_of_week BOOLEAN NOT NULL
    , is_last_day_of_week BOOLEAN NOT NULL
    , is_weekday BOOLEAN NOT NULL
    , is_weekend BOOLEAN NOT NULL
    , day_of_week_name VARCHAR(9) NOT NULL
    , day_of_week_name_short CHAR(3) NOT NULL
    , day_of_week_name_letter CHAR(1) NOT NULL
    , is_leap_year BOOLEAN NOT NULL
    , is_leap_day BOOLEAN NOT NULL
);
