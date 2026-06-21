-- 0.5.8 Clean and load dim_channel into clean_computer_sales

IF DB_ID('clean_computer_sales') IS NULL
BEGIN
    CREATE DATABASE clean_computer_sales;
END;
GO

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_channel]', 'U') IS NULL
BEGIN
    CREATE TABLE [clean_computer_sales].[dbo].[dim_channel] (
        channel_id INT IDENTITY(1,1) PRIMARY KEY,
        channel NVARCHAR(100) NOT NULL
    );
END;
GO

TRUNCATE TABLE [clean_computer_sales].[dbo].[dim_channel];
GO

INSERT INTO [clean_computer_sales].[dbo].[dim_channel] (channel)
SELECT DISTINCT
    r.[Channel]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Channel] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [clean_computer_sales].[dbo].[dim_channel] AS d
      WHERE d.channel = r.[Channel]
  );
GO

SELECT * FROM [clean_computer_sales].[dbo].[dim_channel];
GO
