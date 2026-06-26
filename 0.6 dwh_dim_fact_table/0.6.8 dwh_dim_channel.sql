-- 0.6.8 DWH and load dim_channel into dwh_computer_sales

IF DB_ID('dwh_computer_sales') IS NULL
BEGIN
    CREATE DATABASE dwh_computer_sales;
END;
GO

IF OBJECT_ID('[dwh_computer_sales].[dbo].[dim_channel]', 'U') IS NULL
BEGIN
    CREATE TABLE [dwh_computer_sales].[dbo].[dim_channel] (
        channel_id INT IDENTITY(1,1) PRIMARY KEY,
        channel NVARCHAR(100) NOT NULL
    );
END;
GO

-----------------------------------------------------------------------------

-- Load data into dwh dim_channel from staging raw
INSERT INTO [dwh_computer_sales].[dbo].[dim_channel] (channel)
SELECT DISTINCT
    r.[Channel]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Channel] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dwh_computer_sales].[dbo].[dim_channel] AS d
      WHERE d.channel = r.[Channel]
  );
GO

---------------------------------------------------------------------------------

SELECT * FROM [dwh_computer_sales].[dbo].[dim_channel];
GO
