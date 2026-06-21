-- 0.5.1 Clean and load dim_locations into clean_computer_sales

IF DB_ID('clean_computer_sales') IS NULL
BEGIN
    CREATE DATABASE clean_computer_sales;
END;
GO

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_locations]', 'U') IS NULL
BEGIN
    CREATE TABLE [clean_computer_sales].[dbo].[dim_locations] (
        location_id INT IDENTITY(1,1) PRIMARY KEY,
        continent NVARCHAR(100) NOT NULL,
        country_or_state NVARCHAR(100) NOT NULL,
        province_or_city NVARCHAR(100) NOT NULL
    );
END;
GO

TRUNCATE TABLE [clean_computer_sales].[dbo].[dim_locations];
GO

-- Load data into clean dim_locations from staging raw
INSERT INTO [clean_computer_sales].[dbo].[dim_locations] (continent, country_or_state, province_or_city)
SELECT DISTINCT
    r.[Continent],
    r.[Country_or_State],
    r.[Province_or_City]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Continent] IS NOT NULL
  AND r.[Country_or_State] IS NOT NULL
  AND r.[Province_or_City] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [clean_computer_sales].[dbo].[dim_locations] AS d
      WHERE d.continent = r.[Continent]
        AND d.country_or_state = r.[Country_or_State]
        AND d.province_or_city = r.[Province_or_City]
  );
GO

SELECT * FROM [clean_computer_sales].[dbo].[dim_locations];
GO
