-- 0.3.6 Create dimension tables if missing


IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_priority]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_priority] (
        priority_id INT IDENTITY(1,1) PRIMARY KEY,
        priority NVARCHAR(100) NOT NULL
    );
END;
GO