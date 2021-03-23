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

INSERT INTO star_common.date_dim (
	dwid
	, value
	, date_format_iso_8601
	, date_format_us
	, day_of_month_suffix
	, day_chronological
	, weekday_chronological
	, day_of_year
	, day_of_quarter
	, day_of_month
	, day_of_week
	, is_first_day_of_year
	, is_last_day_of_year
	, is_first_day_of_quarter
	, is_last_day_of_quarter
	, is_first_day_of_month
	, is_last_day_of_month
	, is_first_day_of_week
	, is_last_day_of_week
	, is_weekday
	, is_weekend
	, day_of_week_name
	, day_of_week_name_short
	, day_of_week_name_letter
	, is_leap_year
	, is_leap_day
)

WITH CTE_A AS (
    SELECT REPLACE(datum::TEXT, '-', '')::INTEGER AS dwid
         , datum AS value
         , datum::TEXT AS date_format_iso_8601
		 , TO_CHAR(datum, 'MM-DD-YYYY') AS date_format_us
         , TO_CHAR(datum, 'fmDDth') AS day_of_month_suffix
         , ROW_NUMBER() OVER (ORDER BY datum) AS day_chronological
         , ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM datum) ORDER BY datum) day_of_year
         , ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM datum), EXTRACT(QUARTER FROM datum) ORDER BY datum) day_of_quarter
         , ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM datum), EXTRACT(MONTH FROM datum) ORDER BY datum) day_of_month
         , EXTRACT(ISODOW FROM datum) day_of_week
         , CASE WHEN EXTRACT(MONTH FROM datum) = 1 AND EXTRACT(DAY FROM datum) = 1
                    THEN TRUE
                ELSE FALSE
        END AS is_first_day_of_year
         , CASE WHEN EXTRACT(MONTH FROM datum) = 12 AND EXTRACT(DAY FROM datum) = 31
                    THEN TRUE
                ELSE FALSE
        END AS is_last_day_of_year
         , CASE WHEN CONCAT(EXTRACT(MONTH FROM datum), EXTRACT(DAY FROM datum)) IN ('11', '41', '71', '101')
                    THEN TRUE
                ELSE FALSE
        END AS is_first_day_of_quarter
         , CASE WHEN CONCAT(EXTRACT(MONTH FROM datum), EXTRACT(DAY FROM datum)) IN ('331', '630', '930', '1231')
                    THEN TRUE
                ELSE FALSE
        END AS is_last_day_of_quarter
         , CASE WHEN EXTRACT(DAY FROM datum) = 1
                    THEN TRUE
                ELSE FALSE
        END AS is_first_day_of_month
         , CASE WHEN (
            (EXTRACT(MONTH FROM datum) IN (1, 3, 5, 7, 8, 10, 12) AND EXTRACT(DAY FROM datum) = 31)

			OR (EXTRACT(MONTH FROM datum) IN (4, 6, 9, 11) AND EXTRACT(DAY FROM datum) = 30)

			OR (
			SUBSTRING(EXTRACT(YEAR FROM datum)::TEXT, 3, 4) != '00'
			AND MOD(EXTRACT(YEAR FROM datum)::INT, 4) = 0
            AND EXTRACT(MONTH FROM datum) = 2
            AND EXTRACT(DAY FROM datum) = 29
			)

			OR (
			SUBSTRING(EXTRACT(YEAR FROM datum)::TEXT, 3, 4) = '00'
			AND MOD(EXTRACT(YEAR FROM datum)::INT, 400) = 0
            AND EXTRACT(MONTH FROM datum) = 2
            AND EXTRACT(DAY FROM datum) = 29
			)

			OR (MOD(EXTRACT(YEAR FROM datum)::INT, 4) != 0
            AND EXTRACT(MONTH FROM datum) = 2
            AND EXTRACT(DAY FROM datum) = 28)
        	)   THEN TRUE
                ELSE FALSE
        END AS is_last_day_of_month
         , CASE WHEN EXTRACT(ISODOW FROM datum) = 1
                    THEN TRUE
                ELSE FALSE
        END AS is_first_day_of_week
         , CASE WHEN EXTRACT(ISODOW FROM datum) = 7
                    THEN TRUE
                ELSE FALSE
        END AS is_last_day_of_week
         , CASE WHEN EXTRACT(ISODOW FROM datum) IN (1, 2, 3, 4, 5)
                    THEN TRUE
                ELSE FALSE
        END AS is_weekday
         , CASE WHEN EXTRACT(ISODOW FROM datum) IN (6, 7)
                    THEN TRUE
                ELSE FALSE
        END AS is_weekend
         , TO_CHAR(datum, 'Day') weekday_name
         , TO_CHAR(datum, 'DY') weekday_name_short
		 , CASE
               WHEN TO_CHAR(datum, 'DY') = 'MON' THEN 'M'
               WHEN TO_CHAR(datum, 'DY') = 'TUE' THEN 'T'
               WHEN TO_CHAR(datum, 'DY') = 'WED' THEN 'W'
               WHEN TO_CHAR(datum, 'DY') = 'THU' THEN 'T'
               WHEN TO_CHAR(datum, 'DY') = 'FRI' THEN 'F'
               WHEN TO_CHAR(datum, 'DY') = 'SAT' THEN 'S'
               WHEN TO_CHAR(datum, 'DY') = 'SUN' THEN 'S'
        END AS weekday_name_letter
         , MOD(EXTRACT(YEAR FROM datum)::INT, 4) = 0
			AND NOT (
				MOD(EXTRACT(YEAR FROM datum)::INT, 100) = 0
			 		AND MOD(EXTRACT(YEAR FROM datum)::INT, 400) != 0)  is_leap_year
		, CASE WHEN EXTRACT(MONTH FROM datum) = 2 AND EXTRACT(DAY FROM datum) = 29
			THEN TRUE
			ELSE FALSE
		END AS is_leap_day
    FROM (
             SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS datum
             FROM GENERATE_SERIES(0, ('2099-12-31'::DATE - '1970-01-01'::DATE)) AS SEQUENCE (DAY)
             GROUP BY SEQUENCE.DAY
         ) subq
)

SELECT CTE_A.dwid
     , value
     , date_format_iso_8601
	 , date_format_us
     , day_of_month_suffix
     , day_chronological
     , weekdays.weekday_chronological
     , day_of_year
     , day_of_quarter
     , day_of_month
     , day_of_week
     , is_first_day_of_year
     , is_last_day_of_year
     , is_first_day_of_quarter
     , is_last_day_of_quarter
     , is_first_day_of_month
     , is_last_day_of_month
     , is_first_day_of_week
     , is_last_day_of_week
     , is_weekday
     , is_weekend
     , weekday_name
     , weekday_name_short
	 , weekday_name_letter
	 , is_leap_year
	 , is_leap_day
FROM CTE_A
	LEFT JOIN (
		SELECT dwid
			 , ROW_NUMBER() OVER (ORDER BY dwid) weekday_chronological
		FROM CTE_A
		WHERE is_weekday = TRUE
	) weekdays ON CTE_A.dwid = weekdays.dwid
WHERE CTE_A.value >= '2000-01-01';