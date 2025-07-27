CREATE FUNCTION fn_ProductListPrice (@ProductID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Price INT
    SELECT @Price = list_price
    FROM production.products
    WHERE product_id = @ProductID
    RETURN @Price;
END
SELECT dbo.fn_ProductListPrice(101) AS price
------------------------------------------------------------------------
CREATE FUNCTION fn_StoreSalesAmount (@StoreID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalSales INT;
    SELECT @TotalSales = SUM(oi.list_price * oi.quantity)
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.store_id = @StoreID;
    RETURN @TotalSales
END
SELECT dbo.fn_StoreSalesAmount(2) AS Sales_Amt
-------------------------------------------------------------------------------
CREATE FUNCTION fn_OrderBetweenDates (
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(   SELECT *
    FROM sales.orders
    WHERE order_date BETWEEN @StartDate AND @EndDate)
SELECT * FROM dbo.fn_OrderBetweenDates('2016-01-01', '2016-01-31')
------------------------------------------------------------------------

CREATE FUNCTION fn_ProductCountByBrand (@BrandID INT)
RETURNS INT
AS
BEGIN
    DECLARE @ProductCount INT;
    SELECT @ProductCount = COUNT(*)
    FROM production.products
    WHERE brand_id = @BrandID;
    RETURN @ProductCount
END
---------------------------------------------------
CREATE FUNCTION fn_ProductCountByBrand (@BrandID INT)
RETURNS INT
AS
BEGIN
    DECLARE @ProductCount INT;
    SELECT @ProductCount = COUNT(*)
    FROM production.products
    WHERE brand_id = @BrandID;
    RETURN @ProductCount
END
SELECT dbo.fn_ProductCountByBrand(3) as Brand_Count
-------------------------------------------------------------
CREATE TABLE price_change_log (
    logid INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price INT,
    new_price INT,
    change_date DATETIME
)
CREATE TRIGGER tr_LogPriceUpdate
ON production.products
FOR UPDATE
AS
BEGIN
    INSERT INTO price_change_log (product_id, old_price, new_price, change_date)
    SELECT 
        d.product_id,
        d.list_price,
        i.list_price,
        GETDATE()
    FROM deleted d
    JOIN inserted i ON d.product_id = i.product_id
    WHERE d.list_price <> i.list_price;
END
update production.products set list_price=750 where product_id=5
select * from price_change_log
-----------------------------------------------------------------------------