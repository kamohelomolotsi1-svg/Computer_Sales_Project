-- 0.6.3 DWH and load dim_pc_product into dwh_computer_sales

IF DB_ID('dwh_computer_sales') IS NULL
BEGIN
    CREATE DATABASE dwh_computer_sales;
END;
GO

IF OBJECT_ID('[dwh_computer_sales].[dbo].[dim_pc_product]', 'U') IS NULL
BEGIN
    CREATE TABLE [dwh_computer_sales].[dbo].[dim_pc_product] (
        pc_product_id INT IDENTITY(1,1) PRIMARY KEY,
        pc_make NVARCHAR(100) NOT NULL,
        pc_model NVARCHAR(100) NOT NULL,
        storage_type NVARCHAR(100) NOT NULL,
        ram NVARCHAR(50) NOT NULL,
        storage_capacity NVARCHAR(100) NOT NULL
    );
END;
GO

-----------------------------------------------------------------------------

-- Load data into dwh dim_pc_product from staging raw
INSERT INTO [dwh_computer_sales].[dbo].[dim_pc_product] (pc_make, pc_model, storage_type, ram, storage_capacity)
SELECT DISTINCT
    r.[PC_Make],
    r.[PC_Model],
    r.[Storage_Type],
    r.[RAM],
    r.[Storage_Capacity]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[PC_Make] IS NOT NULL
  AND r.[PC_Model] IS NOT NULL
  AND r.[Storage_Type] IS NOT NULL
  AND r.[RAM] IS NOT NULL
  AND r.[Storage_Capacity] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dwh_computer_sales].[dbo].[dim_pc_product] AS d
      WHERE d.pc_make = r.[PC_Make]
        AND d.pc_model = r.[PC_Model]
        AND d.storage_type = r.[Storage_Type]
        AND d.ram = r.[RAM]
        AND d.storage_capacity = r.[Storage_Capacity]
  );
GO

---------------------------------------------------------------------------------

SELECT * FROM [dwh_computer_sales].[dbo].[dim_pc_product];
GO
