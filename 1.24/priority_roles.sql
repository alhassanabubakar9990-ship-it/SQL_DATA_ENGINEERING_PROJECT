CREATE OR REPLACE TABLE staging.priority_roles (
  role_id       INTEGER PRIMARY KEY,
  role_name     VARCHAR,
  priority_lvl  INTEGER
);


INSERT INTO staging.priority_roles (role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Analyst', 2),
    (2, 'Data Scientist', 1),
    (3, 'Data Engineer', 3);

  SELECT * FROM staging.priority_roles;