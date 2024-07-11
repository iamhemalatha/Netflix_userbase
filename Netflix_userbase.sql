-- Create the database
CREATE DATABASE Netflix_Users;

-- Select the database
USE Netflix_Users;

-- checking the Number of tables in the database
SHOW TABLES;

-- checking the shape of table
SELECT COUNT(*) AS ROW_COUNT ,
(SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA="Netflix_Users" 
AND TABLE_NAME="netflix")AS COLUMN_COUNT FROM netflix;

-- checking the data type of Each column of table
DESC netflix;

-- count of each datatype 
SELECT DATA_TYPE, COUNT(*) AS count_dtype
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Netflix_Users' 
GROUP BY DATA_TYPE;

-- RENAMING THE COLUMN NAMES THAT ARE HAVING SPACES AND CHANGING THEIR DATA TYPES

ALTER TABLE netflix
CHANGE COLUMN `User ID` User_ID integer;

ALTER TABLE netflix
CHANGE COLUMN `Subscription Type` Subscription_Type VARCHAR(20);

ALTER TABLE netflix
CHANGE COLUMN `Plan Duration` Plan_Duration VARCHAR(20);

ALTER TABLE netflix
CHANGE COLUMN `Monthly Revenue` Monthly_Revenue integer;

ALTER TABLE netflix
CHANGE COLUMN `Join Date` Join_Date DATE;

ALTER TABLE netflix
CHANGE COLUMN `Last Payment Date` Last_Payment_Date DATE;

ALTER TABLE netflix
MODIFY COLUMN Country varchar(20);

ALTER TABLE netflix
MODIFY COLUMN Gender varchar(20);

ALTER TABLE netflix
MODIFY COLUMN Device varchar(20);

-- Convert Date columns from string format '%d-%m-%y' to a DATE type

SET SQL_SAFE_UPDATES=0;
UPDATE netflix
SET `Join Date` = STR_TO_DATE(`Join Date`, '%d-%m-%y')
WHERE `Join Date` LIKE '%-%';
SET SQL_SAFE_UPDATES=1;

SET SQL_SAFE_UPDATES=0;
UPDATE netflix
SET `Last Payment Date` = STR_TO_DATE(`Last Payment Date`, '%d-%m-%y')
WHERE `Last Payment Date` LIKE '%-%';
SET SQL_SAFE_UPDATES=1;

-- Display the structure of the 'netflix' table to review column names, data types, and constraints
DESC netflix;

-- Retrieve all records and columns from the 'netflix' table 
SELECT * FROM netflix;

-- EXTRACTING YEAR FROM JOIN DATE COLUMN
ALTER TABLE netflix ADD COLUMN Join_Year VARCHAR(20);
SET SQL_SAFE_UPDATES=0;
UPDATE netflix SET Join_Year = Year(Join_Date);
SET SQL_SAFE_UPDATES=1;

-- EXTRACTING MONTH FROM JOIN DATE COLUMN
ALTER TABLE netflix ADD COLUMN Join_Month VARCHAR(20);
SET SQL_SAFE_UPDATES=0;
UPDATE netflix SET Join_Month = monthname(Join_Date);
SET SQL_SAFE_UPDATES=1;

-- EXTRACTING DAY FROM JOIN DATE COLUMN
ALTER TABLE netflix ADD COLUMN Join_Day VARCHAR(20);
SET SQL_SAFE_UPDATES=0;
UPDATE netflix SET Join_Day = dayname(Join_Date);
SET SQL_SAFE_UPDATES=1;

-- EXTRACTING YEAR FROM LAST PAYMENT DATE COLUMN
ALTER TABLE netflix ADD COLUMN Last_Payment_Day VARCHAR(20);
SET SQL_SAFE_UPDATES=0;
UPDATE netflix SET Last_Payment_Day = dayname(Last_Payment_Date);
SET SQL_SAFE_UPDATES=1;

-- Calculate the difference in days between 'Last_Payment_Date' and 'Join_Date' and update 'Date_diff'
ALTER TABLE netflix ADD COLUMN Date_diff integer;
SET SQL_SAFE_UPDATES=0;
UPDATE netflix SET Date_diff = datediff(Last_Payment_Date,Join_Date);
SET SQL_SAFE_UPDATES=1;

-- Retrieve all records and columns from the 'netflix' table 
SELECT * FROM netflix;

-- Finding the distinct values,count and it's percentage of each column in Netflix uesrbase Table
SELECT count(distinct User_ID) FROM netflix;

SELECT Subscription_Type, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Subscription_Type
ORDER BY COUNT DESC;

SELECT Monthly_Revenue, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Monthly_Revenue
ORDER BY COUNT DESC;

SELECT Country, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Country
ORDER BY COUNT DESC;

SELECT Age, COUNT(*) AS COUNT FROM netflix
GROUP BY Age
ORDER BY COUNT DESC;

SELECT Gender, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Gender
ORDER BY COUNT DESC;

SELECT Device, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Device
ORDER BY COUNT DESC;

SELECT Plan_Duration, COUNT(*) AS COUNT FROM netflix
GROUP BY Plan_Duration
ORDER BY COUNT DESC;

-- Business Questions To Answer:
select * from netflix;

-- 1. Who are netflix users?
SELECT Country,sum(Monthly_Revenue) as total_Revenue, 
round((sum(Monthly_Revenue)/(SELECT SUM(Monthly_Revenue) FROM netflix))*100,2) as Revenue_Percentage
FROM netflix
GROUP BY Country
ORDER BY Revenue_Percentage DESC;

-- 2. How are Netflix's users consuming content?
SELECT Device, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Device
ORDER BY COUNT DESC;

-- 3.What are the subscription habits of our users?
SELECT Subscription_Type, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
FROM netflix
GROUP BY Subscription_Type
ORDER BY COUNT DESC;

-- 4. Calculate the count and percentage of users who joined in each year
SELECT Join_Year, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
from netflix
GROUP BY Join_Year;

-- 5.Calculate the count and percentage of users who joined in each month of 2021
SELECT Join_Month, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
from netflix where Join_Year='2021'
GROUP BY Join_Month
ORDER BY COUNT DESC;

-- 6.Calculate the count and percentage of users who joined in each month of 2022
SELECT Join_Month, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
from netflix where Join_Year='2022'
GROUP BY Join_Month
ORDER BY COUNT DESC;

-- 7.Calculate the count and percentage of users who joined in each month of 2023
SELECT Join_Month, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
from netflix where Join_Year='2023'
GROUP BY Join_Month
ORDER BY COUNT DESC;

-- 8.Calculate the count and percentage of users who joined on each day
SELECT Join_Day, COUNT(*) AS COUNT,
concat(round((COUNT(*) / (SELECT COUNT(*) FROM netflix) * 100),2),"%") AS Percentage
from netflix
GROUP BY Join_Day
ORDER BY COUNT DESC;

-- 9.What is the churn rate?
SELECT count(Date_diff)/(SELECT Count(Date_diff) from Netflix) as Churn_Rate
 from Netflix
Where Date_diff<30 ;

-- 10.what is male and female count in top 3 user Countries
SELECT Gender, 
SUM(CASE WHEN Country="United States" THEN 1 ELSE 0 END) AS United_States,
SUM(CASE WHEN Country="Spain" THEN 1 ELSE 0 END) AS Spain,
SUM(CASE WHEN Country="Canada" THEN 1 ELSE 0 END) AS Canada
From netflix
GROUP BY Gender;

-- 11.Calculate the total revenue by Subscription Type and its percentage of the overall revenue
SELECT Subscription_Type,Sum(Monthly_Revenue) as Total_Revenue,
concat(round(Sum(Monthly_Revenue) / (SELECT Sum(Monthly_Revenue) FROM netflix) * 100,2),"%") AS Percentage
FROM netflix
GROUP BY Subscription_Type
ORDER BY Total_Revenue desc;

-- 12. Calculate the total revenue by Gender and its percentage of the overall revenue
SELECT Gender,Sum(Monthly_Revenue) as Total_Revenue,
concat(round(Sum(Monthly_Revenue) / (SELECT Sum(Monthly_Revenue) FROM netflix) * 100,2),"%") AS Percentage
FROM netflix
GROUP BY Gender
ORDER BY Total_Revenue desc;

-- 13.Calculate the Sum of Monthly revenue 
Select SUM(Monthly_Revenue) as Total_Revenue FROM netflix

-- 14.Calculate the total revenue by device and its percentage of the overall revenue
SELECT Device,Sum(Monthly_Revenue) as Total_Revenue,
concat(round(Sum(Monthly_Revenue) / (SELECT Sum(Monthly_Revenue) FROM netflix) * 100,2),"%") AS Percentage
FROM netflix
GROUP BY Device
ORDER BY Total_Revenue desc;

-- 15.Calculate the number of users within specified age ranges and return the results
SELECT 
    SUM(CASE WHEN AGE >= 25 AND AGE < 30 THEN 1 ELSE 0 END) AS `ABOVE 25 AND BELOW 30`,
    SUM(CASE WHEN AGE >= 30 AND AGE < 35 THEN 1 ELSE 0 END) AS `ABOVE 30 AND BELOW 35`,
    SUM(CASE WHEN AGE >= 35 AND AGE < 40 THEN 1 ELSE 0 END) AS `ABOVE 35 AND BELOW 40`,
    SUM(CASE WHEN AGE >= 40 AND AGE < 45 THEN 1 ELSE 0 END) AS `ABOVE 40 AND BELOW 45`,
    SUM(CASE WHEN AGE >= 45 AND AGE < 50 THEN 1 ELSE 0 END) AS `ABOVE 45 AND BELOW 50`,
    SUM(CASE WHEN AGE >= 50 AND AGE < 55 THEN 1 ELSE 0 END) AS `ABOVE 50 AND BELOW 55`
FROM netflix;

