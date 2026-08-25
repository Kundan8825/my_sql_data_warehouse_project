-- ============================================================
-- Bronze Layer Data Loading Script
-- ============================================================
-- Purpose:
--   Load raw data from CSV files into Bronze layer tables.
--
-- Important:
--   LOAD DATA LOCAL INFILE cannot be executed inside a
--   MySQL stored procedure.
--
-- Author: Kundan Raj
-- ============================================================


-- ============================================================
-- CRM: Customer Information
-- ============================================================

TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA LOCAL INFILE '/Users/kundanraj/Downloads/sql-data-warehouse-project-main/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- CRM: Product Information
-- ============================================================

TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA LOCAL INFILE '/Users/kundanraj/Downloads/sql-data-warehouse-project-main/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- CRM: Sales Details
-- ============================================================

TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA LOCAL INFILE '/Users/kundanraj/Downloads/sql-data-warehouse-project-main/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- ERP: Customer Information
-- ============================================================

TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA LOCAL INFILE '/Users/kundanraj/Downloads/sql-data-warehouse-project-main/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- ERP: Location
-- ============================================================

TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA LOCAL INFILE '/Users/kundanraj/Downloads/sql-data-warehouse-project-main/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- ERP: Product Category
-- ============================================================

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE '/Users/kundanraj/Downloads/sql-data-warehouse-project-main/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- ============================================================
-- Validation
-- ============================================================

SELECT 'Bronze Layer Loading Completed' AS message;

SELECT 'crm_cust_info' AS table_name, COUNT(*) AS row_count
FROM bronze.crm_cust_info

UNION ALL

SELECT 'crm_prd_info', COUNT(*)
FROM bronze.crm_prd_info

UNION ALL

SELECT 'crm_sales_details', COUNT(*)
FROM bronze.crm_sales_details

UNION ALL

SELECT 'erp_cust_az12', COUNT(*)
FROM bronze.erp_cust_az12

UNION ALL

SELECT 'erp_loc_a101', COUNT(*)
FROM bronze.erp_loc_a101

UNION ALL

SELECT 'erp_px_cat_g1v2', COUNT(*)
FROM bronze.erp_px_cat_g1v2;
