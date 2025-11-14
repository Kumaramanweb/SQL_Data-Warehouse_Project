/*==============================================================
 BRONZE → SILVER LOAD SCRIPT : ERP LOCATION A101
 Author : Aman
 Purpose: Clean, standardize country codes and CID before loading
==============================================================*/


/*==============================================================
 STEP 0: TRUNCATE SILVER LAYER TABLE
--------------------------------------------------------------*/
SELECT 'Truncating silver.erp_loc_a101 table...' AS info;
TRUNCATE TABLE silver.erp_loc_a101;



/*==============================================================
 STEP 1: PRINT MESSAGE BEFORE LOADING
--------------------------------------------------------------*/
SELECT 'Starting data load into silver.erp_loc_a101...' AS info;



/*==============================================================
 STEP 2: LOAD CLEANED + STANDARDIZED DATA INTO SILVER
--------------------------------------------------------------*/

INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
SELECT 
    
    /* Clean CID (remove hyphens) */
    REPLACE(cid, '-', '') AS cid,

    /* Standardize country values (remove hidden chars + map codes) */
    CASE 
        WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ',''))) = 'DE'
            THEN 'Germany'

        WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ','')))
                IN ('US','USA')
            THEN 'United States'

        WHEN TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ','')) = '' 
             OR cntry IS NULL
            THEN 'n/a'

        ELSE TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ',''))
    END AS cntry

FROM bronze.erp_loc_a101;



/*==============================================================
 STEP 3: PRINT MESSAGE AFTER LOADING
--------------------------------------------------------------*/
SELECT 'Data successfully loaded into silver.erp_loc_a101!' AS info;




/*==============================================================
 OPTIONAL SECTION (COMMENTED OUT)
 DATA QUALITY CHECKS – RUN ONLY IF NEEDED
==============================================================*/

/*
--------------------------------------------------------------
DQ1 — Check distinct country values BEFORE cleaning (bronze)
-------------------------------------------------------------- */
SET @run_quality_checks = 0;


SELECT DISTINCT cntry AS old_cntry,
CASE 
    WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ',''))) = 'DE'
        THEN 'Germany'
    WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ','')))
            IN ('US','USA')
        THEN 'United States'
    WHEN TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ','')) = '' 
         OR cntry IS NULL
        THEN 'n/a'
    ELSE TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry,'\r',''),'\n',''),'\t',''),' ',''))
END AS new_cntry
FROM bronze.erp_loc_a101
WHERE @run_quality_checks = 1;

/*--------------------------------------------------------------
DQ2 — Check standardized country values in silver
--------------------------------------------------------------*/
SET @run_quality_checks = 0;

I
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
WHERE @run_quality_checks = 1;

/*--------------------------------------------------------------
DQ3 — Preview full silver data
--------------------------------------------------------------*/
SET @run_quality_checks = 0;


SELECT * FROM silver.erp_loc_a101
WHERE @run_quality_checks = 1;
*/
