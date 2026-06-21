USE [stg_computer_sales];
GO

INSERT INTO [stg_computer_sales].[dbo].[dim_customer_details] (customer_name, customer_surname, customer_contact_number, customer_email_address)
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
      FROM [stg_computer_sales].[dbo].[dim_customer_details] AS d
      WHERE d.customer_name = r.[Customer_Name]
        AND d.customer_surname = r.[Customer_Surname]
        AND d.customer_contact_number = r.[Customer_Contact_Number]
        AND d.customer_email_address = r.[Customer_Email_Address]
  );
GO


-----------------------------------------------------------

SELECT * FROM [stg_computer_sales].[dbo].[dim_customer_details]