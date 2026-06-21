-- 0.3.8 Create dimension tables if missing

IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_channel]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_channel] (
        channel_id INT IDENTITY(1,1) PRIMARY KEY,
        channel NVARCHAR(100) NOT NULL
    );
END;
GO