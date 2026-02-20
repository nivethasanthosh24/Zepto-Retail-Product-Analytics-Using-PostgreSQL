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