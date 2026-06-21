-- 0.4.0 Create fact table if missing
--DROP TABLE IF EXISTS [stg_computer_sales].[dbo].[pc_sales_fact]
IF OBJECT_ID('[stg_computer_sales].[dbo].[pc_sales_fact]', 'U') IS NULL
BEGIN
    CREATE TABLE [stg_computer_sales].[dbo].[pc_sales_fact] (
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
        CONSTRAINT [FK_pc_sales_fact_customer] FOREIGN KEY (customer_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_customer_details] (customer_id),
        CONSTRAINT [FK_pc_sales_fact_location] FOREIGN KEY (location_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_locations] (location_id),
        CONSTRAINT [FK_pc_sales_fact_pc_product] FOREIGN KEY (pc_product_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_pc_product] (pc_product_id),
        CONSTRAINT [FK_pc_sales_fact_channel] FOREIGN KEY (channel_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_channel] (channel_id),
        CONSTRAINT [FK_pc_sales_fact_payment] FOREIGN KEY (payment_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_payment_id] (payment_id),
        CONSTRAINT [FK_pc_sales_fact_sales_person] FOREIGN KEY (sales_person_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_sales_person] (sales_person_id),
        CONSTRAINT [FK_pc_sales_fact_date] FOREIGN KEY (date_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_date] (date_id),
        CONSTRAINT [FK_pc_sales_fact_shop] FOREIGN KEY (shop_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_shop] (shop_id),
        CONSTRAINT [FK_pc_sales_fact_priority] FOREIGN KEY (priority_id)
            REFERENCES [stg_computer_sales].[dbo].[dim_priority] (priority_id)
    );
END;
GO