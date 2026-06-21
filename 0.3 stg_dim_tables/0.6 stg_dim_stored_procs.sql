USE [stg_computer_sales];
GO

-- Stored procedures for loading dimension tables and the fact table.

IF OBJECT_ID('[dbo].[usp_load_dim_locations]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_locations];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_locations]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_locations] (continent, country_or_state, province_or_city)
    SELECT DISTINCT
        r.[Continent],
        r.[Country_or_State],
        r.[Province_or_City]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Continent] IS NOT NULL
      AND r.[Country_or_State] IS NOT NULL
      AND r.[Province_or_City] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_locations] AS d
          WHERE d.continent = r.[Continent]
            AND d.country_or_state = r.[Country_or_State]
            AND d.province_or_city = r.[Province_or_City]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_shop]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_shop];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_shop]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_shop] (shop_name, shop_age)
    SELECT DISTINCT
        r.[Shop_Name],
        r.[Shop_Age]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Shop_Name] IS NOT NULL
      AND r.[Shop_Age] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_shop] AS d
          WHERE d.shop_name = r.[Shop_Name]
            AND d.shop_age = r.[Shop_Age]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_pc_product]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_pc_product];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_pc_product]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_pc_product] (pc_make, pc_model, storage_type, ram, storage_capacity)
    SELECT DISTINCT
        r.[PC_Make],
        r.[PC_Model],
        r.[Storage_Type],
        r.[RAM],
        r.[Storage_Capacity]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[PC_Make] IS NOT NULL
      AND r.[PC_Model] IS NOT NULL
      AND r.[Storage_Type] IS NOT NULL
      AND r.[RAM] IS NOT NULL
      AND r.[Storage_Capacity] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_pc_product] AS d
          WHERE d.pc_make = r.[PC_Make]
            AND d.pc_model = r.[PC_Model]
            AND d.storage_type = r.[Storage_Type]
            AND d.ram = r.[RAM]
            AND d.storage_capacity = r.[Storage_Capacity]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_sales_person]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_sales_person];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_sales_person]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_sales_person] (sales_person_name, sales_person_department)
    SELECT DISTINCT
        r.[Sales_Person_Name],
        r.[Sales_Person_Department]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Sales_Person_Name] IS NOT NULL
      AND r.[Sales_Person_Department] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_sales_person] AS d
          WHERE d.sales_person_name = r.[Sales_Person_Name]
            AND d.sales_person_department = r.[Sales_Person_Department]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_payment_id]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_payment_id];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_payment_id]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_payment_id] (payment_method)
    SELECT DISTINCT
        r.[Payment_Method]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Payment_Method] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_payment_id] AS d
          WHERE d.payment_method = r.[Payment_Method]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_priority]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_priority];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_priority]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_priority] (priority)
    SELECT DISTINCT
        r.[Priority]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Priority] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_priority] AS d
          WHERE d.priority = r.[Priority]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_date]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_date];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_date]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_date] (full_date, calendar_year, calendar_month, calendar_day, day_name)
    SELECT DISTINCT
        CAST(r.[Purchase_Date] AS DATE) AS full_date,
        YEAR(CAST(r.[Purchase_Date] AS DATE)) AS calendar_year,
        MONTH(CAST(r.[Purchase_Date] AS DATE)) AS calendar_month,
        DAY(CAST(r.[Purchase_Date] AS DATE)) AS calendar_day,
        DATENAME(WEEKDAY, CAST(r.[Purchase_Date] AS DATE)) AS day_name
    FROM [dbo].[raw_pc_data] AS r
    WHERE TRY_CAST(r.[Purchase_Date] AS DATE) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_date] AS d
          WHERE d.full_date = CAST(r.[Purchase_Date] AS DATE)
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_channel]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_channel];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_channel]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_channel] (channel)
    SELECT DISTINCT
        r.[Channel]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Channel] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_channel] AS d
          WHERE d.channel = r.[Channel]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_dim_customer_details]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_dim_customer_details];
GO

CREATE PROCEDURE [dbo].[usp_load_dim_customer_details]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[dim_customer_details] (customer_name, customer_surname, customer_contact_number, customer_email_address)
    SELECT DISTINCT
        r.[Customer_Name],
        r.[Customer_Surname],
        r.[Customer_Contact_Number],
        r.[Customer_Email_Address]
    FROM [dbo].[raw_pc_data] AS r
    WHERE r.[Customer_Name] IS NOT NULL
      AND r.[Customer_Surname] IS NOT NULL
      AND r.[Customer_Contact_Number] IS NOT NULL
      AND r.[Customer_Email_Address] IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[dim_customer_details] AS d
          WHERE d.customer_name = r.[Customer_Name]
            AND d.customer_surname = r.[Customer_Surname]
            AND d.customer_contact_number = r.[Customer_Contact_Number]
            AND d.customer_email_address = r.[Customer_Email_Address]
      );
END;
GO

IF OBJECT_ID('[dbo].[usp_load_all_dimensions]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_all_dimensions];
GO

CREATE PROCEDURE [dbo].[usp_load_all_dimensions]
AS
BEGIN
    SET NOCOUNT ON;

    EXEC [dbo].[usp_load_dim_locations];
    EXEC [dbo].[usp_load_dim_shop];
    EXEC [dbo].[usp_load_dim_pc_product];
    EXEC [dbo].[usp_load_dim_sales_person];
    EXEC [dbo].[usp_load_dim_payment_id];
    EXEC [dbo].[usp_load_dim_priority];
    EXEC [dbo].[usp_load_dim_date];
    EXEC [dbo].[usp_load_dim_channel];
    EXEC [dbo].[usp_load_dim_customer_details];
END;
GO

IF OBJECT_ID('[dbo].[usp_load_pc_sales_fact]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_load_pc_sales_fact];
GO

CREATE PROCEDURE [dbo].[usp_load_pc_sales_fact]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[pc_sales_fact] (
        customer_id,
        location_id,
        pc_product_id,
        channel_id,
        payment_id,
        sales_person_id,
        date_id,
        shop_id,
        priority_id,
        cost_price,
        sale_price,
        discount_amount,
        finance_amount,
        credit_score,
        total_sales_per_employee,
        pc_market_price
    )
    SELECT
        c.customer_id,
        l.location_id,
        p.pc_product_id,
        ch.channel_id,
        pay.payment_id,
        s.sales_person_id,
        d.date_id,
        sh.shop_id,
        pr.priority_id,
        TRY_CAST(r.[Cost_Price] AS DECIMAL(18,2)),
        TRY_CAST(r.[Sale_Price] AS DECIMAL(18,2)),
        TRY_CAST(r.[Discount_Amount] AS DECIMAL(18,2)),
        TRY_CAST(r.[Finance_Amount] AS DECIMAL(18,2)),
        TRY_CAST(r.[Credit_Score] AS INT),
        TRY_CAST(r.[Total_Sales_per_Employee] AS DECIMAL(18,2)),
        TRY_CAST(r.[PC_Market_Price] AS DECIMAL(18,2))
    FROM [dbo].[raw_pc_data] AS r
    INNER JOIN [dbo].[dim_customer_details] AS c
        ON c.customer_name = r.[Customer_Name]
       AND c.customer_surname = r.[Customer_Surname]
       AND c.customer_contact_number = r.[Customer_Contact_Number]
       AND c.customer_email_address = r.[Customer_Email_Address]
    INNER JOIN [dbo].[dim_locations] AS l
        ON l.continent = r.[Continent]
       AND l.country_or_state = r.[Country_or_State]
       AND l.province_or_city = r.[Province_or_City]
    INNER JOIN [dbo].[dim_pc_product] AS p
        ON p.pc_make = r.[PC_Make]
       AND p.pc_model = r.[PC_Model]
       AND p.storage_type = r.[Storage_Type]
       AND p.ram = r.[RAM]
       AND p.storage_capacity = r.[Storage_Capacity]
    INNER JOIN [dbo].[dim_channel] AS ch
        ON ch.channel = r.[Channel]
    INNER JOIN [dbo].[dim_payment_id] AS pay
        ON pay.payment_method = r.[Payment_Method]
    INNER JOIN [dbo].[dim_sales_person] AS s
        ON s.sales_person_name = r.[Sales_Person_Name]
       AND s.sales_person_department = r.[Sales_Person_Department]
    INNER JOIN [dbo].[dim_date] AS d
        ON d.full_date = CAST(r.[Purchase_Date] AS DATE)
    INNER JOIN [dbo].[dim_shop] AS sh
        ON sh.shop_name = r.[Shop_Name]
       AND sh.shop_age = r.[Shop_Age]
    INNER JOIN [dbo].[dim_priority] AS pr
        ON pr.priority = r.[Priority]
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[pc_sales_fact] AS f
        WHERE f.customer_id = c.customer_id
          AND f.location_id = l.location_id
          AND f.pc_product_id = p.pc_product_id
          AND f.channel_id = ch.channel_id
          AND f.payment_id = pay.payment_id
          AND f.sales_person_id = s.sales_person_id
          AND f.date_id = d.date_id
          AND f.shop_id = sh.shop_id
          AND f.priority_id = pr.priority_id
          AND f.cost_price = TRY_CAST(r.[Cost_Price] AS DECIMAL(18,2))
          AND f.sale_price = TRY_CAST(r.[Sale_Price] AS DECIMAL(18,2))
          AND f.discount_amount = TRY_CAST(r.[Discount_Amount] AS DECIMAL(18,2))
          AND f.finance_amount = TRY_CAST(r.[Finance_Amount] AS DECIMAL(18,2))
          AND f.credit_score = TRY_CAST(r.[Credit_Score] AS INT)
          AND f.total_sales_per_employee = TRY_CAST(r.[Total_Sales_per_Employee] AS DECIMAL(18,2))
          AND f.pc_market_price = TRY_CAST(r.[PC_Market_Price] AS DECIMAL(18,2))
    );
END;
GO

-- Example: run EXEC [dbo].[usp_load_all_dimensions]; then EXEC [dbo].[usp_load_pc_sales_fact];
