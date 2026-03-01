CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    gender VARCHAR(10),
    state VARCHAR(50),
    signup_date DATE
);
INSERT INTO customers VALUES
(1,'Ayesha Khan','Female','Sindh','2023-01-12'),
(2,'Ali Raza','Male','Punjab','2023-02-05'),
(3,'Fatima Noor','Female','Punjab','2023-03-18'),
(4,'Usman Tariq','Male','KPK','2023-01-25'),
(5,'Hira Malik','Female','Sindh','2023-04-10'),
(6,'Bilal Ahmed','Male','Punjab','2023-02-22'),
(7,'Sana Iqbal','Female','Balochistan','2023-05-01'),
(8,'Hamza Ali','Male','Sindh','2023-03-12'),
(9,'Zainab Shah','Female','Punjab','2023-06-15'),
(10,'Omar Farooq','Male','KPK','2023-07-01'),
(11,'Nida Hassan','Female','Sindh','2023-07-20'),
(12,'Ahmed Rauf','Male','Punjab','2023-08-05'),
(13,'Mahnoor','Female','Punjab','2023-08-18'),
(14,'Taha Khan','Male','Sindh','2023-09-01'),
(15,'Laiba Noor','Female','KPK','2023-09-15');

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);
INSERT INTO categories VALUES
(1,'Electronics'),
(2,'Clothing'),
(3,'Home Appliances'),
(4,'Books'),
(5,'Beauty'),
(6,'Sports');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
INSERT INTO products VALUES
(1,'Laptop',1,120000),
(2,'Mobile Phone',1,80000),
(3,'T-Shirt',2,2000),
(4,'Microwave',3,25000),
(5,'Novel Book',4,1500),
(6,'Face Wash',5,1200),
(7,'Football',6,3000),
(8,'Headphones',1,7000),
(9,'Jeans',2,5000),
(10,'Blender',3,8000),
(11,'Cookbook',4,1800),
(12,'Perfume',5,6000),
(13,'Cricket Bat',6,4500),
(14,'Tablet',1,60000),
(15,'Jacket',2,9000);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders VALUES
(101,1,'2023-09-01','Delivered'),
(102,2,'2023-09-02','Delivered'),
(103,3,'2023-09-03','Cancelled'),
(104,4,'2023-09-05','Delivered'),
(105,5,'2023-09-06','Delivered'),
(106,6,'2023-09-08','Returned'),
(107,7,'2023-09-10','Delivered'),
(108,8,'2023-09-12','Delivered'),
(109,9,'2023-09-14','Delivered'),
(110,10,'2023-09-15','Delivered'),
(111,11,'2023-09-18','Cancelled'),
(112,12,'2023-09-20','Delivered'),
(113,13,'2023-09-22','Delivered'),
(114,14,'2023-09-25','Returned'),
(115,15,'2023-09-28','Delivered');

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO order_items (order_id,product_id,quantity) VALUES
(101,1,1),(101,3,2),
(102,2,1),
(103,5,1),
(104,4,1),
(105,6,2),
(106,7,1),
(107,8,1),
(108,9,2),
(109,10,1),
(110,11,1),
(111,12,1),
(112,13,2),
(113,14,1),
(114,15,1),
(115,1,1),
(115,5,2);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO payments (order_id,payment_method,payment_status) VALUES
(101,'Card','Completed'),
(102,'Cash','Completed'),
(103,'Card','Failed'),
(104,'Card','Completed'),
(105,'Cash','Completed'),
(106,'Card','Refunded'),
(107,'Card','Completed'),
(108,'Cash','Completed'),
(109,'Card','Completed'),
(110,'Card','Completed'),
(111,'Cash','Failed'),
(112,'Card','Completed'),
(113,'Card','Completed'),
(114,'Card','Refunded'),
(115,'Cash','Completed');

SHOW TABLES;
-- Total Revenue
SELECT 
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id;
  -- Top 5 Customers by Spending  
SELECT cu.customer_name, SUM(p.price * oi.quantity) AS total_spent
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY cu.customer_name
ORDER BY total_spent DESC
LIMIT 5;   

-- Most Popular Products
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 2;

-- Revenue by Category
SELECT c.category_name,
       SUM(p.price * oi.quantity) AS category_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE o.order_status = 'Delivered'
GROUP BY c.category_name
ORDER BY category_revenue DESC;

-- Payment Method Summary
SELECT payment_method,
       COUNT(*) AS total_transactions,
       SUM(CASE WHEN payment_status='Completed' THEN 1 ELSE 0 END) AS successful_payments
FROM payments
GROUP BY payment_method;

-- Orders per State
SELECT cu.state, COUNT(DISTINCT o.order_id) AS total_orders
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY cu.state
ORDER BY total_orders DESC;

    
    
    
    
    
    
    
    
    
    