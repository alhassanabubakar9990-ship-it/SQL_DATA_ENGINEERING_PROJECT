--duckdb dw_mart.duckdb -c ".read 2_DW_Mart_Build/build_dw_marts.sql"

-- step 1: DW - Create star schema tables
.read 2_DW_Mart_Build/01_create_tables_dw.sql

-- Step 2: DW - load data from csv files into tables
.read 2_DW_Mart_Build/02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart (denormalized table)
.read 2_DW_Mart_Build/03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read 2_DW_Mart_Build/04_create_skills_mart.sql

-- Step 5: Mart - Create priority mart
.read 2_DW_Mart_Build/05_create_priority_mart.sql

-- Step 6: Mart - Update priority mart
.read 2_DW_Mart_Build/06_update_priority_mart.sql

-- Step 7: Mart - Create company prospecting mart
--.read 2_DW_Mart_Build/07_create_company_mart.sql
