--Purpose of the project--
--The major aim is to gain insight into the sales data of Walmart to understand the different factors that affect sales of the  dfferent branches--

--The data contains 17 columns and 1000 rows--

-- Create database
CREATE DATABASE walmartSales;

USE walmartSales
SELECT * FROM WalmartSalesData

------------------------------Date/Day/Time------------------------------
-- Add day_name column
SELECT DATENAME(WEEKDAY, DATE)
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData 
ADD day_name VARCHAR(20);

UPDATE WalmartSalesData
SET day_name = DATENAME(WEEKDAY, DATE);

select TIME from walmartsalesdata
order by Time asc

alter table walmartsalesdata
alter column time varchar (8)

-- Add time_of_day column
--select time,
--(case
--when 'time' between '10:00:00' and '12:00:00' then 'Morning'
--when 'time' between '12:01:00' and '16:00:00' then 'Afternoon'
--Else 'Evening'
--end)
--as time_of_day
--from WalmartSalesData;

--alter table walmartsalesdata
--add	time_of_day varchar (20)

--update WalmartSalesData
--set time_of_day = (
--case
--when 'time' between '10:00:00' and '12:00:00' then 'Morning'
--when 'time' between '12:01:00' and '16:00:00' then 'Afternoon'
--Else 'Evening'
--end);

--select * from WalmartSalesData

--alter table walmartsalesdata
--drop column time_of_day--

-- Add month_name column
SELECT MONTH(date)
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData 
ADD month_name VARCHAR(10);

UPDATE WalmartSalesData
SET month_name = MONTH(date);
SELECT * FROM WalmartSalesData
------------------------------Generic------------------------------
-- How many unique cities does the data have?
SELECT DISTINCT city
FROM WalmartSalesData;

-- In which city is each branch?
SELECT DISTINCT city, branch
FROM WalmartSalesData;

------------------------------Product------------------------------
--1. How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM WalmartSalesData;

--2. What is the most selling product line
SELECT SUM(quantity) as qty, product_line
FROM WalmartSalesData
GROUP BY product_line
ORDER BY qty DESC;

--3. What is the total revenue by month
SELECT month_name AS month,
SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY month_name 
ORDER BY total_revenue desc;

--4. What is the most common payment method
SELECT payment, Count (payment)as Cnt
FROM WalmartSalesData
GROUP BY payment
ORDER BY Cnt DESC;

--5. What is the most selling product line
SELECT product_line, COUNT (Product_line) as Cnt
FROM WalmartSalesData
GROUP BY product_line
ORDER BY Cnt DESC;

--6. What month had the largest Cost Of Goods Sold?
SELECT month_name AS month, SUM(cogs) AS cogs
FROM WalmartSalesData
GROUP BY month_name 
ORDER BY cogs desc;


--7. What product line had the largest revenue?
SELECT product_line,
SUM(total) as total_revenue
FROM WalmartSalesData
GROUP BY product_line
ORDER BY total_revenue DESC;

--8. What is the city with the largest revenue?
SELECT branch, city,
SUM(total) AS total_revenue
FROM WalmartSalesData
GROUP BY city, branch 
ORDER BY total_revenue desc;

--9. What product line had the largest VAT?
SELECT product_line,
AVG(tax_5) as avg_tax
FROM WalmartSalesData
GROUP BY product_line
ORDER BY avg_tax DESC;

--10. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales-- 
SELECT AVG(quantity) AS avg_qnty
FROM WalmartSalesData;

SELECT product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM WalmartSalesData
GROUP BY product_line;

--11. Which branch sold more products than average product sold?
SELECT branch, 
SUM(quantity) AS qnty
FROM WalmartSalesData
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmartsalesdata);

--12. What is the most common product line by gender
SELECT gender, product_line,
COUNT(gender) AS total_cnt
FROM walmartsalesdata
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

--13. What is the average rating of each product line
SELECT ROUND(AVG(rating), 2) as avg_rating,product_line
FROM walmartsalesdata
GROUP BY product_line
ORDER BY avg_rating DESC;

------------------------------Sales------------------------------
select * from walmartsalesdata

--1. Number of sales made in each time of the day per weekday 
SELECT time,
COUNT(*) AS total_sales
FROM walmartsalesdata
WHERE day_name = 'Sunday'
GROUP BY time
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

--2. Which of the customer types brings the most revenue?
SELECT customer_type,
SUM(total) AS total_revenue
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY total_revenue desc;

--3. Which city has the largest tax/VAT percent?
SELECT city,
ROUND(AVG(tax_5), 2) AS avg_tax_pct
FROM walmartsalesdata
GROUP BY city 
ORDER BY avg_tax_pct DESC;

--4. Which customer type pays the most in VAT?
SELECT customer_type,
AVG(tax_5) AS total_tax
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY total_tax desc;

------------------------------Customer------------------------------
--1. How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM walmartsalesdata;

--2. How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM walmartsalesdata;

--3. What is the most common customer type?
SELECT customer_type,
count(*) as count
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY count DESC;

--4. Which customer type buys the most?
SELECT customer_type,
COUNT(*) as Mx
FROM walmartsalesdata
GROUP BY customer_type
ORDER BY Mx desc;

--5. What is the gender of most of the customers?
SELECT gender,
COUNT(*) as gender_cnt
FROM walmartsalesdata
GROUP BY gender
ORDER BY gender_cnt DESC;

--6. What is the gender distribution per branch?
SELECT gender,
COUNT(*) as gender_cnt
FROM walmartsalesdata
WHERE branch = 'C'
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

--7. Which time of the day do customers give most ratings?
SELECT time,
AVG(rating) AS avg_rating
FROM walmartsalesdata
GROUP BY time
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day alter

--8. Which time of the day do customers give most ratings per branch?
SELECT time,
AVG(rating) AS avg_rating
FROM walmartsalesdata
WHERE branch = 'A'
GROUP BY time
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

--9. Which day fo the week has the best avg ratings?
SELECT day_name,
round (AVG(rating),2 ) AS avg_rating
FROM walmartsalesdata
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?

--10. Which day of the week has the best average ratings per branch?
SELECT day_name,
COUNT(day_name) total_sales
FROM walmartsalesdata
WHERE branch = 'C'
GROUP BY day_name
ORDER BY total_sales DESC;
