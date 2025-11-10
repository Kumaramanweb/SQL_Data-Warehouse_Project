/*
=============================================================
Load Data into Bronze Layer Tables (MySQL Version)
=============================================================
Script Purpose:
    This script loads raw data from CSV files (source CRM and ERP systems)
    into the "bronze" layer tables of the DataWarehouse project.

    Each section explains:
        • What table we’re loading into
        • What data source file is used
        • What type of data the file contains

NOTE:
    - Make sure the CSV file paths are correct for your system.
    - Ensure 'local_infile' is enabled (to allow loading from local files).
    - If the file paths contain backslashes (\), use forward slashes (/) or double backslashes (\\).
=============================================================
*/

-------------------------------------------------------------
-- STEP 1: Enable LOCAL INFILE (Required for file loading)
-------------------------------------------------------------
SHOW VARIABLES LIKE 'local_infile';  -- Check current status
SET GLOBAL local_infile = 1;         -- Enable it if disabled

-------------------------------------------------------------
-- STEP 2: Load CRM Customer Information
-- File: cust_info.csv
-- Purpose: Contains customer demographic and profile data.
-- Target Table: bronze.crm_cust_info
-------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sql-data-warehouse-project-main/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date);

-- Preview first 10 rows
SELECT * FROM bronze.crm_cust_info LIMIT 10;


-------------------------------------------------------------
-- STEP 3: Load CRM Product Information
-- File: prd_info.csv
-- Purpose: Contains product details like cost, category, and time validity.
-- Target Table: bronze.crm_prd_info
-------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sql-data-warehouse-project-main/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt);

-- Preview first 10 rows
SELECT * FROM bronze.crm_prd_info LIMIT 10;


-------------------------------------------------------------
-- STEP 4: Load CRM Sales Details
-- File: sales_details.csv
-- Purpose: Holds transactional sales data including 
-- order number, product key, customer, sales value, and quantity.
-- Target Table: bronze.crm_sales_details
-------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sql-data-warehouse-project-main/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price);

-- Preview first 10 rows
SELECT * FROM bronze.crm_sales_details LIMIT 10;


-------------------------------------------------------------
-- STEP 5: Load ERP Customer Data
-- File: CUST_AZ12.csv
-- Purpose: Contains ERP system customer records such as 
-- customer ID, birth date, and gender.
-- Target Table: bronze.erp_cust_az12
-------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sql-data-warehouse-project-main/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cid, bdate, gen);

-- Preview first 10 rows
SELECT * FROM bronze.erp_cust_az12 LIMIT 10;


-------------------------------------------------------------
-- STEP 6: Load ERP Location Data
-- File: LOC_A101.csv
-- Purpose: Contains mapping of customer IDs to their countries.
-- Target Table: bronze.erp_loc_a101
-------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sql-data-warehouse-project-main/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cid, cntry);

-- Preview first 10 rows
SELECT * FROM bronze.erp_loc_a101 LIMIT 10;


-------------------------------------------------------------
-- STEP 7: Load ERP Product Category Data
-- File: PX_CAT_G1V2.csv
-- Purpose: Stores product categories, subcategories, 
-- and maintenance details.
-- Target Table: bronze.erp_px_cat_g1v2
-------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/sql-data-warehouse-project-main/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, cat, subcat, maintenance);

-- Preview first 10 rows
SELECT * FROM bronze.erp_px_cat_g1v2 LIMIT 10;
