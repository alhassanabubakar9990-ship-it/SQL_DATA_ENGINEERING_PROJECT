SELECT UNNEST( (1, 1, 1, 2))
UNION ALL
SELECT UNNEST( (1, 1,  3));

CREATE TEMP TABLE job_2023 AS
SELECT * EXCEPT(job_id, job_posted_date) = 2023
FROM job_postinges_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT * FROM job_2023;

CREATE TEMP TABLE job_2024 AS 
SELECT * EXTRACT(YEAR FROM job_posted_date)
FROM job_postinges_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM job_2024;

-- which unique job postings appeared in either 2023 or 2024?

SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) 
FROM job_2023
UNION
SELECT
    COUNT(*)
FROM job_2024;


SELECT * FROM job_2023
UNION
SELECT * FROM job_2024;

-- which job postings appeared across both years, counting duplicates?

SELECT * FROM job_2023
UNION ALL
SELECT * FROM job_2024;

-- which job postings appeared in but not in 2024?

SELECT * FROM job_2023
EXCEPT
SELECT * FROM job_2024;

-- which job postings from 2023 remain after subtracting matches 2024 postings, one_for_one?

SELECT * FROM job_2023
EXCEPT ALL
SELECT * FROM job_2024;

-- which job postings appeared in both 2023 and 2024?

SELECT * FROM job_2023
INTERSECT
SELECT * FROM job_2024;

-- which job postings appeared in both years, preserving duplicate?

SELECT * FROM job_2023
INTERSECT ALL
SELECT * FROM job_2024;