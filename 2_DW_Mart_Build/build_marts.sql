

-- step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - load data from csv files into tables
.read 02_load_schema_dw.sql
