/*
=============================================================
Create Silver Layer Tables (MySQL Version)
=============================================================
Script Purpose:
    This script creates the "silver" layer tables of the Data Warehouse.
    These tables are designed to store cleaned and standardized data
    coming from the bronze layer.

Enhancements:
    - Added metadata column `dwh_create_date` to capture 
      the data load timestamp.
=============================================================
*/

CREATE DATABASE IF NOT EXISTS silver;
USE silver;

-------------------------------------------------------------
-- 1. CRM Customer Information (Cleaned)
-------------------------------------------------------------
DROP TABLE IF EXISTS silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP  -- Load timestamp
);

-------------------------------------------------------------
-- 2. CRM Product Information (Cleaned)
-------------------------------------------------------------
DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP  -- Load timestamp
);

-------------------------------------------------------------
-- 3. CRM Sales Details (Cleaned)
-------------------------------------------------------------
DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP  -- Load timestamp
);

-------------------------------------------------------------
-- 4. ERP Customer Data (Cleaned)
-------------------------------------------------------------
DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP  -- Load timestamp
);

-------------------------------------------------------------
-- 5. ERP Location Data (Cleaned)
-------------------------------------------------------------
DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP  -- Load timestamp
);

-------------------------------------------------------------
-- 6. ERP Product Category Data (Cleaned)
-------------------------------------------------------------
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP  -- Load timestamp
);
