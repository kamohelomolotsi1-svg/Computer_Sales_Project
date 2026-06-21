USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_pc_product] (pc_make, pc_model, storage_type, ram, storage_capacity)
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
      FROM [stg_computer_sales].[dbo].[dim_pc_product] AS d
      WHERE d.pc_make = r.[PC_Make]
        AND d.pc_model = r.[PC_Model]
        AND d.storage_type = r.[Storage_Type]
        AND d.ram = r.[RAM]
        AND d.storage_capacity = r.[Storage_Capacity]
  );
GO



-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_pc_product]