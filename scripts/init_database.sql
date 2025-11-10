/*
=============================================================
Create Database and Simulated Schemas (MySQL Version)
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. 

    Since MySQL does not support multiple schemas inside a single database 
    (unlike SQL Server), we simulate 'bronze', 'silver', and 'gold' schemas 
    by creating separate databases for each layer.

WARNING:
    Running this script will drop the entire 'DataWarehouse' and its layer databases 
    ('bronze', 'silver', 'gold') if they already exist. 
    All data in these databases will be permanently deleted. 
    Proceed with caution and ensure you have proper backups before running this script.
=============================================================
*/

-- Drop existing databases if they exist
DROP DATABASE IF EXISTS DataWarehouse;
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create new databases
CREATE DATABASE DataWarehouse;
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;

-- Use the main DataWarehouse database
USE DataWarehouse;

-- (Optional) You can create tables in each layer like:
-- USE bronze;
-- CREATE TABLE customer_data (...);
-- USE silver;
-- CREATE TABLE transformed_data (...);
-- USE gold;
-- CREATE TABLE analytics_summary (...);
