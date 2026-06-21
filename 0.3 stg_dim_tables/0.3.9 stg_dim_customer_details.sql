-- 0.3.9 Create dimension tables if missing


IF OBJECT_ID('[stg_computer_sales].[dbo].[dim_customer_details]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[dim_customer_details] (
        customer_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_name NVARCHAR(100) NOT NULL,
        customer_surname NVARCHAR(100) NOT NULL,
        customer_contact_number NVARCHAR(100) NOT NULL,
        customer_email_address NVARCHAR(150) NOT NULL
    );
END;
GO