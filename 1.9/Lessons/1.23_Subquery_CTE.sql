-- Subquery
SELECT *
FROM (
    SELECT *
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

--CTE
WITH valid_salaries AS (
    SELECT *
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
       OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries;

-- 🧩 Scenario 1-Subquery in 'SELECT'
-- Show each job's salary next to the overall market median:
SELECT
    job_title,
    salary_year_avg,
    (
      SELECT MEDIAN(salary_year_avg)
      FROM data_jobs.job_postings_fact
    ) AS market_median_salary
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    LIMIT 10; 


-- 🧩 Scenario 2-Subquery in FROM
-- stage omly jobs that are remote before aggregating:
SELECT
    job_title,
    MEDIAN(salary_year_avg) AS median_salary,
    (
      SELECT MEDIAN(salary_year_avg)
      FROM data_jobs.job_postings_fact
      WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
    FROM(
        SELECT 
        job_title,
        salary_year_avg
      FROM data_jobs.job_postings_fact
      WHERE job_work_from_home = TRUE
    ) AS cleaned_jobs
    GROUP BY job_title
    LIMIT 10; 


-- 🧩 Scenario 3-Subquery in'HAVING
-- keep only job tittles whose median salary is above the overall median
 SELECT
    job_title,
    MEDIAN(salary_year_avg) AS median_salary,
    (
      SELECT MEDIAN(salary_year_avg)
      FROM data_jobs.job_postings_fact
      WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
    FROM(
        SELECT 
        job_title,
        salary_year_avg
      FROM data_jobs.job_postings_fact
      WHERE job_work_from_home = TRUE
    ) AS cleaned_jobs
    GROUP BY job_title
    HAVING MEDIAN(salary_year_avg) > (
      SELECT MEDIAN(salary_year_avg)
      FROM data_jobs.job_postings_fact
      WHERE job_work_from_home = TRUE
    )
    LIMIT 10; 

-- CTE Example
-- compare how much more (or last) remote roles pay compared to onsite roles:
-- the a CTE to calculate the median salary by title and work arrengement, than compare those medians.
WITH title_medians AS (
    SELECT 
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM data_jobs.job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)
SELECT 
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_medians AS r
INNER JOIN title_medians AS o
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC
LIMIT 10;






SELECT
FROM range(3) AS scr(key);

SELECT
FROM range(3) AS tgt(key);


SELECT
FROM range(3) AS scr(key);
WHERE EXISTS (
    SELECT 1
    FROM range(3) AS tgt(key)
    WHERE scr.key = tgt.key
);

-- < Final Example 
-- identify job postings that have no associated skills before them into a data mart
SELECT * 
FROM job_postings_fact 
ORDER BY job_id
LIMIT 10;

SELECT *
FROM skill_job_din
ORDER BY job_id
LIMIT 40;

SELECT *
FROM data_jobs.job_postings_fact AS tgt
WHERE  EXISTS (
    SELECT 1
    FROM data_jobs.skills_job_dim AS scr
    WHERE tgt.job_id = scr.job_id
)
ORDER BY job_id;