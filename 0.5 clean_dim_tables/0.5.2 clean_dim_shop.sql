-- 0.5.2 Clean and load dim_shop into clean_computer_sales

IF DB_ID('clean_computer_sales') IS NULL
BEGIN
    CREATE DATABASE clean_computer_sales;
END;
GO

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_shop]', 'U') IS NULL
BEGIN
    CREATE TABLE [clean_computer_sales].[dbo].[dim_shop] (
        shop_id INT IDENTITY(1,1) PRIMARY KEY,
        shop_name NVARCHAR(100) NOT NULL,
        shop_age NVARCHAR(50) NOT NULL
    );
END;
GO

TRUNCATE TABLE [clean_computer_sales].[dbo].[dim_shop];
GO

-- Load data into clean dim_shop from staging raw
INSERT INTO [clean_computer_sales].[dbo].[dim_shop] (shop_name, shop_age)
SELECT DISTINCT
    r.[Shop_Name],
    r.[Shop_Age]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Shop_Name] IS NOT NULL
  AND r.[Shop_Age] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [clean_computer_sales].[dbo].[dim_shop] AS d
      WHERE d.shop_name = r.[Shop_Name]
        AND d.shop_age = r.[Shop_Age]
  );
GO

SELECT * FROM [clean_computer_sales].[dbo].[dim_shop];
GO
