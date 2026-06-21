IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_priority]', 'U') IS NULL
BEGIN
CREATE TABLE [stg_computer_sales].[dbo].[dim_priority]
(
priority_id INT IDENTITY(1,1) PRIMARY KEY,
priority NVARCHAR(100) NOT NULL
);
END;

---------------------------------------------------------------------------------

INSERT INTO [stg_computer_sales].[dbo].[dim_priority]
(priority)

SELECT DISTINCT
r.Priority
FROM [stg_computer_sales].[dbo].[raw_pc_data] r
WHERE r.Priority IS NOT NULL
AND NOT EXISTS
(
SELECT 1
FROM [stg_computer_sales].[dbo].[dim_priority] d
WHERE d.priority = r.Priority
);

-----------------------------------------------------------------------------------------


DROP TABLE IF EXISTS [stg_computer_sales].[dbo].[dim_priority]
SELECT * FROM [stg_computer_sales].[dbo].[dim_priority]

-------------------------------------------------------------------------------------------



IF DB_ID('clean_computer_sales') IS NULL
BEGIN
CREATE DATABASE clean_computer_sales;
END;

IF OBJECT_ID('[clean_computer_sales].[dbo].[dim_priority_id]', 'U') IS NULL
BEGIN
CREATE TABLE [clean_computer_sales].[dbo].[dim_priority_id]
(
priority_id INT IDENTITY(1,1) PRIMARY KEY,
priority NVARCHAR(100) NOT NULL
);
END;

----------------------------------------------------------------------------------------------

INSERT INTO [clean_computer_sales].[dbo].[dim_priority_id]
(priority)

SELECT DISTINCT
r.Priority
FROM [stg_computer_sales].[dbo].[raw_pc_data] r
WHERE r.Priority IS NOT NULL
AND NOT EXISTS
(
SELECT 1
FROM [clean_computer_sales].[dbo].[dim_priority_id] d
WHERE d.priority = r.Priority
);

----------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS [clean_computer_sales].[dbo].[dim_priority_id]
SELECT * FROM [clean_computer_sales].[dbo].[dim_priority_id];