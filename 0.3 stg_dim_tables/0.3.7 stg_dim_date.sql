-- 0.3.7 Create dimension tables if missing


IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_date]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_date] (
        date_id INT IDENTITY(1,1) PRIMARY KEY,
        full_date DATE NOT NULL,
        calendar_year INT NOT NULL,
        calendar_month INT NOT NULL,
        calendar_day INT NOT NULL,
        day_name NVARCHAR(20) NOT NULL
    );
END;
GO