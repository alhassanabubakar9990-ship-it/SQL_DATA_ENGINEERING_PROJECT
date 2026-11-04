-- step 4: Mart - create skills demand mart

DROP SCHEMA IF EXISTS skills_mart CASCADE;

CREATE SCHEMA skills_mart;

SELECT '=== Loading Skills Dim for Skills Mart  ===' AS info;
CREATE TABLE skills_mart.dim_skill (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

INSERT INTO skills_mart.dim_skill (
      skill_id, 
      skills,
       type
)
SELECT
    skill_id,
    skills,
    type
FROM skills_dim;

SELECT '=== Loading Date Dim for Skills Mart  ===' AS info;
CREATE TABLE skills_mart.dim_date_month (
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);

SELECT '=== Loading Skill Fact for Skills Mart  ===' AS info;
INSERT INTO skills_mart.dim_date_month (
    month_start_date,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date)::DATE AS month_start_date,
    EXTRACT(year FROM job_posted_date) AS year,
    EXTRACT(month FROM job_posted_date) AS month,
    EXTRACT(quarter FROM job_posted_date) AS quarter,
    'Q' || CAST(EXTRACT(quarter FROM job_posted_date) AS VARCHAR) AS quarter_name,
    CAST(EXTRACT(year FROM job_posted_date) AS VARCHAR) || '-Q' || 
    CAST(EXTRACT(quarter FROM job_posted_date) AS VARCHAR) AS year_quarter
FROM job_postings_fact
ORDER BY month_start_date;

CREATE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INTEGER,
    remote_postings_count INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_mention_count INTEGER,
    PRIMARY KEY (skill_id, month_start_date, job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skill(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_mention_count
)
WITH job_postings_prepared AS (
    SELECT
        sj.skill_id,
        DATE_TRUNC('month', jp.job_posted_date)::DATE AS month_start_date,
        jp.job_title_short,
        -- Convert boolean flags to numeric values (1 or 0)
        CASE WHEN jp.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
        CASE WHEN jp.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance,
        CASE WHEN jp.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mention
    FROM
        job_postings_fact jp
    INNER JOIN
        skills_job_dim sj
        ON jp.job_id = sj.job_id
)
SELECT
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS postings_count,
    SUM(is_remote) AS remote_postings_count,
    SUM(has_health_insurance) AS health_insurance_postings_count,
    SUM(no_degree_mention) AS no_degree_mention_count
FROM job_postings_prepared
GROUP BY ALL
ORDER BY skill_id, month_start_date, job_title_short;

SELECT 'Skill Dimension' AS table_name, COUNT(*) as record_count FROM skills_mart.dim_skill
UNION ALL
SELECT 'Date Month Dimension', COUNT(*) FROM skills_mart.dim_date_month
UNION ALL
SELECT 'Skill Demand Fact', COUNT(*) FROM skills_mart.fact_skill_demand_monthly;

SELECT '=== Skill Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_skill LIMIT 10;

SELECT '=== Date Month Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_date_month ORDER BY month_start_date DESC LIMIT 10;

SELECT '=== Skill Demand Fact Sample ===' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 10;