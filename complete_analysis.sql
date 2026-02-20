-- TABLE CREATION

drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);

-- DATA CLEANING

-- Check null values
SELECT * FROM zepto
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR availableQuantity IS NULL
OR outofStock IS NULL
OR quantity IS NULL;

-- Products with zero price
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- Remove invalid price records
DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
    discountedSellingPrice = discountedSellingPrice/100.0;

-- EXPLORATORY A NALYSIS

-- Count rows
SELECT COUNT(*) FROM zepto;

-- Sample data
SELECT * FROM zepto LIMIT 10;

-- Distinct categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Stock status distribution
SELECT outofStock, COUNT(*)
FROM zepto
GROUP BY outofStock;

-- Duplicate product names
SELECT name, COUNT(*) AS sku_count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY sku_count DESC;

-- BUSINESS ANALYSIS QUERIES

-- Top 10 best-value products
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Estimated revenue per category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- High MRP but low discount
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10;

-- Top 5 categories by average discount
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Total inventory weight per category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

--ADVANCE SQL QUERIES

-- Rank products by MRP within category
SELECT *
FROM (
    SELECT name,
           category,
           mrp,
           RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS rank_in_category
    FROM zepto
) t
WHERE rank_in_category <= 3;

-- Price per gram
SELECT name,
       ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms > 0
ORDER BY price_per_gram;

-- Weight segmentation
SELECT name,
CASE 
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
END AS weight_category
FROM zepto;

-- VIEWS AND INDEXES

-- Create revenue view
CREATE VIEW category_revenue AS
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category;

-- Create index for performance
CREATE INDEX idx_category
ON zepto(category);

-- MORE QUERIES

-- 1. Profit Margin % Per Product
SELECT name,
mrp,
discountedSellingPrice,
ROUND(
((mrp - discountedSellingPrice) / mrp) * 100, 2
) AS discount_impact_percentage
FROM zepto
ORDER BY discount_impact_percentage DESC;

-- 2. Top 3 Most Expensive Products in Each Category
SELECT *
FROM (
    SELECT name,
           category,
           mrp,
           RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS rank_in_category
    FROM zepto
) t
WHERE rank_in_category <= 3;

-- 3. Inventory Risk Detection (Low Stock Alert)
SELECT name,
category,
availableQuantity
FROM zepto
WHERE availableQuantity < 10
AND outofStock = FALSE
ORDER BY availableQuantity;

-- 4. Total Inventory Value (Company Level)
SELECT 
SUM(discountedSellingPrice * availableQuantity) 
AS total_inventory_value
FROM zepto;

-- 5. Revenue Distribution by Stock Status
SELECT outofStock,
SUM(discountedSellingPrice * availableQuantity) AS revenue
FROM zepto
GROUP BY outofStock;

-- 6. Category With Highest Price Variation
SELECT category,
ROUND(STDDEV(mrp),2) AS price_variation
FROM zepto
GROUP BY category
ORDER BY price_variation DESC;

-- 7. Most Discounted Product Per Category
SELECT *
FROM (
    SELECT name,
           category,
           discountPercent,
           RANK() OVER (PARTITION BY category 
                        ORDER BY discountPercent DESC) AS rnk
    FROM zepto
) t
WHERE rnk = 1;

-- 8. Correlation Between Discount & Stock
SELECT discountPercent,
AVG(availableQuantity) AS avg_stock
FROM zepto
GROUP BY discountPercent
ORDER BY discountPercent;

-- 9. Create a Sales Segmentation (ABC Analysis)
SELECT name,
CASE 
    WHEN discountedSellingPrice > 1000 THEN 'Premium'
    WHEN discountedSellingPrice BETWEEN 300 AND 1000 THEN 'Mid-Range'
    ELSE 'Budget'
END AS price_segment
FROM zepto;

-- 10. Most Valuable Category (Revenue + Inventory Weight)
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS revenue,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY revenue DESC;

