USE [stg_computer_sales];
GO

-- Wrapper script to execute staging load stored procedures in the proper order.
-- Run this after the raw staging data is available in [dbo].[raw_pc_data].

EXEC [dbo].[usp_load_all_dimensions];
GO

EXEC [dbo].[usp_load_pc_sales_fact];
GO

-- Optional: verify the fact table row count after load
SELECT COUNT(*) AS FactRowCount
FROM [dbo].[pc_sales_fact];
GO
