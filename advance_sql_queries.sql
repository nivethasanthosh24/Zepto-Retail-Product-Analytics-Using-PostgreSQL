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