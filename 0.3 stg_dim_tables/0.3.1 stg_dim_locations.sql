-- 0.3.1 Create dimension tables if missing

IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_locations]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_locations] (
        location_id INT IDENTITY(1,1) PRIMARY KEY,
        continent NVARCHAR(100) NOT NULL,
        country_or_state NVARCHAR(100) NOT NULL,
        province_or_city NVARCHAR(100) NOT NULL
    );
END;
GO