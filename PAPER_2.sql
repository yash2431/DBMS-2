CREATE DATABASE DBMS_7

-- Create color Table
CREATE TABLE color (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    extra_fee DECIMAL(5,2) DEFAULT 0
);

-- Create customer Table
CREATE TABLE customer (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT FOREIGN KEY REFERENCES color(id)
);

-- Create category Table
CREATE TABLE category (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    parent_id INT FOREIGN KEY REFERENCES category(id) NULL
);

-- Create clothing Table
CREATE TABLE clothing (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    size VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    color_id INT FOREIGN KEY REFERENCES color(id),
    category_id INT FOREIGN KEY REFERENCES category(id)
);

-- Create clothing_order Table
CREATE TABLE clothing_order (
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES customer(id),
    clothing_id INT FOREIGN KEY REFERENCES clothing(id),
    items INT NOT NULL,
    order_date DATE NOT NULL
);

-- Insert Sample Colors
INSERT INTO color (name, extra_fee) VALUES
('Red', 5.00),    -- has extra fee
('Green', 0.00),
('Blue', 0.00),
('Black', 5.00),  -- has extra fee
('White', 0.00);

-- Insert Sample Customers
INSERT INTO customer (first_name, last_name, favorite_color_id) VALUES
('Jay', 'Patel', 1),     -- Favorite is Red
('Dhruv', 'Shah', 2),    -- Favorite is Green
('Amit', 'Verma', 1),    -- Favorite is Red
('Priya', 'Mehta', 3),   -- Favorite is Blue
('Ravi', 'Singh', NULL), -- No favorite color
('Meera', 'Das', 5);     -- Customer with no purchases

-- Insert Sample Categories
INSERT INTO category (name, parent_id) VALUES
('Mens', NULL),          -- Main category
('Womens', NULL),        -- Main category
('T-Shirt', 1),          -- Subcategory of Mens
('Joggers', 1),          -- Subcategory of Mens
('Hoodie', 1),           -- Subcategory of Mens
('T-Shirt', 2),          -- Subcategory of Womens
('Joggers', 2);          -- Subcategory of Womens

-- Insert Sample Clothing
INSERT INTO clothing (name, size, price, color_id, category_id) VALUES
('Basic Tee', 'M', 20.00, 5, 3),        -- White, Mens T-Shirt
('V-Neck Tee', 'L', 25.00, 3, 3),        -- Blue, Mens T-Shirt (for Jay's order)
('Performance Jogger', 'L', 45.00, 4, 4), -- Black, Mens Joggers
('Cuffed Jogger', 'M', 40.00, 2, 4),      -- Green, Mens Joggers
('Graphic Hoodie', 'XL', 60.00, 1, 5),    -- Red, Mens Hoodie
('Womens Basic Tee', 'S', 20.00, 5, 6),   -- White, Womens T-Shirt
('Womens Lounge Jogger', 'M', 50.00, 4, 7); -- Black, Womens Joggers

-- Insert Sample Orders
INSERT INTO clothing_order (customer_id, clothing_id, items, order_date) VALUES
-- Jay's order for T-Shirt after 1st April 2024
(1, 2, 2, '2024-05-15'), -- Jay, V-Neck Tee, Qty 2

-- Order for financial year 2024-25
(2, 4, 1, '2024-06-10'), -- Dhruv, Cuffed Jogger, Qty 1

-- Order of favorite color
(1, 5, 1, '2024-07-01'), -- Jay, Graphic Hoodie (Red), Qty 1. Jay's fav color is Red.

-- Customer who wears XL
(4, 5, 1, '2024-08-01'), -- Priya, Graphic Hoodie (XL), Qty 1

-- Multiple orders for customer totals
(1, 3, 1, '2024-09-05'), -- Jay, Performance Jogger, Qty 1
(2, 7, 1, '2023-11-20'), -- Dhruv, Womens Lounge Jogger, Qty 1
(3, 1, 3, '2024-10-10'); -- Amit, Basic Tee, Qty 3

--Question 1: List the customers whose favorite color is Red or Green and name is Jay or Dhruv.
SELECT CUSTOMER.first_name,COLOR.name
FROM customer JOIN  color
ON customer.favorite_color_id = color.id
WHERE color.name IN ('RED','GREEN') AND CUSTOMER.first_name IN ('JAY','DHRUV')

--Question 2: List the different types of Joggers with their sizes.
SELECT CLOTHING.name,CLOTHING.size
FROM clothing INNER JOIN category
on clothing.category_id = category.id
WHERE category.name = 'JOGGERS'

--Question 3: List the orders of Jay of T-Shirt after 1st April 2024.
SELECT clothing_order.id,customer.first_name,clothing.name,clothing_order.items,clothing_order.order_date
FROM clothing INNER JOIN clothing_order
ON clothing.id = clothing_order.clothing_id
INNER JOIN customer
ON customer.id = clothing_order.customer_id
INNER JOIN category
ON category.id = clothing.category_id
WHERE customer.first_name = 'JAY' AND clothing_order.order_date > '2024-04-01' AND category.name = 'T-SHIRT'

--Question 4: List the customer whose favorite color is charged extra.
SELECT customer.first_name,customer.last_name,color.name,color.extra_fee
FROM customer INNER JOIN color
ON customer.favorite_color_id = color.id
WHERE color.extra_fee > 0
GROUP BY customer.first_name,customer.last_name,color.name,color.extra_fee

--Question 5: List category wise clothing's maximum price, minimum price, average price and number of clothing items.
SELECT category.name,COUNT(clothing.id) AS NUM_ITEMS,
MAX(clothing.price) AS MAX_PRICE,MIN(clothing.price) AS MIN_PRICE,AVG(clothing.price) AS AVG_PRICE
FROM category INNER JOIN clothing
ON category.id = clothing.category_id
GROUP BY category.name

--Question 6: List the customers with no purchases at all.
SELECT customer.first_name,customer.last_name
FROM customer LEFT JOIN  clothing_order
ON customer.id = clothing_order.customer_id
WHERE clothing_order.id IS NULL

--Question 7: List the orders of favorite color with all the details.
SELECT clothing_order.id,customer.first_name,clothing.name,color.name,clothing_order.items,clothing_order.order_date
FROM clothing INNER JOIN clothing_order
ON clothing.id = clothing_order.clothing_id
INNER JOIN customer
ON customer.id = clothing_order.customer_id
INNER JOIN color
ON color.id = clothing.color_id
WHERE color.id =customer.favorite_color_id

--Question 8: List the customers with total purchase value, number of orders and number of items purchased.
SELECT customer.first_name,COUNT(clothing_order.id) AS NUM_ORDERS,
SUM(clothing_order.items) AS NUM_ITEMS,SUM(clothing_order.items*clothing.price) AS TOTAL_PURCHASES
FROM customer INNER JOIN clothing_order
ON customer.id = clothing_order.customer_id
INNER JOIN clothing
ON clothing.id = clothing_order.clothing_id
GROUP BY customer.first_name

--Question 9: List the Clothing item, Size, Order Value and Number of items sold during financial year 2024-25.
SELECT clothing.name,clothing.size,
COUNT(clothing_order.items) AS ITEMS_SOLD,SUM(clothing_order.items*clothing.price) AS ORDER_VALUE
FROM clothing INNER JOIN clothing_order
ON clothing.id = clothing_order.clothing_id
WHERE YEAR(clothing_order.order_date) IN ('2024','2025')
GROUP BY clothing.name,clothing.size

--Question 10: List the customers who wears XL size.
SELECT customer.first_name,customer.last_name
FROM customer INNER JOIN clothing_order
ON customer.id = clothing_order.customer_id
INNER JOIN clothing
ON clothing.id = clothing_order.clothing_id
WHERE clothing.size = 'XL'