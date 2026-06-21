-- 0.3.2 Create dimension tables if missing



IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_shop]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_shop] (
        shop_id INT IDENTITY(1,1) PRIMARY KEY,
        shop_name NVARCHAR(100) NOT NULL,
        shop_age NVARCHAR(50) NOT NULL
    );
END;
GO