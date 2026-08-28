/* ===============================================================================
Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
*/
-- ============================================================
-- CRM: Customer Information
-- ============================================================

-- Truncate existing customer data
TRUNCATE TABLE silver.crm_cust_info;

-- Insert transformed customer data
INSERT INTO silver.crm_cust_info(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)

SELECT cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname, -- Removing Unwanted spaces from firstname
TRIM(cst_lastname) AS cst_lastname, -- Removing Unwanted spaces from lastname
CASE
	WHEN UPPER(TRIM(cst_marital_status)) ='S' THEN 'Single'
    WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
    ElSE 'N/A'
END cst_marital_status, -- Normalize marital status values to readable format
CASE
	WHEN UPPER(TRIM(cst_gndr)) ='F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
    ElSE 'N/A'
END cst_gndr, -- Normalize gender values to readable format
cst_create_date
FROM(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS last_flag
 FROM bronze.crm_cust_info)t
 WHERE last_flag =1 AND cst_id != 0; -- Select the most recent record per customer


-- ============================================================
-- CRM: Product Information
-- ============================================================

-- Truncate existing product data
TRUNCATE TABLE silver.crm_prd_info;

-- Insert transformed product data
INSERT INTO silver.crm_prd_info(prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)

SELECT prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5),'-', '_') AS cat_id, -- Extract Category ID
SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, -- Extract Product Key
prd_nm, 
prd_cost, 
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'T' THEN 'Touring'
    ELSE 'N/A'
END AS prd_line, -- Map product line codes to descriptive values
prd_start_dt, 
DATE_SUB(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY) AS prd_end_dt -- Calculate end date as one day before the next start date
FROM bronze.crm_prd_info;


-- ============================================================
-- CRM: Sales Details
-- ============================================================

-- Truncate existing sales data
TRUNCATE TABLE silver.crm_sales_details;

-- Insert transformed sales data
INSERT INTO silver.crm_sales_details(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)

SELECT sls_ord_num, 
sls_prd_key, 
sls_cust_id, 
NULLIF(sls_order_dt, 0000-00-00) AS sls_order_dt, -- Fix the sales order date
NULLIF(sls_ship_dt, 0000-00-00) AS sls_ship_dt,  -- Fix the sales Ship date
NULLIF(sls_due_dt, 0000-00-00) AS sls_due_dt,  -- Fix the sales due date

CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)  -- Recalculate sales if original value is missing or incorrect
	ELSE sls_sales
END AS sls_sales,  
sls_quantity, 
CASE WHEN sls_price IS NULL OR sls_price  <=0  THEN sls_sales / NULLIF(sls_quantity,0) -- Derive price if original value is invalid
	ELSE sls_price
END AS sls_price 
FROM bronze.crm_sales_details;


-- ============================================================
-- ERP: Customer Demographics
-- ============================================================

-- Truncate existing customer demographic data
TRUNCATE TABLE silver.erp_cust_az12;

-- Insert transformed customer demographic data
INSERT INTO silver.erp_cust_az12(CID, BDATE, GEN)

SELECT
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))   -- Remove 'NAS' prefix if present
	 ELSE CID
END AS CID,   

CASE WHEN BDATE > CURDATE() THEN NULL  -- Set future birthdates to NULL
	ELSE BDATE
END AS BDATE,
CASE 
        WHEN UPPER(TRIM(REPLACE(GEN, '\r' ,''))) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(REPLACE(GEN, '\r', '')))  IN ('M', 'MALE') THEN 'Male'
        ELSE 'N/A'
    END AS GEN      -- Normalize gender values and handle unknown cases
FROM bronze.erp_cust_az12;


-- ============================================================
-- ERP: Customer Location
-- ============================================================

-- Truncate existing location data
TRUNCATE TABLE silver.erp_loc_a101;

-- Insert transformed location data
INSERT INTO silver.erp_loc_a101(CID, CNTRY)

SELECT
TRIM(REPLACE(CID, '-', '')) AS CID, 
CASE
    WHEN UPPER(TRIM(REPLACE(CNTRY,'\r', ''))) IN ('US', 'USA') THEN 'United States'
    WHEN UPPER(TRIM(REPLACE(CNTRY,'\r', ''))) = 'DE' THEN 'Germany'
    WHEN CNTRY IS NULL OR  TRIM(REPLACE(CNTRY,'\r', ''))='' THEN 'N/A'
    ELSE TRIM(REPLACE(CNTRY,'\r', ''))
END AS CNTRY -- Normalize and Handle missing or blank country codes
FROM bronze.erp_loc_a101;


-- ============================================================
-- ERP: Product Category Information
-- ============================================================

-- Truncate existing product category data
TRUNCATE TABLE silver.erp_px_cat_g1v2;

-- Insert transformed product category data
INSERT INTO silver.erp_px_cat_g1v2(ID, CAT, SUBCAT, MAINTENANCE)

SELECT ID, CAT, SUBCAT, MAINTENANCE 
FROM bronze.erp_px_cat_g1v2;


-- ============================================================
-- SILVER LAYER LOAD COMPLETED
-- ============================================================
