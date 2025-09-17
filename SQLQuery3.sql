
USE BlinkitDB;
GO


SELECT * FROM blinkit

--cleaning
UPDATE blinkit
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

UPDATE blinkit
SET Item_Weight = 0
WHERE Item_Weight IS NULL;

SELECT DISTINCT(Item_Fat_Content) FROM blinkit

--Total Sales
SELECT CONCAT(CAST(SUM(Sales)/1000000 AS DECIMAL(10,2) ),'M') AS Total_Sales_Millions 
FROM blinkit

--Low Fat total sales
SELECT CONCAT(CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)),'M') AS LF_Total_Sales 
FROM blinkit
WHERE Item_Fat_Content='Low Fat'

--Average Sales
SELECT CAST(AVG(sales) AS INT) AS Avg_Sales FROM blinkit

--Total no of  Items
SELECT COUNT(*) AS No_Of_Items FROM blinkit

--Average Rating 
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating FROM  blinkit

--1
SELECT Item_Fat_Content,
CONCAT(CAST(sum(Sales)/1000 AS DECIMAL(10,2)),'k') AS Total_Sales,
CAST(AVG(sales) AS INT) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating
FROM blinkit
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC


--2
SELECT  TOP 5 Item_Type,
CAST(sum(Sales) AS DECIMAL(10,2)) AS Total_Sales,
CAST(AVG(sales) AS INT) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating
FROM blinkit
GROUP BY Item_Type
ORDER BY Total_Sales ASC


--3
SELECT 
    Outlet_Location_Type,
    ISNULL([Low Fat], 0) AS Low_Fat,
    ISNULL([Regular], 0) AS Regular
FROM
(
    SELECT 
        Outlet_Location_Type,
        Item_Fat_Content,
        CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--3

SELECT Outlet_Establishment_Year,
CAST(sum(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC

--4

SELECT 
    Outlet_Size,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


--5

SELECT  Outlet_Location_Type,
CAST(sum(Sales) AS DECIMAL(10,2)) AS Total_Sales,
COUNT(*) AS No_Of_Items,
CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
CAST(AVG(sales) AS INT) AS Avg_Sales,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating
FROM blinkit
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales ASC


SELECT  Outlet_Type,
CAST(sum(Sales) AS DECIMAL(10,2)) AS Total_Sales,
COUNT(*) AS No_Of_Items,
CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
CAST(AVG(sales) AS INT) AS Avg_Sales,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating
FROM blinkit
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC




