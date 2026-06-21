USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_priority] (priority)
SELECT DISTINCT
    r.[Priority]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Priority] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [stg_computer_sales].[dbo].[dim_priority] AS d
      WHERE d.priority = r.[Priority]
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_priority]