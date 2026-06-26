-- 0.6.9 DWH and load dim_customer_details into dwh_computer_sales

IF DB_ID('dwh_computer_sales') IS NULL
BEGIN
    CREATE DATABASE dwh_computer_sales;
END;
GO

IF OBJECT_ID('[dwh_computer_sales].[dbo].[dim_customer_details]', 'U') IS NULL
BEGIN
    CREATE TABLE [dwh_computer_sales].[dbo].[dim_customer_details] (
        customer_detail_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_name NVARCHAR(100) NOT NULL,
        customer_surname NVARCHAR(100) NOT NULL,
        customer_contact_number NVARCHAR(50) NOT NULL,
        customer_email_address NVARCHAR(150) NOT NULL
    );
END;
GO

-----------------------------------------------------------------------------

-- Load data into dwh dim_customer_details from staging raw
INSERT INTO [dwh_computer_sales].[dbo].[dim_customer_details] (customer_name, customer_surname, customer_contact_number, customer_email_address)
SELECT DISTINCT
    r.[Customer_Name],
    r.[Customer_Surname],
    r.[Customer_Contact_Number],
    r.[Customer_Email_Address]
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
WHERE r.[Customer_Name] IS NOT NULL
  AND r.[Customer_Surname] IS NOT NULL
  AND r.[Customer_Contact_Number] IS NOT NULL
  AND r.[Customer_Email_Address] IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM [dwh_computer_sales].[dbo].[dim_customer_details] AS d
      WHERE d.customer_name = r.[Customer_Name]
        AND d.customer_surname = r.[Customer_Surname]
        AND d.customer_contact_number = r.[Customer_Contact_Number]
        AND d.customer_email_address = r.[Customer_Email_Address]
  );
GO

---------------------------------------------------------------------------------

SELECT * FROM [dwh_computer_sales].[dbo].[dim_customer_details];
GO
