SELECT CHAR_LENGTH('SQL');

SELECT LOWER('SQL');

SELECT UPPER('sql');

SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL',2);

SELECT SUBSTRING('SQL', 2, 1);

SELECT CONCAT('SQL', '-', 'Functions');

SELECT 'SQL' || '-' || 'Functions';

SELECT TRIM('   SQL   ');

SELECT REPLACE('SQL','Q','-');

SELECT REGEXP_REPLACE('data_ner@gmail.com', '^*(@)', '/1');

-- Finally Example - Cleanup this using Text Functions
WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM data_jobs.job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%analyst%'THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%scientist%'THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%engineer%'THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;

SELECT NULLIF(5 + 5, 20);

SELECT
       MEDIAN(NULLIF(salary_year_avg, 0)),
      MEDIAN(NULLIF(salary_hour_avg, 0))
FROM 
       job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL;  
ORDER BY salary_hour_avg       

SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
ORDER BY salary_year_avg
LIMIT 10;

SELECT COALESCE(NULL,NULL, 2);



--Finally Example - Simplifywith Coalesce
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150000 THEN 'Mid'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;