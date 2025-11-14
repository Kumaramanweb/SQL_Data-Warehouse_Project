/*==============================================================
 BRONZE → SILVER LOAD SCRIPT : CRM PRODUCT INFO
 Author : Aman
 Purpose: Clean, standardize, transform product data before loading
==============================================================*/



/*==============================================================
 STEP 0: TRUNCATE SILVER LAYER TABLE
--------------------------------------------------------------*/
SELECT 'Truncating silver.crm_prd_info table...' AS info;
TRUNCATE TABLE silver.crm_prd_info;



/*==============================================================
 STEP 1: PRINT MESSAGE BEFORE LOADING
--------------------------------------------------------------*/
SELECT 'Starting data load into silver.crm_prd_info...' AS info;



/*==============================================================
 STEP 2: LOAD CLEAN + TRANSFORMED DATA INTO SILVER
--------------------------------------------------------------*/

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,

    /* Extract cat_id from prd_key (clean hidden characters) */
    REPLACE(
        SUBSTRING(
            REPLACE(REPLACE(REPLACE(TRIM(prd_key), '\r',''), '\n',''), '\t',''),
            1, 
            5
        ),
        '-', 
        '_'
    ) AS cat_id,

    /* Cleaned product key */
    SUBSTRING(
        REPLACE(REPLACE(REPLACE(TRIM(prd_key), '\r',''), '\n',''), '\t',''),
        7
    ) AS prd_key,

    /* Clean product name */
    REPLACE(REPLACE(REPLACE(TRIM(prd_nm), '\r',''), '\n',''), '\t','') AS prd_nm,

    /* Replace NULL cost with 0 */
    IFNULL(prd_cost, 0) AS prd_cost,

    /* Standardize product line */
    CASE 
        WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(prd_line), '\r',''), '\n',''), '\t','')) = 'M' THEN 'Mountain'
        WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(prd_line), '\r',''), '\n',''), '\t','')) = 'R' THEN 'Road'
        WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(prd_line), '\r',''), '\n',''), '\t','')) = 'S' THEN 'Other Sales'
        WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(prd_line), '\r',''), '\n',''), '\t','')) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,

    prd_start_dt,

    /* Calculate end date based on next start date */
    DATE_SUB(
        LEAD(prd_start_dt) OVER (
            PARTITION BY 
                REPLACE(REPLACE(REPLACE(TRIM(prd_key), '\r',''), '\n',''), '\t','') 
            ORDER BY prd_start_dt
        ),
        INTERVAL 1 DAY
    ) AS prd_end_dt

FROM bronze.crm_prd_info
WHERE prd_start_dt IS NOT NULL;



/*==============================================================
 STEP 3: PRINT MESSAGE AFTER LOADING
--------------------------------------------------------------*/
SELECT 'Data successfully loaded into silver.crm_prd_info!' AS info;





/*==============================================================
 OPTIONAL SECTION (COMMENTED OUT)
 DATA QUALITY CHECKS – RUN ONLY IF NEEDED
==============================================================*/

/*
--------------------------------------------------------------
DQ1 — Check duplicates in bronze
--------------------------------------------------------------
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


--------------------------------------------------------------
DQ2 — Check unwanted spaces in product names
--------------------------------------------------------------
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


--------------------------------------------------------------
DQ3 — Check negative or NULL cost values
--------------------------------------------------------------
SELECT prd_id, prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;


--------------------------------------------------------------
DQ4 — Check distinct product lines
--------------------------------------------------------------
SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info;


--------------------------------------------------------------
DQ5 — Check invalid date ranges
--------------------------------------------------------------
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt > prd_start_dt;


--------------------------------------------------------------
DQ6 — Check silver table load results
--------------------------------------------------------------
SELECT COUNT(*) FROM silver.crm_prd_info;
SELECT DISTINCT prd_line FROM silver.crm_prd_info;
SELECT * FROM silver.crm_prd_info WHERE prd_cost = 0;
*/
