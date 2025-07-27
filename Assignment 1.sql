CREATE VIEW vwunsold_products AS
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.model_year,
    p.list_price
FROM 
    production.products p
JOIN 
    production.brands b ON p.brand_id = b.brand_id
JOIN 
    production.categories c ON p.category_id = c.category_id
LEFT JOIN 
    sales.order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.product_id IS NULL

SELECT * FROM vwunsold_products

---------------------------------------------------------------------
CREATE VIEW vwproduct_catalog AS
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.list_price
FROM 
    production.products p
JOIN 
    production.brands b ON p.brand_id = b.brand_id
JOIN 
    production.categories c ON p.category_id = c.category_id
WHERE 
    p.model_year > 2018

SELECT * FROM vwproduct_catalog order by category_name, product_name
--------------------------------------------------------------
--------------------------------------------------------------
SELECT 
    category_name,
    product_name,
    list_price
FROM (
    SELECT 
        c.category_name,
        p.product_name,
        p.list_price,
        ROW_NUMBER() OVER (
            PARTITION BY c.category_name 
            ORDER BY p.list_price DESC
        ) AS rank
    FROM 
        production.products p
    JOIN 
        production.categories c ON p.category_id = c.category_id
) ranked_products
WHERE rank = 1