-- Question

-- Basic
-- Q1. Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS Total_number_of_orders
FROM orders;

-- Q2. Calculate the total revenue generated from pizza sales.

SELECT 
    SUM(order_details.quantity * pizzas.price) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
-- Q3. Identify the highest-priced pizza.

SELECT 
    pizza_types.name AS Pizza_Name,
    pizzas.price AS Highest_Pizza_Price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q4. Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

-- Q5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS Total_Order_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Total_Order_quantity DESC
LIMIT 5;


-- Q6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS Total_Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Total_Quantity DESC;

-- Q7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hours, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY Hours;

-- Q8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS Count_of_pizzzas
FROM
    pizza_types
GROUP BY category;


-- Q9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 2) AS Average_quantity
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS Order_quantity;


-- Q10. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(pizzas.price * order_details.quantity) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;

-- Q11. Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND(SUM(pizzas.price * order_details.quantity) / (SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Revenue DESC;

-- Q12. Analyze the cumulative revenue generated over time.

SELECT order_date, 
SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM
(SELECT orders.order_date,
SUM(pizzas.price*order_details.quantity) AS revenue
FROM order_details JOIN pizzas 
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS total_revenue;


-- Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT category,name,TOTAL_REVENUE,
RANK() OVER(PARTITION BY category ORDER BY TOTAL_REVENUE DESC) AS Rank_No
FROM
(SELECT PIZZA_TYPES.category,PIZZA_TYPES.NAME,
SUM(ORDER_DETAILS.quantity * PIZZAS.price) AS TOTAL_REVENUE
FROM PIZZA_TYPES
JOIN PIZZAS ON PIZZA_TYPES.pizza_type_id = PIZZAS.pizza_type_id
JOIN ORDER_DETAILS ON PIZZAS.pizza_id = ORDER_DETAILS.pizza_id
GROUP BY PIZZA_TYPES.CATEGORY,PIZZA_TYPES.NAME) AS A;
















































































