-- CREATE TEMP table
CREATE OR REPLACE TEMP TABLE scr_priority_jobs AS 
SELECT
  jpf.job_id,
  jpf.job_title_short,
  cd.name AS company_name,
  jpf.job_posted_date,
  jpf.salary_year_avg,
  r.priority_lvl,
  CURRENT_TIMESTAMP AS updated_at
FROM
  data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
      ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
      ON jpf.job_title_short = r.role_name;

-- -- UPDATE statement
-- UPDATE main.priority_jobs_snapshot AS tgt
-- SET
--     priority_lvl = scr.priority_lvl,
--     updated_at = scr.updated_at
-- FROM scr_priority_jobs AS scr
-- WHERE tgt.job_id = scr.job_id
--    AND tgt.priority_lvl IS DISTINCT FROM scr.priority_lvl;

-- -- INSERT statement
-- INSERT INTO main.priority_jobs_snapshot(
--     job_id,             
--   job_title_short,    
--   company_name,       
--   job_posted_date,    
--   salary_year_avg,    
--   priority_lvl,       
--   updated_at  
-- )
-- SELECT
--     scr.job_id,
--     scr.job_title_short,
--     scr.company_name,
--     scr.job_posted_date,
--     scr.salary_year_avg,
--     scr.priority_lvl,
--     scr.updated_at
-- FROM scr_priority_jobs AS scr
-- WHERE NOT EXISTS (
--   SELECT 1
--   FROM main.priority_jobs_snapshot AS tgt
--   WHERE tgt.job_id = scr.job_id
-- );

-- -- DELETE statement
-- DELETE FROM main.priority_jobs_snapshot AS tgt
-- WHERE NOT EXISTS (
--    SELECT 1
--    FROM scr_priority_jobs AS scr
--    WHERE scr.job_id = tgt.job_id
--);

 -- MERGE INTO
MERGE INTO main.priority_jobs_snapshot AS tgt
USING scr_priority_jobs AS scr
ON tgt.job_id = scr.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM scr.priority_lvl THEN
UPDATE SET
    priority_lvl = scr.priority_lvl,
    updated_at = scr.updated_at
    
WHEN NOT MATCHED THEN
  INSERT (
      job_id,             
    job_title_short,    
    company_name,       
    job_posted_date,    
    salary_year_avg,    
    priority_lvl,       
    updated_at  
  )
  VALUES (
      scr.job_id,
      scr.job_title_short,
      scr.company_name,
      scr.job_posted_date,
      scr.salary_year_avg,

  WHEN NOT MATCHED BY SOURCE THEN DELETE;
 
-- Final Check Query
SELECT
   job_title_short,
   COUNT(*) AS job_count,
   MIN(priority_lvl) AS priority_lvl,
   MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;
