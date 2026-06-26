IF DB_ID('dwh_computer_sales') IS NULL
BEGIN
    CREATE DATABASE dwh_computer_sales;
END;
GO

IF OBJECT_ID('[dwh_computer_sales].[dbo].[pc_sales_fact]', 'U') IS NULL
BEGIN
    CREATE TABLE [dwh_computer_sales].[dbo].[pc_sales_fact] (
        pc_sales_fact_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT NOT NULL,
        location_id INT NOT NULL,
        pc_product_id INT NOT NULL,
        channel_id INT NOT NULL,
        payment_id INT NOT NULL,
        sales_person_id INT NOT NULL,
        date_id INT NOT NULL,
        shop_id INT NOT NULL,
        priority_id INT NOT NULL,
        cost_price DECIMAL(18,2) NULL,
        sale_price DECIMAL(18,2) NULL,
        discount_amount DECIMAL(18,2) NULL,
        finance_amount DECIMAL(18,2) NULL,
        credit_score INT NULL,
        total_sales_per_employee DECIMAL(18,2) NULL,
        pc_market_price DECIMAL(18,2) NULL,
        CONSTRAINT [FK_dwh_pc_sales_fact_customer] FOREIGN KEY (customer_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_customer_details] (customer_detail_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_location] FOREIGN KEY (location_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_locations] (location_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_pc_product] FOREIGN KEY (pc_product_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_pc_product] (pc_product_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_channel] FOREIGN KEY (channel_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_channel] (channel_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_payment] FOREIGN KEY (payment_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_payment_id] (payment_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_sales_person] FOREIGN KEY (sales_person_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_sales_person] (sales_person_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_date] FOREIGN KEY (date_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_date] (date_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_shop] FOREIGN KEY (shop_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_shop] (shop_id),
        CONSTRAINT [FK_dwh_pc_sales_fact_priority] FOREIGN KEY (priority_id)
            REFERENCES [dwh_computer_sales].[dbo].[dim_priority_id] (priority_id)
    );
END;
GO


------------------------------------------------------------------------------------------


INSERT INTO [dwh_computer_sales].[dbo].[pc_sales_fact] (
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
    c.customer_detail_id,
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
FROM [stg_computer_sales].[dbo].[raw_pc_data] AS r
INNER JOIN [dwh_computer_sales].[dbo].[dim_customer_details] AS c
    ON c.customer_name = r.[Customer_Name]
   AND c.customer_surname = r.[Customer_Surname]
   AND c.customer_contact_number = r.[Customer_Contact_Number]
   AND c.customer_email_address = r.[Customer_Email_Address]
INNER JOIN [dwh_computer_sales].[dbo].[dim_locations] AS l
    ON l.continent = r.[Continent]
   AND l.country_or_state = r.[Country_or_State]
   AND l.province_or_city = r.[Province_or_City]
INNER JOIN [dwh_computer_sales].[dbo].[dim_pc_product] AS p
    ON p.pc_make = r.[PC_Make]
   AND p.pc_model = r.[PC_Model]
   AND p.storage_type = r.[Storage_Type]
   AND p.ram = r.[RAM]
   AND p.storage_capacity = r.[Storage_Capacity]
INNER JOIN [dwh_computer_sales].[dbo].[dim_channel] AS ch
    ON ch.channel = r.[Channel]
INNER JOIN [dwh_computer_sales].[dbo].[dim_payment_id] AS pay
    ON pay.payment_method = r.[Payment_Method]
INNER JOIN [dwh_computer_sales].[dbo].[dim_sales_person] AS s
    ON s.sales_person_name = r.[Sales_Person_Name]
   AND s.sales_person_department = r.[Sales_Person_Department]
INNER JOIN [dwh_computer_sales].[dbo].[dim_date] AS d
    ON d.full_date = CAST(r.[Purchase_Date] AS DATE)
INNER JOIN [dwh_computer_sales].[dbo].[dim_shop] AS sh
    ON sh.shop_name = r.[Shop_Name]
   AND sh.shop_age = r.[Shop_Age]
INNER JOIN [dwh_computer_sales].[dbo].[dim_priority_id] AS pr
    ON pr.priority = r.[Priority]
WHERE NOT EXISTS (
    SELECT 1
    FROM [dwh_computer_sales].[dbo].[pc_sales_fact] AS f
    WHERE f.customer_id = c.customer_detail_id
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
GO


----------------------------------------------------------------------------------------------------------------------
SELECT * FROM [dwh_computer_sales].[dbo].[pc_sales_fact];
GO