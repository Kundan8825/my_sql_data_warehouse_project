-- ============================================================
-- CREATE SILVER LAYER TABLES
-- ============================================================
-- Purpose:
-- This script creates all tables required for the Silver Layer.
-- The Silver Layer stores cleaned, standardized, and transformed
-- data from the Bronze Layer.
--
-- Source Systems:
-- 1. CRM System
-- 2. ERP System
--
-- ============================================================


-- ============================================================
-- CRM: Customer Information
-- ============================================================

DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(10),
    cst_gndr VARCHAR(10),
    cst_create_date DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- CRM: Product Information
-- ============================================================

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- CRM: Sales Details
-- ============================================================

DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales DECIMAL(10,2),
    sls_quantity INT,
    sls_price DECIMAL(10,2),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ERP: Customer Demographics
-- ============================================================

DROP TABLE IF EXISTS silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(10),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ERP: Customer Location
-- ============================================================

DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(100),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ERP: Product Category
-- ============================================================

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2 (
    ID VARCHAR(50),
    CAT VARCHAR(100),
    SUBCAT VARCHAR(100),
    MAINTENANCE VARCHAR(100),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- SILVER LAYER TABLE CREATION COMPLETED
-- ============================================================
