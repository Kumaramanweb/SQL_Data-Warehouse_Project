/*==============================================================
 BRONZE → SILVER LOAD SCRIPT : CRM CUSTOMER INFO
 Author : Aman
 Purpose: Clean, deduplicate, standardize data before loading
==============================================================*/


/*==============================================================
 STEP 0: TRUNCATE SILVER LAYER TABLE
--------------------------------------------------------------*/
SELECT 'Truncating silver.crm_cust_info table...' AS info;
TRUNCATE TABLE silver.crm_cust_info;



/*==============================================================
 STEP 1: PRINT MESSAGE BEFORE LOADING
--------------------------------------------------------------*/
SELECT 'Starting data load into silver.crm_cust_info...' AS info;



/*==============================================================
 STEP 2: LOAD CLEAN + DEDUPED DATA INTO SILVER
--------------------------------------------------------------*/

INSERT INTO silver.crm_cust_info (
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date
)
SELECT 
  cst_id,
  cst_key,
  TRIM(cst_firstname) AS cst_firstname,
  TRIM(cst_lastname) AS cst_lastname,

  /* Standardize marital status */
  CASE 
    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'n/a'
  END AS cst_marital_status,

  /* Standardize gender */
  CASE 
    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    ELSE 'n/a'
  END AS cst_gndr,

  cst_create_date

FROM (
      SELECT *,
             ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rnk
      FROM bronze.crm_cust_info
      WHERE cst_id IS NOT NULL
        AND cst_create_date IS NOT NULL
) t
WHERE rnk = 1;



/*==============================================================
 STEP 3: PRINT MESSAGE AFTER LOADING
--------------------------------------------------------------*/
SELECT 'Data successfully loaded into silver.crm_cust_info!' AS info;






/*==============================================================
 OPTIONAL SECTION (COMMENTED OUT)
 DATA QUALITY CHECKS – RUN ONLY IF NEEDED
 This section will NOT execute unless the user manually uncomments.
==============================================================*/

/*
--------------------------------------------------------------
DQ1 — Check duplicates in bronze
--------------------------------------------------------------
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--------------------------------------------------------------
DQ2 — Check duplicate removal in silver
--------------------------------------------------------------
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

--------------------------------------------------------------
DQ3 — Check trimming issues
--------------------------------------------------------------
SELECT cst_firstname FROM silver.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname);
SELECT cst_lastname  FROM silver.crm_cust_info WHERE cst_lastname  != TRIM(cst_lastname);
SELECT cst_marital_status FROM silver.crm_cust_info WHERE cst_marital_status != TRIM(cst_marital_status);
SELECT cst_gndr FROM silver.crm_cust_info WHERE cst_gndr != TRIM(cst_gndr);

--------------------------------------------------------------
DQ4 — Check standardization results
--------------------------------------------------------------
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;

--------------------------------------------------------------
DQ5 — Check null or wrong dates
--------------------------------------------------------------
SELECT * FROM silver.crm_cust_info WHERE cst_create_date IS NULL;
*/

