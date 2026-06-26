# Stored Procedures Documentation

## Overview

This document describes all the stored procedures used in the Data Warehouse (DWH) layer to load dimensions and the fact table from staging data.

**Database:** `dwh_computer_sales`

---

## Dimension Loading Procedures

### usp_load_dwh_dim_locations
**Purpose:** Loads distinct location records into the `dim_locations` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_locations`

**Columns Populated:**
- `continent`
- `country_or_state`
- `province_or_city`

**Logic:** 
- Inserts only DISTINCT records where all three location fields are NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_locations];
```

---

### usp_load_dwh_dim_shop
**Purpose:** Loads distinct shop information into the `dim_shop` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_shop`

**Columns Populated:**
- `shop_name`
- `shop_age`

**Logic:** 
- Inserts only DISTINCT records where both shop fields are NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_shop];
```

---

### usp_load_dwh_dim_pc_product
**Purpose:** Loads distinct PC product specifications into the `dim_pc_product` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_pc_product`

**Columns Populated:**
- `pc_make`
- `pc_model`
- `storage_type`
- `ram`
- `storage_capacity`

**Logic:** 
- Inserts only DISTINCT records where all five product fields are NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_pc_product];
```

---

### usp_load_dwh_dim_sales_person
**Purpose:** Loads distinct sales personnel information into the `dim_sales_person` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_sales_person`

**Columns Populated:**
- `sales_person_name`
- `sales_person_department`

**Logic:** 
- Inserts only DISTINCT records where both sales person fields are NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_sales_person];
```

---

### usp_load_dwh_dim_payment_id
**Purpose:** Loads distinct payment methods into the `dim_payment_id` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_payment_id`

**Columns Populated:**
- `payment_method`

**Logic:** 
- Inserts only DISTINCT payment methods where NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_payment_id];
```

---

### usp_load_dwh_dim_priority_id
**Purpose:** Loads distinct priority levels into the `dim_priority_id` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_priority_id`

**Columns Populated:**
- `priority`

**Logic:** 
- Inserts only DISTINCT priority values where NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_priority_id];
```

---

### usp_load_dwh_dim_date
**Purpose:** Loads distinct dates from purchase and shipment dates into the `dim_date` dimension table with calendar attributes.

**Source:** `stg_computer_sales.dbo.raw_pc_data` (extracts from Purchase_Date and Ship_Date)

**Target:** `dbo.dim_date`

**Columns Populated:**
- `full_date` - The actual date
- `calendar_year` - Year component
- `calendar_month` - Month component
- `calendar_day` - Day component
- `day_name` - Day of week name (Monday, Tuesday, etc.)

**Logic:** 
- Unions Purchase_Date and Ship_Date from raw data
- Uses TRY_CAST to handle date conversion errors safely
- Inserts only valid dates (NOT NULL)
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_date];
```

---

### usp_load_dwh_dim_channel
**Purpose:** Loads distinct sales channels into the `dim_channel` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_channel`

**Columns Populated:**
- `channel`

**Logic:** 
- Inserts only DISTINCT channel values where NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_channel];
```

---

### usp_load_dwh_dim_customer_details
**Purpose:** Loads distinct customer information into the `dim_customer_details` dimension table.

**Source:** `stg_computer_sales.dbo.raw_pc_data`

**Target:** `dbo.dim_customer_details`

**Columns Populated:**
- `customer_name`
- `customer_surname`
- `customer_contact_number`
- `customer_email_address`

**Logic:** 
- Inserts only DISTINCT records where all four customer fields are NOT NULL
- Prevents duplicates using NOT EXISTS check

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_dim_customer_details];
```

---

## Master Orchestration Procedure

### usp_load_all_dwh_dimensions
**Purpose:** Master procedure that orchestrates the loading of all dimension tables in the correct sequence.

**Executes (in order):**
1. `usp_load_dwh_dim_locations`
2. `usp_load_dwh_dim_shop`
3. `usp_load_dwh_dim_pc_product`
4. `usp_load_dwh_dim_sales_person`
5. `usp_load_dwh_dim_payment_id`
6. `usp_load_dwh_dim_priority_id`
7. `usp_load_dwh_dim_date`
8. `usp_load_dwh_dim_channel`
9. `usp_load_dwh_dim_customer_details`

**Execution:**
```sql
EXEC [dbo].[usp_load_all_dwh_dimensions];
```

---

## Fact Table Loading Procedure

### usp_load_dwh_pc_sales_fact
**Purpose:** Loads sales transactions into the `pc_sales_fact` fact table by joining cleaned dimensions with raw source data.

**Source:** `stg_computer_sales.dbo.raw_pc_data` (raw transactions)

**Target:** `dbo.pc_sales_fact`

**Dimensions Joined:**
- `dim_customer_details` - Customer information
- `dim_locations` - Geographic information
- `dim_pc_product` - Product specifications
- `dim_channel` - Sales channel
- `dim_payment_id` - Payment method
- `dim_sales_person` - Sales representative
- `dim_date` - Transaction date
- `dim_shop` - Shop information
- `dim_priority_id` - Sales priority

**Columns Populated:**
- `customer_id` - FK to dim_customer_details
- `location_id` - FK to dim_locations
- `pc_product_id` - FK to dim_pc_product
- `channel_id` - FK to dim_channel
- `payment_id` - FK to dim_payment_id
- `sales_person_id` - FK to dim_sales_person
- `date_id` - FK to dim_date
- `shop_id` - FK to dim_shop
- `priority_id` - FK to dim_priority_id
- `cost_price` - DECIMAL(18,2)
- `sale_price` - DECIMAL(18,2)
- `discount_amount` - DECIMAL(18,2)
- `finance_amount` - DECIMAL(18,2)
- `credit_score` - INT
- `total_sales_per_employee` - DECIMAL(18,2)
- `pc_market_price` - DECIMAL(18,2)

**Logic:** 
- Uses INNER JOINs to ensure all dimension lookups are successful
- Uses TRY_CAST to safely convert numeric fields
- Prevents duplicates using NOT EXISTS check that compares all dimension IDs and measures

**Important Note:** This procedure must be executed **AFTER** all dimension procedures have been executed. Ensure `usp_load_all_dwh_dimensions` is run first.

**Execution:**
```sql
EXEC [dbo].[usp_load_dwh_pc_sales_fact];
```

---

## Execution Sequence

**Recommended execution order:**

```sql
-- Step 1: Load all dimensions
EXEC [dbo].[usp_load_all_dwh_dimensions];

-- Step 2: Load fact table (depends on dimensions being populated)
EXEC [dbo].[usp_load_dwh_pc_sales_fact];
```

**Or, to load individual dimensions followed by fact table:**

```sql
EXEC [dbo].[usp_load_dwh_dim_locations];
EXEC [dbo].[usp_load_dwh_dim_shop];
EXEC [dbo].[usp_load_dwh_dim_pc_product];
EXEC [dbo].[usp_load_dwh_dim_sales_person];
EXEC [dbo].[usp_load_dwh_dim_payment_id];
EXEC [dbo].[usp_load_dwh_dim_priority_id];
EXEC [dbo].[usp_load_dwh_dim_date];
EXEC [dbo].[usp_load_dwh_dim_channel];
EXEC [dbo].[usp_load_dwh_dim_customer_details];
EXEC [dbo].[usp_load_dwh_pc_sales_fact];
```

---

## Error Handling & Validation

All procedures use `SET NOCOUNT ON` to suppress row counts during execution, improving performance.

**To validate data loaded:**

```sql
-- Check dimension record counts
SELECT COUNT(*) as LocationCount FROM [dbo].[dim_locations];
SELECT COUNT(*) as ShopCount FROM [dbo].[dim_shop];
SELECT COUNT(*) as ProductCount FROM [dbo].[dim_pc_product];
SELECT COUNT(*) as SalesPersonCount FROM [dbo].[dim_sales_person];
SELECT COUNT(*) as PaymentCount FROM [dbo].[dim_payment_id];
SELECT COUNT(*) as PriorityCount FROM [dbo].[dim_priority_id];
SELECT COUNT(*) as DateCount FROM [dbo].[dim_date];
SELECT COUNT(*) as ChannelCount FROM [dbo].[dim_channel];
SELECT COUNT(*) as CustomerCount FROM [dbo].[dim_customer_details];

-- Check fact table record count
SELECT COUNT(*) as FactCount FROM [dbo].[pc_sales_fact];
```

---

## Notes

- All procedures are idempotent - they can be executed multiple times without creating duplicates
- The NOT EXISTS logic ensures data consistency across multiple runs
- Use TRY_CAST for safe data type conversions
- Dimensions must be fully loaded before executing the fact table procedure
- For troubleshooting, check the raw source data in `stg_computer_sales.dbo.raw_pc_data`
