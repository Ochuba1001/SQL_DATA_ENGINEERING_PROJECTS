/* 
3 most common used in SQL are 'EXTRACT', 'DATE_TRUNC', and 'AT TIME ZONE' 
*/

SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestampz
FROM
    job_postings_fact
LIMIT 30;

--      EXTRACT 
/* It get field from a day/time value */

SELECT 
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    EXTRACT(DAY FROM job_posted_date) AS job_posted_day
FROM 
    job_postings_fact
LIMIT 30;

-- Using Extract for aggregation

SELECT 
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Engineer'
GROUP BY 
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY
    job_posted_year,
    job_posted_month;

--                                      DATE_TRUNC
/* It truncate a date or timestamp to a specified level of precision. It returns a rounded down to the start of the specific time unit. 
It requires the use of a single quote and written in lower case*/

SELECT 
    job_posted_date,
    DATE_TRUNC('year',job_posted_date) AS truncated_year,
    DATE_TRUNC('quarter',job_posted_date) AS truncated_quarter,
    DATE_TRUNC('month',job_posted_date) AS truncated_month,
    DATE_TRUNC('week',job_posted_date) AS truncated_week,
    DATE_TRUNC('day',job_posted_date) AS truncated_day,
    DATE_TRUNC('hour',job_posted_date) AS truncated_hour
FROM 
    job_postings_fact
ORDER BY RANDOM()
LIMIT 30;

-- For  aggregation

SELECT 
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Engineer' AND 
    EXTRACT(YEAR FROM job_posted_date) = 2024
--  DATE_TRUNC('year', job_posted_date) = '2024-01-01'
GROUP BY 
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;

--                                      AT TIME ZONE
/* It converts to a specified time zone */

SELECT 
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ;

SELECT 
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'EST';

SELECT 
    '2026-01-01 00:00:00-01'::TIMESTAMPTZ AT TIME ZONE 'GMT';

/* Timestamps without time zone is automatically treated as local time in DuckDB.
Using AT TIME ZONE assumes the machine's time zone for conversion */

SELECT
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'GMT'   
FROM
    job_postings_fact
LIMIT 10;


SELECT
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
WHERE 
    job_location LIKE 'New York, NY';

SELECT
    job_title_short,
    job_location,
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
WHERE 
    job_location LIKE 'New York, NY'
GROUP BY
    job_title_short,
    job_location,
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
ORDER BY 
    job_posted_hour;

SELECT 
    job_title_short
FROM
    job_postings_fact;