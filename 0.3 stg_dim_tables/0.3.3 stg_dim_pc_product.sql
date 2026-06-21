-- 0.3.3 Create dimension tables if missing


IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_pc_product]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_pc_product] (
        pc_product_id INT IDENTITY(1,1) PRIMARY KEY,
        pc_make NVARCHAR(100) NOT NULL,
        pc_model NVARCHAR(100) NOT NULL,
        storage_type NVARCHAR(100) NOT NULL,
        ram NVARCHAR(50) NOT NULL,
        storage_capacity NVARCHAR(100) NOT NULL
    );
END;
GO