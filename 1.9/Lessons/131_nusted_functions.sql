
-- =========================================
-- ARRAY INTRO
-- =========================================

SELECT ['python', 'sql', 'r'] AS skill_array;

WITH skill AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
),
skill_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skill
)
SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skill_array;


-- =========================================
-- STRUCT
-- =========================================

SELECT STRUCT_PACK(
    skills := 'python',
    types := 'programming'
) AS skill_struct;

WITH skill_struct AS (
    SELECT STRUCT_PACK(
        skill := 'python',
        types := 'programming'
    ) AS s
)
SELECT
    s.skill,
    s.types
FROM skill_struct;


-- =========================================
-- ARRAY OF STRUCTS
-- =========================================

SELECT [
    {'skills': 'python', 'types': 'programming'},
    {'skills': 'sql', 'types': 'query_language'}
] AS skills_array_of_structs;

WITH skill_table AS (
    SELECT 'python' AS skill, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
),
skills_array_of_structs AS (
    SELECT ARRAY_AGG(
        STRUCT_PACK(
            skill := skill,
            types := types
        )
        ORDER BY skill
    ) AS arr
    FROM skill_table
)
SELECT
    arr[1].skill AS first_skill,
    arr[2].skill AS second_skill,
    arr[3].skill AS third_skill
FROM skills_array_of_structs;


-- =========================================
-- MAP
-- =========================================

WITH skill_map AS (
    SELECT MAP(
        ['skill', 'type'],
        ['python', 'programming']
    ) AS skill_type
)
SELECT
    skill_type['skill'] AS skill,
    skill_type['type'] AS type
FROM skill_map;


-- =========================================
-- JSON
-- =========================================

WITH raw_skill_json AS (
    SELECT
        '{"skill":"python","type":"programming"}'::JSON
        AS skill_json
)
SELECT STRUCT_PACK(
    skill := json_extract_string(skill_json, '$.skill'),
    type := json_extract_string(skill_json, '$.type')
) AS skill_struct
FROM raw_skill_json;


-- =========================================
-- JSON TO ARRAY OF STRUCTS
-- =========================================

WITH raw_json AS (
    SELECT
        '[
            {"skill":"python","type":"programming"},
            {"skill":"sql","type":"query_language"},
            {"skill":"r","type":"programming"}
        ]'::JSON AS skills_json
),
parsed_skills AS (
    SELECT
        json_extract_string(e.value, '$.skill') AS skill,
        json_extract_string(e.value, '$.type') AS type
    FROM raw_json,
         JSON_EACH(skills_json) AS e
)
SELECT ARRAY_AGG(
    STRUCT_PACK(
        skill := skill,
        type := type
    )
    ORDER BY skill
) AS skills
FROM parsed_skills;


-- =========================================
-- ARRAYS: FINAL EXAMPLE
-- =========================================

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills)
        FILTER (WHERE sd.skills IS NOT NULL) AS skills_array
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN data_jobs.skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;


-- MEDIAN SALARY PER SKILL

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
WHERE salary_year_avg IS NOT NULL
GROUP BY skill
ORDER BY median_salary DESC
LIMIT 50;


-- =========================================
-- ARRAY OF STRUCTS: FINAL EXAMPLE
-- =========================================

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) FILTER (WHERE sd.skills IS NOT NULL) AS skill_details
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN data_jobs.skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;


-- MEDIAN SALARY PER SKILL TYPE

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skill_details) AS skill
    FROM job_skills_array_struct
)
SELECT
    skill.skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
WHERE salary_year_avg IS NOT NULL
GROUP BY skill.skill_type
ORDER BY median_salary DESC
LIMIT 50;