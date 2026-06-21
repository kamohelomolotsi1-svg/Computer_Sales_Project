USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_payment_id] (payment_method)
SELECT DISTINCT
    r.[Payment_Method]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Payment_Method] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [stg_computer_sales].[dbo].[dim_payment_id] AS d
      WHERE d.payment_method = r.[Payment_Method]
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_payment_id]