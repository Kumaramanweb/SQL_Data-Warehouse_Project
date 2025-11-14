/*==============================================================
 BRONZE → SILVER LOAD SCRIPT : ERP_PX_CAT_G1V2
 Author : Aman
 Purpose: Clean & standardize category, subcategory and maintenance
==============================================================*/


/*==============================================================
 STEP 0: TRUNCATE SILVER TABLE
--------------------------------------------------------------*/
SELECT 'Truncating silver.erp_px_cat_g1v2 table...' AS info;
TRUNCATE TABLE silver.erp_px_cat_g1v2;



/*==============================================================
 STEP 1: PRINT MESSAGE BEFORE LOADING
--------------------------------------------------------------*/
SELECT 'Starting data load into silver.erp_px_cat_g1v2...' AS info;



/*==============================================================
 STEP 2: LOAD CLEANED + STANDARDIZED DATA INTO SILVER
--------------------------------------------------------------*/

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT
    TRIM(id) AS id,
    TRIM(cat) AS cat,
    TRIM(subcat) AS subcat,

    /* Remove all whitespace characters (hidden chars too) */
    REGEXP_REPLACE(maintenance, '[[:space:]]', '') AS maintenance

FROM bronze.erp_px_cat_g1v2;



/*==============================================================
 STEP 3: PRINT MESSAGE AFTER LOADING
--------------------------------------------------------------*/
SELECT 'Data successfully loaded into silver.erp_px_cat_g1v2!' AS info;




/*==============================================================
 OPTIONAL SECTION (COMMENTED OUT)
 DATA QUALITY CHECKS – RUN ONLY IF NEEDED
==============================================================*/

/*
--------------------------------------------------------------
DQ1 — Check for unwanted spaces in bronze
--------------------------------------------------------------
SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR id != TRIM(id) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

--------------------------------------------------------------
DQ2 — Distinct category & subcategory values
--------------------------------------------------------------
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;

--------------------------------------------------------------
DQ3 — Check maintenance values after removing whitespace
--------------------------------------------------------------
SELECT DISTINCT 
    REGEXP_REPLACE(maintenance, '[[:space:]]', '') AS cleaned_maintenance
FROM bronze.erp_px_cat_g1v2;

--------------------------------------------------------------
DQ4 — See final silver data
--------------------------------------------------------------
SELECT * FROM silver.erp_px_cat_g1v2;
*/
