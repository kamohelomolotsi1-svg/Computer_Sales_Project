-- 0.5.6 Clean and load dim_priority_id into clean_computer_sales

IF DB_ID('clean_computer_sales') IS NULL
BEGIN
    CREATE DATABASE clean_computer_sales;
END;
GO

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_priority_id]', 'U') IS NULL
BEGIN
    CREATE TABLE [clean_computer_sales].[dbo].[dim_priority_id] (
        priority_id INT IDENTITY(1,1) PRIMARY KEY,
        priority NVARCHAR(100) NOT NULL
    );
END;
GO

TRUNCATE TABLE [clean_computer_sales].[dbo].[dim_priority_id];
GO

INSERT INTO [clean_computer_sales].[dbo].[dim_priority_id] (priority)
SELECT DISTINCT
    r.[Priority]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Priority] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [clean_computer_sales].[dbo].[dim_priority_id] AS d
      WHERE d.priority = r.[Priority]
  );
GO

SELECT * FROM [clean_computer_sales].[dbo].[dim_priority_id];
GO
