-- step 1: DW - Create star schema tables

DROP TABLE IF EXISTS skills_job_dim;
DROP TABLE IF EXISTS job_postings_fact;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS skills_dim;

CREATE TABLE company_dim (
    company_id INTEGER PRIMARY KEY,
    name VARCHAR
);

CREATE TABLE skills_dim (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

CREATE TABLE job_postings_fact (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    job_title_short VARCHAR,
    job_title VARCHAR,
    job_location VARCHAR,
    job_via VARCHAR,
    job_schedule_type VARCHAR,
    job_work_from_home BOOLEAN,
    search_location VARCHAR,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_country  VARCHAR,
    job_health_insurance BOOLEAN,
    salary_rate          VARCHAR,
    salary_year_avg      DOUBLE,
    salary_hour_avg      DOUBLE
);

CREATE TABLE skills_job_dim(
  skill_id   INTEGER,
  job_id     INTEGER,
  PRIMARY KEY (skill_id, job_id),
  FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id),
  FOREIGN KEY (job_id) REFERENCES job_postings_fact(job_id)
);
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'main';


