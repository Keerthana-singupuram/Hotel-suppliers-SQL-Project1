-- 1. Calculate which meal has highest price.
SELECT meal_name AS Meal, MAX(price) AS Price
FROM meals
GROUP BY meal_name
LIMIT 1;

-- 2.Calculate total price of the items of cold or hot.
SELECT hot_cold AS Item, ROUND(SUM(price),2) AS Total_price
FROM meals
GROUP BY hot_cold;

-- 3.Calculate total number of orders received for each meal type. 
SELECT meal_type AS Meal, COUNT(meal_name) No_of_orders
FROM meal_types
LEFT JOIN meals
ON meal_types.id = meals.meal_type_id
GROUP BY meal_type
ORDER BY No_of_orders DESC;

-- 4.Calculate which city is spending a highest of monthly budget on meals.
SELECT city, SUM(monthly_budget) AS Budget
FROM cities
LEFT JOIN members
ON cities.id = members.city_id
GROUP BY city
LIMIT 1;

-- 5.Calculate which gender type is spending most in meals.
SELECT sex AS Sex,COUNT(Sex) AS Count,SUM(monthly_budget) AS Budget
FROM members
GROUP BY sex;

-- 6.Give the details of the person who is spending the highest for meals.
SELECT first_name,sex,email, monthly_budget,city
FROM members
LEFT JOIN cities
ON members.city_id = cities.id
WHERE monthly_budget = ( 
			SELECT MAX(monthly_budget)
            FROM members
)
ORDER BY monthly_budget DESC;

-- 7.Find the details of month wise totals of orders and meals.
SELECT year,month, SUM(order_count) AS orders, SUM(meals_count) AS meals
FROM monthly_member_totals
GROUP BY year, month;

-- 8.Which city has highest commision?
SELECT city, ROUND(sum(commission),2) AS commission
FROM monthly_member_totals
GROUP BY city
ORDER BY commission DESC
LIMIT 1;

-- 9.Which gender type has highest negative balance?
SELECT sex, ROUND(SUM(balance),2) AS Balance
FROM monthly_member_totals
GROUP BY sex
ORDER BY Balance;

-- 10.List the top 10 mail contacts of customers from 'Herzelia' city with negative balance.
SELECT email, ROUND(SUM(balance),2) AS Balance
FROM monthly_member_totals
WHERE city = 'Herzelia'
GROUP BY email,city
ORDER BY Balance
LIMIT 10;

-- 11. Find on which day of the month we have received maximum number of orders.
SELECT DAY(date) AS Day, ROUND(SUM(total_order),2) AS Total_order
FROM orders
GROUP BY Day
ORDER BY Total_order
LIMIT 1;

-- 12.Which restaurant type has highest income percentage and from which city?
SELECT restaurant_type AS Restaurant_type, ROUND(SUM(income_persentage)*100,0) AS Income_percentage
FROM restaurant_types
LEFT JOIN restaurants
ON restaurant_types.id = restaurants.restaurant_type_id
GROUP BY restaurant_type
ORDER BY Income_percentage DESC;

-- 13.Join required data to create an insightful table regarding meals and items.
SELECT meal_type AS MealType, hot_cold AS ItemType, price AS Price, income_persentage*100 AS IncomePercentage,city AS City, serve_type AS ServeType
FROM meal_types
LEFT JOIN meals
ON meal_types.id = meals.meal_type_id
LEFT JOIN serve_types
ON meals.serve_type_id = serve_types.id
LEFT JOIN restaurants
ON meals.restaurant_id = restaurants.id
LEFT JOIN cities
ON restaurants.city_id = cities.id;

-- 14. Join required data to create an insightful table regarding members and their interest towards meals.
SELECT members.id AS ID, members.first_name,members.surname,members.sex AS Sex,cities.city AS City, members.email,members.monthly_budget AS Monthly_Budget,
	   restaurant_name AS Restaurant_Name, restaurant_type AS Restaurant_Type , year AS Year, month AS Month, order_count, meals_count, total_expense, ROUND(balance,2) AS Balance,
       ROUND(commission,2) AS Commission,date AS Date, hour AS Time
FROM members
LEFT JOIN cities
ON members.city_id = cities.id
LEFT JOIN restaurants 
ON cities.id = restaurants.city_id
LEFT JOIN restaurant_types
ON restaurants.restaurant_type_id = restaurant_types.id
LEFT JOIN orders
ON members.id = orders.member_id
LEFT JOIN monthly_member_totals
ON members.id = monthly_member_totals.member_id;