
# 📦 SQL Data Warehouse Project

### *End-to-End Data Warehouse using MySQL — Bronze → Silver → Gold Layers*

This project demonstrates a complete **SQL-based Data Warehouse pipeline** using a multi-layered architecture. It follows industry standards for data ingestion, cleaning, transformation, and analytics-ready modeling.

---

## 🏗️ Project Architecture

### **1️⃣ Bronze Layer (Raw Data Layer)**

* Stores **raw CSV files** exactly as received.
* No cleaning or transformations.
* Used as the *true source of truth*.

**Bronze Tables:**

* `crm_cust_info`
* `crm_prd_info`
* `crm_sales_details`
* `erp_loc_a101`
* `erp_cust_az12`
* `erp_px_cat_g1v2`

---

### **2️⃣ Silver Layer (Cleaned & Standardized Layer)**

* Applies full data cleaning and standardization.
* Handles:

  * Date cleaning
  * NULL handling
  * Type casting
  * Removal of hidden characters
  * Key normalization
  * Deduplication
* Joins between CRM & ERP depend on cleaned keys.

### **Silver Load Script Features:**

* **PRINT statements** before loading each table.
* **Separated Data Quality (DQ) section**.
* **DQ does NOT run automatically** — it runs only when the user enables it.

Example toggle:

```sql
SET @run_quality_checks = 0;  -- 1 = run checks, 0 = skip
```

---

### **3️⃣ Gold Layer (Business Layer)**

* Final analytics-ready layer containing facts and dimensions.
* Combines CRM + ERP sources to create a unified business model.

**Gold Example Tables:**

* `dim_customer`
* `dim_product`
* `dim_location`
* `fact_sales`

---

## 🧹 Data Cleaning & Quality Checks

### **Checks Included**

* Invalid dates
* Hidden characters (using LENGTH vs CHAR_LENGTH)
* Key mismatch (e.g., `prd_key` vs `id`)
* Missing mandatory records
* Duplicates in keys
* Orphan customer/product references

### **Quality Check Mode**

Data Quality checks will **not** run unless explicitly enabled via:

```sql
SET @run_quality_checks = 1;
```

This makes the ETL script **production-ready**.

---

## 🔄 ETL Workflow Summary

### **Step 1 — Ingest CSVs into Bronze**

Using:

```sql
LOAD DATA LOCAL INFILE ...
```

### **Step 2 — Clean & Load Silver**

* Date standardization
* Hidden character removal
* Consistent casing
* Key mapping fixes
* Logged steps with `SELECT 'Loading table...' AS status;`

### **Step 3 — Build Gold Layer**

* Dimensions built using DISTINCT cleaned data
* Fact table created using validated foreign keys
* No null key leakage from Silver to Gold

---

## 📊 Outputs

* Unified Customer–Product–Location dataset
* Correct product categories/subcategories
* Fully cleaned CRM → ERP key mappings
* Fact table ready for BI tools/dashboards

---

## 🧰 Tools Used

* **MySQL 8+**
* **MySQL Workbench / CLI**
* **CSV Ingestion**
* **SQL DDL + DML + ETL**
* **Data Quality Framework (custom built)**

---

## 🧑‍💻 What I Learned

While completing this project, I learned:

* Multi-layer Data Warehouse design
* Building ETL pipelines using SQL
* Handling messy real-world data
* Fixing hidden characters and corrupted keys
* Creating fact/dimension models
* Writing maintainable and modular SQL scripts
* Adding Data Quality checks like production systems

---

## 🙏 Credits / Inspiration

This project is inspired and learned from the YouTube channel:

### 🎥 **Data With Baraa**




