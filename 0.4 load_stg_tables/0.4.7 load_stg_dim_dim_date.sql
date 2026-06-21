USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_date] (full_date, calendar_year, calendar_month, calendar_day, day_name)
SELECT DISTINCT
    CAST(r.[Purchase_Date] AS DATE) AS full_date,
    YEAR(CAST(r.[Purchase_Date] AS DATE)) AS calendar_year,
    MONTH(CAST(r.[Purchase_Date] AS DATE)) AS calendar_month,
    DAY(CAST(r.[Purchase_Date] AS DATE)) AS calendar_day,
    DATENAME(WEEKDAY, CAST(r.[Purchase_Date] AS DATE)) AS day_name
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE TRY_CAST(r.[Purchase_Date] AS DATE) IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [stg_computer_sales].[dbo].[dim_date] AS d
      WHERE d.full_date = CAST(r.[Purchase_Date] AS DATE)
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_date]