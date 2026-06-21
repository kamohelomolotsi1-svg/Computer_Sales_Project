-- 0.3.4 Create dimension tables if missing

IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_sales_person]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_sales_person] (
        sales_person_id INT IDENTITY(1,1) PRIMARY KEY,
        sales_person_name NVARCHAR(100) NOT NULL,
        sales_person_department NVARCHAR(100) NOT NULL
    );
END;
GO