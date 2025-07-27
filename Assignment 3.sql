--Log Table Creation
CREATE TABLE production.price_change_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    old_price DECIMAL(10,2) NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,
    change_date DATETIME NOT NULL DEFAULT GETDATE()
)

--Trigger to log updates made to list_price
CREATE TRIGGER trg_log_price_update
ON production.products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.price_change_log (product_id, old_price, new_price)
    SELECT
        i.product_id,
        d.list_price,
        i.list_price
    FROM inserted i
    INNER JOIN deleted d ON i.product_id = d.product_id
    WHERE i.list_price <> d.list_price;
END

update production.products
set list_price=750
where product_id=10

--trigger to Prevent Product Deletion if Linked to Open Orders
Create Trigger trg_prevent_product_delete
On production.products
after Delete
As
Begin
    Set NOCOUNT ON
    If exists (
        Select 1
        From deleted d
        Inner join sales.order_items oi
        ON d.product_id =oi.product_id
        Inner Join sales.orders o
        ON oi.order_id =o.order_id
        Where o.order_status IN (1,2))  --Order status: 1 = Pending; 2 = Processing
    Begin
        RAISERROR('Cannot delete products involved in open orders',16,1); --16 is severity level, 1 is state code
        RollBack Transaction;
        Return;
    END
    Delete from production.products
    Where product_id IN (Select product_id From deleted)
END

--1
SELECT s.store_name, SUM(oi.quantity * oi.list_price) AS total_sales
FROM sales.stores s
INNER JOIN sales.orders o ON s.store_id = o.store_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
HAVING SUM(oi.quantity * oi.list_price) > 50000

--2
SELECT TOP 5 p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM production.products p
INNER JOIN sales.order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC

--3
SELECT FORMAT(o.order_date, 'yyyy-MM') AS month,SUM(oi.quantity * oi.list_price) AS monthly_sales
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2016
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
ORDER BY month

--4
SELECT s.store_name, SUM(oi.quantity * oi.list_price) AS total_revenue
FROM sales.stores s
INNER JOIN sales.orders o ON s.store_id = o.store_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
HAVING SUM(oi.quantity * oi.list_price) > 100000




