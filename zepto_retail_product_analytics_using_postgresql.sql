-- Zepto Retail Product Analytics Using PostgreSQL

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

-- data exploration

-- count of rows
SELECT COUNT (*) FROM zepto;

-- sample data
SELECT * FROM zepto LIMIT 10;

-- null values
SELECT * FROM zepto
WHERE name IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR 
discountPercent IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
availableQuantity IS NULL
OR 
outofStock IS NULL
OR 
quantity IS NULL;

-- different prodcut categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- prodcuts in stock vs out of stock
SELECT outofStock, COUNT(sku_id)
FROM zepto
GROUP BY outofStock;

-- product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;

-- data cleaning

-- product with price = 0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp=0;

-- convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofStock = TRUE and mrp>300
ORDER BY mrp DESC;

-- Q3. Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than rs. 500 and discount is less than 10%.
SELECT  DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 108g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms>=100
ORDER BY price_per_gram;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms, 
CASE WHEN weightInGms < 1000 THEN 'Low'
WHEN weightInGms <5000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto;

-- 08. What is the Total Inventory Weight Per Category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

-- 09. Actual Discount Amount (Business Insight)
SELECT name,
mrp,
discountedSellingPrice,
(mrp - discountedSellingPrice) AS discount_amount
FROM zepto
ORDER BY discount_amount DESC
LIMIT 10;

-- 10. Potential Lost Revenue (Out of Stock Products)
SELECT 
SUM(discountedSellingPrice * quantity) AS potential_lost_revenue
FROM zepto
WHERE outofStock = TRUE;

-- 11. Top 5 Most Valuable Inventory Products
SELECT name,
(discountedSellingPrice * availableQuantity) AS inventory_value
FROM zepto
ORDER BY inventory_value DESC
LIMIT 5;

-- 12. Category Contribution Percentage to Revenue
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS revenue,
ROUND(
100.0 * SUM(discountedSellingPrice * availableQuantity) /
SUM(SUM(discountedSellingPrice * availableQuantity)) OVER(), 2
) AS revenue_percentage
FROM zepto
GROUP BY category
ORDER BY revenue DESC;

-- 13. Detect Overpriced Products (Less than 5% Discount but High MRP)
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 1000 AND discountPercent < 5
ORDER BY mrp DESC;

-- 14. Rank Products by Best Value in Each Category
SELECT *
FROM (
    SELECT name,
    category,
    ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram,
    RANK() OVER (PARTITION BY category 
                 ORDER BY discountedSellingPrice/weightInGms) AS rank_in_category
    FROM zepto
    WHERE weightInGms > 0
) t
WHERE rank_in_category <= 3;

-- 15. Identify Categories with High Out-of-Stock Rate
SELECT category,
ROUND(
100.0 * SUM(CASE WHEN outofStock = TRUE THEN 1 ELSE 0 END) / COUNT(*),
2
) AS outofstock_percentage
FROM zepto
GROUP BY category
ORDER BY outofstock_percentage DESC;

-- 16. Discount Efficiency Score
SELECT name,
discountPercent,
availableQuantity
FROM zepto
WHERE discountPercent > 30
ORDER BY availableQuantity ASC;