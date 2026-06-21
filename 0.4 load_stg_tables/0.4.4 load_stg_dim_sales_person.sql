USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_sales_person] (sales_person_name, sales_person_department)
SELECT DISTINCT
    r.[Sales_Person_Name],
    r.[Sales_Person_Department]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Sales_Person_Name] IS NOT NULL
  AND r.[Sales_Person_Department] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [stg_computer_sales].[dbo].[dim_sales_person] AS d
      WHERE d.sales_person_name = r.[Sales_Person_Name]
        AND d.sales_person_department = r.[Sales_Person_Department]
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_sales_person]