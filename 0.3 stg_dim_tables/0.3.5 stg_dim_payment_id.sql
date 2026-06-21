-- 0.3.5 Create dimension tables if missing

IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_payment_id]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_payment_id] (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        payment_method NVARCHAR(100) NOT NULL
    );
END;
GO