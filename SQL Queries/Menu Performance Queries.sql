-- Analysis 1: Menu Performance Deep Dive
-- Overall Menu Landscape: Basic menu stats
-- Total items and category

SELECT 
	COUNT(DISTINCT i.item_ID) Total_Items,
	COUNT(DISTINCT i.Category) Total_Category,
	SUM(s.Quantity) Total_Items_Sold,
	COUNT(s.Receipt_ID) Total_Transactions
FROM item_d i
LEFT JOIN sales_f s
ON i.Item_ID = s.Item_ID


-- Total profit by Day
SELECT
	CAST(s.Date AS DATE) Transaction_Date,
	DAY( s.Date) Day,
	DATENAME(WEEKDAY, s.Date) Day_Name,
	COUNT(DISTINCT s.Receipt_ID) Num_Transactions,
	sum(s.Quantity) Items_Sold,
	ROUND(SUM(s.Quantity * i.Profit),1) Total_Profit,
	SUM(s.Quantity * i.Cost) as Total_Cost,
    ROUND(SUM(s.Quantity * (i.Profit + i.Cost)),1) as Total_Revenue
FROM sales_f s
JOIN item_d i
ON s.Item_ID = i.Item_ID
GROUP BY CAST(s.Date AS DATE), DAY( s.Date), DATENAME(WEEKDAY, s.Date)
ORDER BY Transaction_Date

-- Top Category by Profit
SELECT TOP 1
	Category,
	ROUND(SUM(Profit), 2) TotalProfit
FROM item_d
GROUP BY Category
ORDER BY TotalProfit DESC

-- Category Overview
-- WHich category should we focus menu development on?
SELECT
i.Category,
	COUNT(DISTINCT i.Item_ID) Num_Items,
	SUM(s.Quantity) Items_Sold,
	SUM(s.Quantity * i.Profit) Total_Profit,
	AVG(i.Profit) Avg_Profit,
	SUM(s.Quantity * i.Profit) / SUM(s.Quantity) as Profit_Per_Item_Sold
FROM item_d i
JOIN sales_f s
ON i.Item_ID = s.Item_ID
GROUP BY i.Category
ORDER BY Total_Profit DESC

-- Item-Level Analysis (Deep Dive)
-- Which specific items should we promote, reprice, or remove?
SELECT
	i.Item_Name,
	i.Category,
	SUM(s.Quantity) Total_Quantity_Sold,
	i.Profit,
	SUM(s.Quantity * i.Profit) Total_Profit,
	i.Cost,
	SUM(s.Quantity * i.Cost) Total_Cost,
	SUM(s.Quantity * i.Profit) * 100.0 / SUM(SUM(s.Quantity * i.Profit)) OVER() Pct_Total_Profit,
	SUM(s.Quantity) * 100.0 / SUM(SUM(s.Quantity)) OVER() Pct_Total_Sales
FROM item_d i
LEFT JOIN sales_f s
ON i.Item_ID = s.Item_ID
GROUP BY i.Item_Name, i.Category, i.Profit, i.Cost
ORDER BY Total_Profit DESC

-- Item Performance
-- Run this query in SQL Server
SELECT 
    i.Item_Name,
    i.Category,
    SUM(s.Quantity) as Total_Sales,
    i.Profit as Profit_Per_Item,
    SUM(s.Quantity * i.Profit) as Total_Profit,
    i.Cost,
    SUM(s.Quantity * i.Cost) as Total_Cost,
    -- Add quadrant classification
    CASE 
        WHEN SUM(s.Quantity) >= 40 AND i.Profit >= 7 THEN 'Star'
        WHEN SUM(s.Quantity) < 40 AND i.Profit >= 7 THEN 'Hidden Gem'
        WHEN SUM(s.Quantity) >= 40 AND i.Profit < 7 THEN 'Cash Cow'
        ELSE 'Dog'
    END as Quadrant
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Item_Name, i.Category, i.Profit, i.Cost
ORDER BY Total_Profit DESC;


-- Which small group of items brings in the large majority of revenue?
-- Rank items
WITH CTE_ItemMetrics AS (
    SELECT 
        i.Item_Name,
        i.Category,
        SUM(s.Quantity) as Current_Sales,
        AVG(i.Profit) as Profit_Per_Item,
        SUM(s.Quantity * i.Profit) as Current_Profit,
        AVG(SUM(s.Quantity)) OVER () as Avg_Sales,
        AVG(AVG(i.Profit)) OVER () as Avg_Profit
    FROM sales_f s
    JOIN item_d i ON s.Item_ID = i.Item_ID
    GROUP BY i.Item_Name, i.Category
)
SELECT TOP 15
    Item_Name,
    Category,
    Current_Sales,
    Profit_Per_Item,
    Current_Profit,
    (Current_Sales * 2 * Profit_Per_Item) - Current_Profit as Additional_Profit_If_Doubled,
    ((Current_Sales * 2 * Profit_Per_Item) - Current_Profit) * 5 as Monthly_Opportunity
FROM CTE_ItemMetrics
WHERE Profit_Per_Item >= Avg_Profit 
  AND Current_Sales < Avg_Sales
ORDER BY Monthly_Opportunity DESC;


-- Category Profit Distribution
SELECT
i.Category,
COUNT(i.Item_ID) Num_Items,
SUM(s.Quantity * i.Profit) Total_Profit,
AVG(SUM(s.Quantity * i.Profit)) OVER() Avg_Category_Profit,
-- Performance vs Average
CASE 
	WHEN SUM(s.Quantity * i.Profit) > AVG(SUM(s.Quantity * i.Profit)) OVER()
	THEN 'Above Average'
	ELSE 'Below Average'
END Performance
FROM item_d i
JOIN sales_f s
ON i.Item_ID = s.Item_ID
GROUP BY i.Category
ORDER BY Total_Profit DESC

-- Items to Remove (Bottom Performers)
SELECT 
    i.Item_Name,
    i.Category,
    SUM(s.Quantity) as Times_Sold,
    i.Profit,
    SUM(s.Quantity * i.Profit) as Total_Profit
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Item_ID, i.Item_Name, i.Category, i.Profit
HAVING SUM(s.Quantity) < 40  -- Sold less than 15 times in a week
	AND  i.Profit < 5 -- Sold less than $5 in profit in a week
ORDER BY Total_Profit ASC;


-- Items to Promote (High Profit, Underutilized)
SELECT TOP 20
    i.Item_Name,
    i.Category,
    i.Profit as Profit_Per_Item,
    SUM(s.Quantity) as Current_Sales,
    -- Potential profit if sales doubled
    SUM(s.Quantity * i.Profit) * 2 as Potential_Profit,
	SUM(s.Quantity * i.Profit) as Monthly_Opportunity
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
WHERE i.Profit > (SELECT AVG(Profit) FROM item_d)  -- Above average profit
GROUP BY i.Item_ID, i.Item_Name, i.Category, i.Profit
HAVING SUM(s.Quantity) < (
    SELECT AVG(Total_Sold) 
    FROM (
        SELECT SUM(Quantity) as Total_Sold 
        FROM sales_f 
        GROUP BY Item_ID
    ) t
)
ORDER BY i.Profit DESC;

-- top and bottom items
-- Top 10
SELECT TOP 10
    'Top 10' as Segment,
    i.Item_Name,
    i.Category,
    SUM(s.Quantity * i.Profit) as Total_Profit,
    ROW_NUMBER() OVER (ORDER BY SUM(s.Quantity * i.Profit) DESC) as Rank
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Item_Name, i.Category

UNION ALL

-- Bottom 10
SELECT TOP 10
    'Bottom 10' as Segment,
    i.Item_Name,
    i.Category,
    SUM(s.Quantity * i.Profit) as Total_Profit,
    ROW_NUMBER() OVER (ORDER BY SUM(s.Quantity * i.Profit) ASC) as Rank
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Item_Name, i.Category
ORDER BY Segment DESC, Total_Profit DESC;


SELECT * FROM item_d
SELECT * FROM sales_f
