-- Check missing values in important columns
-- Products
SELECT 
  SUM(productCode IS NULL) AS missing_productCode,
  SUM(productName IS NULL) AS missing_productName,
  SUM(quantityInStock IS NULL) AS missing_quantityInStock,
  SUM(buyPrice IS NULL) AS missing_buyPrice
FROM products;

-- Orders
SELECT 
  SUM(orderNumber IS NULL) AS missing_orderNumber,
  SUM(orderDate IS NULL) AS missing_orderDate,
  SUM(status IS NULL) AS missing_status
FROM orders;

-- Order Details
SELECT 
  SUM(orderNumber IS NULL) AS missing_orderNumber,
  SUM(productCode IS NULL) AS missing_productCode,
  SUM(quantityOrdered IS NULL) AS missing_quantityOrdered
FROM orderdetails;

-- Customers
SELECT 
  SUM(customerNumber IS NULL) AS missing_customerNumber,
  SUM(customerName IS NULL) AS missing_customerName
FROM customers;

-- Payments
SELECT 
  SUM(customerNumber IS NULL) AS missing_customerNumber,
  SUM(amount IS NULL) AS missing_amount
FROM payments;


-- Products with no stock or negative stock
SELECT * FROM products WHERE quantityInStock <= 0;

-- Order details with zero or negative quantity ordered
SELECT * FROM orderdetails WHERE quantityOrdered <= 0;

-- Payments with zero or negative amount
SELECT * FROM payments WHERE amount <= 0;

 -- products never sold
 
SELECT p.productCode, p.productName, p.warehouseCode
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

-- orders with no matching customer

SELECT o.orderNumber, o.customerNumber
FROM orders o
LEFT JOIN customers c ON o.customerNumber = c.customerNumber
WHERE c.customerNumber IS NULL;


-- date issues in orders

SELECT orderNumber, orderDate, shippedDate
FROM orders
WHERE shippedDate IS NOT NULL AND shippedDate < orderDate;

