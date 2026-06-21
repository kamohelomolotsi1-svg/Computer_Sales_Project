-- 0.5.5 Clean and load dim_payment_id into clean_computer_sales

IF DB_ID('clean_computer_sales') IS NULL
BEGIN
    CREATE DATABASE clean_computer_sales;
END;
GO

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_payment_id]', 'U') IS NULL
BEGIN
    CREATE TABLE [clean_computer_sales].[dbo].[dim_payment_id] (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        payment_method NVARCHAR(100) NOT NULL
    );
END;
GO

TRUNCATE TABLE [clean_computer_sales].[dbo].[dim_payment_id];
GO

-- Load data into clean dim_payment_id from staging raw
INSERT INTO [clean_computer_sales].[dbo].[dim_payment_id] (payment_method)
SELECT DISTINCT
    r.[Payment_Method]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Payment_Method] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [clean_computer_sales].[dbo].[dim_payment_id] AS d
      WHERE d.payment_method = r.[Payment_Method]
  );
GO

SELECT * FROM [clean_computer_sales].[dbo].[dim_payment_id];
GO
