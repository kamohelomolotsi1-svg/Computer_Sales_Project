# Computer Sales Project

## Overview

This project implements a SQL Server data pipeline for a computer sales dataset. It includes:
- staging database setup
- raw staging table creation
- staging dimension table creation
- data loading into staging tables
- cleaning and transforming dimensions
- final fact and dimension tables for a data warehouse
- SSIS Integration Services packages for automation and ETL execution

## Project Structure

### 0.1 create_computer_stg_db
Contains the SQL script(s) to create the staging database `stg_computer_sales`.

### 0.2 raw_stg_table
Contains the script to create the raw staging table `raw_pc_data` in the staging database.

### 0.3 stg_dim_tables
Contains scripts to create staging dimension tables such as:
- `stg_dim_locations`
- `stg_dim_shop`
- `stg_dim_pc_product`
- `stg_dim_sales_person`
- `stg_dim_payment_id`
- `stg_dim_priority_id`
- `stg_dim_date`
- `stg_dim_channel`
- `stg_dim_customer_details`

Also includes the staging fact table script `stg_pc_sales_fact.sql`.

### 0.4 load_stg_tables
Contains scripts to load data from the raw staging table into each staging dimension table.
These scripts typically perform the first pass of data transformation and deduplication.

### 0.5 clean_dim_tables
Contains scripts to clean and load the final clean dimension tables in the `clean_computer_sales` database.
For example, `0.5.1 clean_dim_locations.sql`:
- creates `clean_computer_sales` if needed
- creates `dim_locations` if missing
- truncates the target table
- loads distinct non-null location rows from `raw_pc_data`
- prevents duplicate inserts using `NOT EXISTS`

### 0.5 clean_dim_fact_table
Contains the SQL for cleaning and loading the final fact table data.

### 0.6 dwh_dim_fact_table
Contains scripts for the final data warehouse dimension and fact model.

## SSIS Integration Services

This solution also includes two SSIS Integration Services projects:

### Integration Services Project1
- `0.1 CreateTables.dtsx` — automates creation of necessary database tables.
- `0.2 LoadData.dtsx` — automates data loading into the staging and/or clean tables.
- Includes Visual Studio project files for SSIS package deployment.

### Integration Services Project2
- `0.1. CreateTables.dtsx`
- `0.2. Create_stg_Shop.dtsx`
- `0.3. Create_stg_pc_product.dtsx`
- `0.4. Create_stg_sales_person.dtsx`
- `0.5. Create_stg_Payment.dtsx`
- `0.6. Create_stg_Priority.dtsx`
- `0.7. Create_stg_Dim_Date.dtsx`
- `0.8 Create_stg_Dim_Channel.dtsx`
- `0.9. Create_stg_Dim_Customer.dtsx`

These packages support the SSIS-driven creation and loading of the staging dimension tables.

## What Was Done

- Designed a staging database architecture for computer sales data.
- Created raw staging tables and multiple staging dimension tables.
- Built SQL scripts to transform and clean dimensions.
- Created a clean database to store final dimension data.
- Added data quality checks by filtering out null values and preventing duplicates.
- Included SSIS packages to orchestrate table creation and data loading.

## How to Use

1. Open the SQL scripts in SQL Server Management Studio (SSMS).
2. Run the scripts in order:
   - `0.1 create_computer_stg_db/create_stg_database.sql`
   - `0.2 raw_stg_table/raw_stg_table.sql`
   - staging dimension creation in `0.3 stg_dim_tables/`
   - staging load scripts in `0.4 load_stg_tables/`
   - clean dimension load scripts in `0.5 clean_dim_tables/`
   - final fact/dimension scripts in `0.6 dwh_dim_fact_table/`
3. Open the SSIS projects in Visual Studio (SSDT) to run or deploy the packages.

## Notes

- The SQL code uses `stg_computer_sales` for staging and `clean_computer_sales` for the cleaned dimension model.
- SSIS project files are included for automation and package-based ETL orchestration.
- Exclude IDE-specific build artifacts before committing or publishing.

