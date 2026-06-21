USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_channel] (channel)
SELECT DISTINCT
    r.[Channel]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Channel] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [stg_computer_sales].[dbo].[dim_channel] AS d
      WHERE d.channel = r.[Channel]
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_channel]