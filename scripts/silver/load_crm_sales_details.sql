/*==============================================================
 BRONZE → SILVER LOAD SCRIPT : CRM SALES DETAILS
 Author : Aman
 Purpose: Clean, validate, standardize sales data before loading
==============================================================*/



/*==============================================================
 STEP 0: TRUNCATE SILVER LAYER TABLE
--------------------------------------------------------------*/
SELECT 'Truncating silver.crm_sales_details table...' AS info;
TRUNCATE TABLE silver.crm_sales_details;



/*==============================================================
 STEP 1: PRINT MESSAGE BEFORE LOADING
--------------------------------------------------------------*/
SELECT 'Starting data load into silver.crm_sales_details...' AS info;



/*==============================================================
 STEP 2: LOAD CLEAN + TRANSFORMED DATA INTO SILVER
--------------------------------------------------------------*/

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    b.sls_ord_num,
    b.sls_prd_key,
    b.sls_cust_id,

    /* Clean order date */
    CASE 
        WHEN b.sls_order_dt <= 0 
          OR LENGTH(b.sls_order_dt) != 8 
          OR b.sls_order_dt > 20500101 
          OR b.sls_order_dt < 19000101
        THEN NULL
        ELSE STR_TO_DATE(b.sls_order_dt, '%Y%m%d')
    END AS sls_order_dt,

    /* Clean ship date */
    CASE 
        WHEN b.sls_ship_dt <= 0 
          OR LENGTH(b.sls_ship_dt) != 8 
          OR b.sls_ship_dt > 20500101 
          OR b.sls_ship_dt < 19000101
        THEN NULL
        ELSE STR_TO_DATE(b.sls_ship_dt, '%Y%m%d')
    END AS sls_ship_dt,

    /* Clean due date */
    CASE 
        WHEN b.sls_due_dt <= 0 
          OR LENGTH(b.sls_due_dt) != 8 
          OR b.sls_due_dt > 20500101 
          OR b.sls_due_dt < 19000101
        THEN NULL
        ELSE STR_TO_DATE(b.sls_due_dt, '%Y%m%d')
    END AS sls_due_dt,

    /* FINAL SALES VALUE */
    CASE
        WHEN b.raw_sales IS NOT NULL
             AND b.raw_sales > 0
             AND b.raw_sales = b.sls_quantity * ABS(b.clean_price)
        THEN b.raw_sales

        WHEN b.raw_sales IS NOT NULL
             AND b.raw_sales > 0
             AND (b.clean_price IS NULL OR b.clean_price <= 0)
        THEN b.raw_sales

        WHEN b.sls_quantity > 0 
             AND b.clean_price IS NOT NULL
        THEN b.sls_quantity * ABS(b.clean_price)

        ELSE NULL
    END AS sls_sales,

    /* Quantity stays same */
    b.sls_quantity,

    /* FINAL PRICE VALUE */
    CASE
        WHEN b.clean_price IS NOT NULL AND b.clean_price > 0 THEN b.clean_price
        WHEN b.raw_sales IS NOT NULL AND b.raw_sales > 0 AND b.sls_quantity > 0 
            THEN b.raw_sales / NULLIF(b.sls_quantity, 0)
        ELSE NULL
    END AS sls_price

FROM (

    /*==========================================================
       INNER LAYER: compute clean_price & keep raw sales
    ==========================================================*/
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales AS raw_sales,
        sls_quantity,
        sls_price,

        /* Clean price logic */
        CASE
          WHEN sls_price IS NOT NULL AND sls_price > 0 THEN sls_price
          WHEN sls_sales IS NOT NULL AND sls_sales > 0 AND sls_quantity > 0
                THEN (sls_sales / NULLIF(sls_quantity, 0))
          ELSE NULL
        END AS clean_price

    FROM bronze.crm_sales_details

) b;



/*==============================================================
 STEP 3: PRINT MESSAGE AFTER LOADING
--------------------------------------------------------------*/
SELECT 'Data successfully loaded into silver.crm_sales_details!' AS info;





/*==============================================================
 OPTIONAL SECTION (COMMENTED OUT)
 DATA QUALITY CHECKS – RUN ONLY IF NEEDED
==============================================================*/

 /*
--------------------------------------------------------------
DQ1 — Invalid date formats in bronze
--------------------------------------------------------------
SELECT 
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LENGTH(sls_order_dt) != 8
   OR sls_ship_dt <= 0 OR LENGTH(sls_ship_dt) != 8
   OR sls_due_dt <= 0 OR LENGTH(sls_due_dt) != 8;


--------------------------------------------------------------
DQ2 — Wrong chronological order (Bronze)
--------------------------------------------------------------
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_ship_dt > sls_due_dt
   OR sls_order_dt > sls_due_dt;


--------------------------------------------------------------
DQ3 — Sales consistency issues (Bronze)
--------------------------------------------------------------
SELECT *
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL;


--------------------------------------------------------------
DQ4 — Chronological validation in Silver
--------------------------------------------------------------
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_ship_dt > sls_due_dt
   OR sls_order_dt > sls_due_dt;


--------------------------------------------------------------
DQ5 — Cleaned Sales-Price Validation (Silver)
--------------------------------------------------------------
SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL;


--------------------------------------------------------------
DQ6 — Compare bronze item with silver item
--------------------------------------------------------------
SELECT * FROM silver.crm_sales_details;
SELECT * FROM bronze.crm_sales_details;
 */
