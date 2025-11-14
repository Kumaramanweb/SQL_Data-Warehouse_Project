/*==============================================================
 BRONZE → SILVER LOAD SCRIPT : ERP CUSTOMER AZ12
 Author : Aman
 Purpose: Clean, validate, standardize data before loading
==============================================================*/


/*==============================================================
 STEP 0: TRUNCATE SILVER LAYER TABLE
--------------------------------------------------------------*/
SELECT 'Truncating silver.erp_cust_az12 table...' AS info;
TRUNCATE TABLE silver.erp_cust_az12;



/*==============================================================
 STEP 1: PRINT MESSAGE BEFORE LOADING
--------------------------------------------------------------*/
SELECT 'Starting data load into silver.erp_cust_az12...' AS info;



/*==============================================================
 STEP 2: LOAD CLEAN + STANDARDIZED DATA INTO SILVER
--------------------------------------------------------------*/

INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT 
    
    /* Clean Customer ID */
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS cid,

    /* Clean & Validate Birthdate */
    CASE 
        WHEN bdate > NOW()        THEN NULL
        WHEN bdate < '1924-01-01' THEN NULL
        ELSE bdate
    END AS bdate,

    /* Clean hidden characters + Standardize Gender */
    CASE 
        WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(gen, '\r', ''), '\n', ''), '\t', '')))
                IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(gen, '\r', ''), '\n', ''), '\t', '')))
                IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen

FROM bronze.erp_cust_az12;



/*==============================================================
 STEP 3: PRINT MESSAGE AFTER LOADING
--------------------------------------------------------------*/
SELECT 'Data successfully loaded into silver.erp_cust_az12!' AS info;




/*==============================================================
 OPTIONAL SECTION (COMMENTED OUT)
 DATA QUALITY CHECKS – RUN ONLY IF NEEDED
 This section will NOT execute unless manually uncommented
==============================================================*/

/*
--------------------------------------------------------------
DQ1 — Check invalid or future birthdates in bronze
--------------------------------------------------------------
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > NOW();

--------------------------------------------------------------
DQ2 — Check gender variations in bronze
--------------------------------------------------------------
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

--------------------------------------------------------------
DQ3 — Birthdate issues after loading to silver
--------------------------------------------------------------
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > NOW();

--------------------------------------------------------------
DQ4 — Gender values after standardization
--------------------------------------------------------------
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

--------------------------------------------------------------
DQ5 — Full Data Preview
--------------------------------------------------------------
SELECT * FROM silver.erp_cust_az12;
*/
