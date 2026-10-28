--.read '1.9\Lessons\1.21_DDL_DML_Pt1.sql'

USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart;

CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

SELECT *
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;

--DROP SCHEMA IF  EXISTS staging
 
CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT * 
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Analyst'),
    (2, 'Data Scientist'),
    (3, 'Data Architect');

    SELECT *
    FROM staging.preferred_roles;

    ALTER TABLE staging.preferred_roles
    ADD COLUMN preferred_roles BOOLEAN;

    UPDATE staging.preferred_roles
    SET preferred_roles = FALSE
    WHERE role_id = 3;

    UPDATE staging.preferred_roles
    SET preferred_roles = FALSE
    WHERE role_id =3;

    ALTER TABLE staging.preferred_roles
    RENAME TO priority_roles;

    SELECT *
    FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_roles TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;