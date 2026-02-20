-- Create revenue view
CREATE VIEW category_revenue AS
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category;

-- Create index for performance
CREATE INDEX idx_category
ON zepto(category);