-- ============================================================
-- GOLD LAYER - CREATE GOLD VIEWS
-- ============================================================
-- Purpose:
-- Create analytical Dimension and Fact Views from the Silver Layer.
--
-- The Gold Layer provides business-ready, cleaned, and integrated
-- data for reporting, analytics, dashboards, and decision-making.
-- ============================================================


-- ============================================================
-- DIMENSION: CUSTOMERS
-- ============================================================
-- Purpose:
-- Create a customer dimension by integrating customer information
-- from CRM, demographics, and location data.
--
-- Usage:
-- Used to analyze sales and customer-related metrics based on
-- customer attributes such as gender, country, marital status,
-- and birthdate.
-- ============================================================


-- Drop the existing customer dimension view if it already exists
DROP VIEW IF EXISTS gold.dim_customers;


-- Create the customer dimension view
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id, 
	ci.cst_key AS customer_number, 
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
    la.CNTRY AS country,
    
    CASE 
        WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr 
        -- CRM is the master source for gender information
		ELSE COALESCE(ca.GEN, 'N/A')
	END AS gender,
    
    ci.cst_marital_status AS marital_Status,
    ca.BDATE AS birthdate,
	ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci 

LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.CID

LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.CID;


-- ============================================================
-- DIMENSION: PRODUCTS
-- ============================================================
-- Purpose:
-- Create a product dimension by integrating product information
-- with product category and maintenance data.
--
-- Usage:
-- Used to analyze sales and business performance by product,
-- category, subcategory, product line, and maintenance type.
--
-- Only current product records are included by filtering out
-- historical product records.
-- ============================================================


-- Drop the existing product dimension view if it already exists
DROP VIEW IF EXISTS gold.dim_products;


-- Create the product dimension view
CREATE VIEW gold.dim_products AS

SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id, 
	pn.prd_key AS product_number, 
	pn.prd_nm AS product_name, 
	pn.cat_id AS category_id, 
	pc.CAT AS category, 
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE AS maintenance,
	pn.prd_cost AS product_cost, 
	pn.prd_line AS product_line,  
	pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn

LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.ID

WHERE prd_end_dt IS NULL; 
-- Filter out all historical product records


-- ============================================================
-- FACT: SALES
-- ============================================================
-- Purpose:
-- Create a sales fact view containing transactional sales data
-- linked to the customer and product dimensions.
--
-- Usage:
-- Used for sales analysis and reporting, including revenue,
-- quantity, pricing, customer performance, and product
-- performance analysis.
-- ============================================================


-- Drop the existing sales fact view if it already exists
DROP VIEW IF EXISTS gold.fact_sales;


-- Create the sales fact view
CREATE VIEW gold.fact_sales AS

SELECT
	sls_ord_num AS order_number, 
	pr.product_key AS product_key, 
	cu.customer_key AS customer_key, 
	sls_order_dt AS order_date, 
	sls_ship_dt AS ship_date, 
	sls_due_dt AS due_date, 
	sls_sales AS sales, 
	sls_quantity AS quantity, 
	sls_price AS price

FROM silver.crm_sales_details sd

LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number

LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;


-- ============================================================
-- GOLD LAYER VIEWS CREATED SUCCESSFULLY
-- ============================================================
-- Views Created:
-- 1. gold.dim_customers
-- 2. gold.dim_products
-- 3. gold.fact_sales
--
-- These views are ready to be used for reporting,
-- dashboards, and analytical queries.
-- ============================================================
