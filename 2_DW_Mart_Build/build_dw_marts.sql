--duckdb dw_mart.duckdb -c ".read build_dw_marts.sql"

-- step 1: DW - Create star schema tables
.read 2_DW_Mart_Build/01_create_tables_dw.sql

-- Step 2: DW - load data from csv files into tables
.read 2_DW_Mart_Build/02_load_schema_dw.sql