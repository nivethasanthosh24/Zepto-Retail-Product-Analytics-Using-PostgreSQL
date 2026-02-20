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