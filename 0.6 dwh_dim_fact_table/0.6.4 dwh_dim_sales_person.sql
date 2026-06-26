-- 0.6.4 DWH and load dim_sales_person into dwh_computer_sales

IF DB_ID('dwh_computer_sales') IS NULL
BEGIN
    CREATE DATABASE dwh_computer_sales;
END;
GO

IF OBJECT_ID('[dwh_computer_sales].[dbo].[dim_sales_person]', 'U') IS NULL
BEGIN
    CREATE TABLE [dwh_computer_sales].[dbo].[dim_sales_person] (
        sales_person_id INT IDENTITY(1,1) PRIMARY KEY,
        sales_person_name NVARCHAR(100) NOT NULL,
        sales_person_department NVARCHAR(100) NOT NULL
    );
END;
GO

-----------------------------------------------------------------------------

-- Load data into dwh dim_sales_person from staging raw
INSERT INTO [dwh_computer_sales].[dbo].[dim_sales_person] (sales_person_name, sales_person_department)
SELECT DISTINCT
    r.[Sales_Person_Name],
    r.[Sales_Person_Department]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Sales_Person_Name] IS NOT NULL
  AND r.[Sales_Person_Department] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dwh_computer_sales].[dbo].[dim_sales_person] AS d
      WHERE d.sales_person_name = r.[Sales_Person_Name]
        AND d.sales_person_department = r.[Sales_Person_Department]
  );
GO

---------------------------------------------------------------------------------

SELECT * FROM [dwh_computer_sales].[dbo].[dim_sales_person];
GO
