IF DB_ID('clean_computer_sales') IS NULL
BEGIN
    CREATE DATABASE clean_computer_sales;
END;
GO

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_date]', 'U') IS NULL
BEGIN
    CREATE TABLE [clean_computer_sales].[dbo].[dim_date]
    (
        date_id INT IDENTITY(1,1) PRIMARY KEY,
        full_date DATE NOT NULL,
        calendar_year INT NOT NULL,
        calendar_month INT NOT NULL,
        calendar_day INT NOT NULL,
        day_name NVARCHAR(50) NOT NULL
    );
END;
GO


INSERT INTO [clean_computer_sales].[dbo].[dim_date]
(
full_date,
calendar_year,
calendar_month,
calendar_day,
day_name
)

SELECT DISTINCT
dates.full_date,
YEAR(dates.full_date),
MONTH(dates.full_date),
DAY(dates.full_date),
DATENAME(WEEKDAY, dates.full_date)

FROM
(
SELECT TRY_CAST(Purchase_Date AS DATE) AS full_date
FROM [stg_computer_sales].[dbo].[raw_pc_data]

UNION

SELECT TRY_CAST(Ship_Date AS DATE)
FROM [stg_computer_sales].[dbo].[raw_pc_data]

) dates

WHERE dates.full_date IS NOT NULL

AND NOT EXISTS
(
SELECT 1
FROM [clean_computer_sales].[dbo].[dim_date] d
WHERE d.full_date = dates.full_date
);
GO


---------------------------------------------------------------------

SELECT * FROM [clean_computer_sales].[dbo].[dim_date]