USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_shop] (shop_name, shop_age)
SELECT DISTINCT
    r.[Shop_Name],
    r.[Shop_Age]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Shop_Name] IS NOT NULL
  AND r.[Shop_Age] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [stg_computer_sales].[dbo].[dim_shop] AS d
      WHERE d.shop_name = r.[Shop_Name]
        AND d.shop_age = r.[Shop_Age]
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_locations]