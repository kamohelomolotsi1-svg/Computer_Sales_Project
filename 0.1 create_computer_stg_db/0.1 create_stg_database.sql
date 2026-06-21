IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'stg_computer_sales')
BEGIN
    CREATE DATABASE stg_computer_sales;
END
GO