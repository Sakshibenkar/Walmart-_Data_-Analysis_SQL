CREATE database IF NOT EXISTS salesDatawalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- DATA cleaning
SELECT *
FROM sales;


USE salesdatawalmart;

-- time_of_day
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
    CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
        ELSE 'Evening'
    END
    );
    
-- day_name
SELECT date,
	DAYNAME(date) AS day_name
    FROM sales;
    
    ALTER TABLE sales ADD column day_name VARCHAR (10);
    
    UPDATE sales
    SET day_name = DAYNAME(date);
    
-- month_name
 SELECT date,
        monthname(date) AS month_name
        FROM sales;
   
ALTER TABLE sales ADD COLUMN month_name varchar(10);

UPDATE sales
SET month_name =  monthname(date);
---------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
---------------------------- GENERIC-----------------------------------------------------------------

-- How many unique cities does the?
select 
DISTINCT(city)
FROM sales;

-- In which city is each branch?
select
distinct city,
        branch
FROM sales;
-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales; 

-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
order by qty DESC;

-- What is the total revenue by month
SELECT 
     SUM(total) as total_revenue, 
     month_name
FROM sales
group by month_name
ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;

-- What product line had the largest revenue?
select
SUM(total) AS Revenue,
product_line
FROM sales
GROUP BY product_line
ORDER BY Revenue DESC;

-- What is the city with the largest revenue?
select
      city,
      SUM(total) AS Revenue
FROM sales
GROUP BY city
ORDER BY Revenue DESC;

-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
   product_line, 
CASE
  WHEN quantity > 6 THEN 'Good'
  ELSE 'Bad'
  End  AS Quality
FROM sales;

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);  

-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
distinct (customer_type)
FROM sales;

-- How many unique payment methods does the data have?
SELECT
distinct (payment)
FROM sales;

-- What is the most common customer type?
select customer_type,
count(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT	
gender,
COUNT(*) AS gender_cnt
FROM sales
group by gender
order by gender_cnt DESC;

-- What is the gender distribution per branch?
  SELECT gender,
  count(gender) as gender_cnt
  FROM sales
  WHERE branch = 'A'
  group by Gender
  ORDER BY gender_cnt DESC;
  
  SELECT gender,
  count(gender) as gender_cnt
  FROM sales
  WHERE branch = 'B'
  group by Gender
  ORDER BY gender_cnt DESC;
  
  SELECT gender,
  count(gender) as gender_cnt
  FROM sales
  WHERE branch = 'C'
  group by Gender
  ORDER BY gender_cnt DESC;
  -- In branch 'A' & 'B' count of Male is More than count of Female.
  -- In branch 'C' count of Female is More than count of male.
  
  -- Which time of the day do customers give most ratings?
  SELECT time_of_day ,
  avg(rating) as avg_rating
  FROM sales
  group by time_of_day
  Order by avg_rating desc;
  
  -- Which time of the day do customers give most ratings per branch?
  
  SELECT time_of_day ,
  avg(rating) as avg_rating
  FROM sales
  WHERE branch = 'A'
  group by time_of_day
  Order by avg_rating desc;
  
  SELECT time_of_day ,
  avg(rating) as avg_rating
  FROM sales
  WHERE branch = 'B'
  group by time_of_day
  Order by avg_rating desc;
  
  SELECT time_of_day ,
  avg(rating) as avg_rating
  FROM sales
  WHERE branch = 'C'
  group by time_of_day
  Order by avg_rating desc;
  -- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
 SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
where Branch = 'A'
GROUP BY day_name 
ORDER BY avg_rating DESC;

 SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
where Branch = 'B'
GROUP BY day_name 
ORDER BY avg_rating DESC;

 SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
where Branch = 'C'
GROUP BY day_name 
ORDER BY avg_rating DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT customer_type,
SUM(Total) AS Total_Revenue
FROM sales
GROUP BY customer_type
ORDER BY Total_Revenue DESC;

-- Which city has the largest tax/VAT percent?
SELECT city,
     ROUND(AVG(tax_pct),2) AS avg_tax_pct
FROM sales
GROUP BY City
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type,
ROUND(AVG(tax_pct),2) AS Total_Tax
FROM sales
GROUP BY customer_type
ORDER BY Total_Tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------     













     



  
       
    
    

    
    
    


