
-- 1) Best-selling products (include products with zero sales)

SELECT p.productCode, p.productName,
       COALESCE(SUM(od.quantityOrdered), 0) AS totalSold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY totalSold DESC;

-- 2) Slow-moving products (threshold = 10 units sold)

SELECT p.productCode, p.productName,
       COALESCE(SUM(od.quantityOrdered), 0) AS totalSold,
       p.quantityInStock, p.warehouseCode
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock, p.warehouseCode
HAVING totalSold < 10
ORDER BY totalSold ASC;

-- 3) Products that have never been sold (zero sales)

SELECT p.productCode, p.productName, p.warehouseCode, p.quantityInStock
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL
ORDER BY p.warehouseCode, p.productCode;

-- 4) Total stock per warehouse

SELECT p.warehouseCode, COUNT(p.productCode) AS numProducts, SUM(p.quantityInStock) AS totalStock
FROM products p
GROUP BY p.warehouseCode
ORDER BY totalStock ASC;

-- 5) Sales (quantity ordered) per warehouse

SELECT p.warehouseCode,
       COALESCE(SUM(od.quantityOrdered), 0) AS totalSold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.warehouseCode
ORDER BY totalSold ASC;

-- 6) Price vs Sales (to observe whether lower price -> more sales)

SELECT p.productCode, p.productName, p.buyPrice,
       COALESCE(SUM(od.quantityOrdered), 0) AS totalSold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.buyPrice
ORDER BY p.buyPrice ASC, totalSold DESC;

-- 7) What-if: Reduce each product's quantityInStock by 5% (rounded)

SELECT productCode, productName, quantityInStock,
       ROUND(quantityInStock * 0.95) AS qty_after_5pct_reduction
FROM products
ORDER BY quantityInStock DESC;

-- 8) Detailed listing for Warehouse D (candidate for closure)

SELECT productCode, productName, quantityInStock
FROM products
WHERE warehouseCode = 'D'
ORDER BY quantityInStock DESC;

-- 9) Detailed listing for Warehouse B (example: contains Toyota Supra with zero sales)

SELECT p.productCode, p.productName, p.warehouseCode, p.quantityInStock,
       COALESCE(SUM(od.quantityOrdered), 0) AS totalSold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE p.warehouseCode = 'B'
GROUP BY p.productCode, p.productName, p.warehouseCode, p.quantityInStock
ORDER BY totalSold DESC;

/* =====================================================================
   STEP 5 — CONCLUSION & RECOMMENDATIONS
   =====================================================================
Conclusion:
- Warehouse D sells the least and moves less stock, so it’s the best option to close.
- Warehouse B sells the most but has unsold items like the Toyota Supra.
- Cheap products are not always best sellers; customers care more about product type.

Recommendations:
1) Close Warehouse D and move its stock to other warehouses with space.
2) Remove or promote unsold products (e.g., Toyota Supra in Warehouse B).
3) Focus on stocking products that sell well instead of low-demand items.
4) After closing D, check that customers still receive orders on time.
*/

-- End of file.