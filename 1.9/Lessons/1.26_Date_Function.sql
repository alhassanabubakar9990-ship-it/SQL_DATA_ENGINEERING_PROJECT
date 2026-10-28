SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMP AS timestampz
FROM job_postings_fact
LIMIT 10;

SELECT
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT(YEAR FROM job_posted_date),
    EXRACT(MONTH FROM job_posted_date)
ORDER BY
    job_posted_year,
    job_posted_month;




SELECT 
    job_posted_date,
    DATE_TRUCK('year', job_posted_date) AS job_posted_year,
    DATE_TRUCK('quarter',job_posted_date) AS truncated_quarter,
    DATE_TRUCK('month', job_posted_date) AS DATE_truncated_month,
    DATE_TRUCK('week', job_posted_date) AS truncated_week,
    DATE_TRUCK('day', job_posted_date) AS truncated_day,
    DATE_TRUCK('hour', job_posted_date) AS truncated_hour
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;

SELECT
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer' AND
      DATE_TRUNC('year', job_posted_date) = '2024-01-01'
--      EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY
    DATE_TRUNC('month', job_posted_date),
ORDER BY
    job_posted_month;


SELECT
    '2026-01-10 00:00:00:00'::TIMESTAMPTZ AT TIME ZONE 'EST';

SELECT
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
WHERE
    job_location LIKE 'New York, NY';

SELECT 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
    COUNT(job_id) 
FROM 
    job_postings_fact
WHERE 
    job_location LIKE 'New York, NY'
GROUP BY
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
ORDER BY
    job_posted_hour;