USE [stg_computer_sales];
GO

-- Direct insert statements for each staging dimension table.
-- Run this file when you want to populate the dim tables from raw_pc_data.

INSERT INTO [dbo].[dim_locations] (continent, country_or_state, province_or_city)
SELECT DISTINCT
    r.[Continent],
    r.[Country_or_State],
    r.[Province_or_City]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Continent] IS NOT NULL
  AND r.[Country_or_State] IS NOT NULL
  AND r.[Province_or_City] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_locations] AS d
      WHERE d.continent = r.[Continent]
        AND d.country_or_state = r.[Country_or_State]
        AND d.province_or_city = r.[Province_or_City]
  );
GO

INSERT INTO [dbo].[dim_shop] (shop_name, shop_age)
SELECT DISTINCT
    r.[Shop_Name],
    r.[Shop_Age]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Shop_Name] IS NOT NULL
  AND r.[Shop_Age] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_shop] AS d
      WHERE d.shop_name = r.[Shop_Name]
        AND d.shop_age = r.[Shop_Age]
  );
GO

INSERT INTO [dbo].[dim_pc_product] (pc_make, pc_model, storage_type, ram, storage_capacity)
SELECT DISTINCT
    r.[PC_Make],
    r.[PC_Model],
    r.[Storage_Type],
    r.[RAM],
    r.[Storage_Capacity]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[PC_Make] IS NOT NULL
  AND r.[PC_Model] IS NOT NULL
  AND r.[Storage_Type] IS NOT NULL
  AND r.[RAM] IS NOT NULL
  AND r.[Storage_Capacity] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_pc_product] AS d
      WHERE d.pc_make = r.[PC_Make]
        AND d.pc_model = r.[PC_Model]
        AND d.storage_type = r.[Storage_Type]
        AND d.ram = r.[RAM]
        AND d.storage_capacity = r.[Storage_Capacity]
  );
GO

INSERT INTO [dbo].[dim_sales_person] (sales_person_name, sales_person_department)
SELECT DISTINCT
    r.[Sales_Person_Name],
    r.[Sales_Person_Department]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Sales_Person_Name] IS NOT NULL
  AND r.[Sales_Person_Department] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_sales_person] AS d
      WHERE d.sales_person_name = r.[Sales_Person_Name]
        AND d.sales_person_department = r.[Sales_Person_Department]
  );
GO

INSERT INTO [dbo].[dim_payment_id] (payment_method)
SELECT DISTINCT
    r.[Payment_Method]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Payment_Method] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_payment_id] AS d
      WHERE d.payment_method = r.[Payment_Method]
  );
GO

INSERT INTO [dbo].[dim_priority] (priority)
SELECT DISTINCT
    r.[Priority]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Priority] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_priority] AS d
      WHERE d.priority = r.[Priority]
  );
GO

INSERT INTO [dbo].[dim_date] (full_date, calendar_year, calendar_month, calendar_day, day_name)
SELECT DISTINCT
    CAST(r.[Purchase_Date] AS DATE) AS full_date,
    YEAR(CAST(r.[Purchase_Date] AS DATE)) AS calendar_year,
    MONTH(CAST(r.[Purchase_Date] AS DATE)) AS calendar_month,
    DAY(CAST(r.[Purchase_Date] AS DATE)) AS calendar_day,
    DATENAME(WEEKDAY, CAST(r.[Purchase_Date] AS DATE)) AS day_name
FROM [dbo].[raw_pc_data] AS r
WHERE TRY_CAST(r.[Purchase_Date] AS DATE) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_date] AS d
      WHERE d.full_date = CAST(r.[Purchase_Date] AS DATE)
  );
GO

INSERT INTO [dbo].[dim_channel] (channel)
SELECT DISTINCT
    r.[Channel]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Channel] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_channel] AS d
      WHERE d.channel = r.[Channel]
  );
GO

INSERT INTO [dbo].[dim_customer_details] (customer_name, customer_surname, customer_contact_number, customer_email_address)
SELECT DISTINCT
    r.[Customer_Name],
    r.[Customer_Surname],
    r.[Customer_Contact_Number],
    r.[Customer_Email_Address]
FROM [dbo].[raw_pc_data] AS r
WHERE r.[Customer_Name] IS NOT NULL
  AND r.[Customer_Surname] IS NOT NULL
  AND r.[Customer_Contact_Number] IS NOT NULL
  AND r.[Customer_Email_Address] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dbo].[dim_customer_details] AS d
      WHERE d.customer_name = r.[Customer_Name]
        AND d.customer_surname = r.[Customer_Surname]
        AND d.customer_contact_number = r.[Customer_Contact_Number]
        AND d.customer_email_address = r.[Customer_Email_Address]
  );
GO

-- Note: Fact table population should be handled by stored procedures in the companion script.
