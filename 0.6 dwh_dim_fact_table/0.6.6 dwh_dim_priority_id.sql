-- 0.6.6 DWH and load dim_priority_id into dwh_computer_sales

IF DB_ID('dwh_computer_sales') IS NULL
BEGIN
    CREATE DATABASE dwh_computer_sales;
END;
GO

IF OBJECT_ID('[dwh_computer_sales].[dbo].[dim_priority_id]', 'U') IS NULL
BEGIN
    CREATE TABLE [dwh_computer_sales].[dbo].[dim_priority_id] (
        priority_id INT IDENTITY(1,1) PRIMARY KEY,
        priority NVARCHAR(100) NOT NULL
    );
END;
GO

-----------------------------------------------------------------------------

-- Load data into dwh dim_priority_id from staging raw
INSERT INTO [dwh_computer_sales].[dbo].[dim_priority_id] (priority)
SELECT DISTINCT
    r.[Priority]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Priority] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dwh_computer_sales].[dbo].[dim_priority_id] AS d
      WHERE d.priority = r.[Priority]
  );
GO

---------------------------------------------------------------------------------

SELECT * FROM [dwh_computer_sales].[dbo].[dim_priority_id];
GO
