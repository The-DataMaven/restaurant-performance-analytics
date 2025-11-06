-- =====================================================
-- STAFF OPTIMIZATION ANALYSIS
-- Peak Hours & Labor Efficiency
-- Author: Jennifer Joseph
-- =====================================================


-- Q1. Sales by hour and day of week
SELECT 
    CAST(s.Date AS DATE) AS date,
    DATENAME(WEEKDAY, s.Date) AS day_of_week,
    DATEPART(WEEKDAY, s.Date) AS day_num,
    DATEPART(HOUR, s.Date) AS hour_of_day,
    COUNT(DISTINCT s.Receipt_ID) AS num_orders,
    SUM(s.Quantity) as total_items_sold,
    SUM(s.Quantity * i.Profit) AS total_profit,
    AVG(s.Quantity * i.Profit) AS avg_order_value
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY CAST(s.Date AS DATE), DATENAME(WEEKDAY, s.Date), DATEPART(WEEKDAY, s.Date), DATEPART(HOUR, s.Date)
ORDER BY date, hour_of_day;

-- Q2. Daily Revenue efficiency per labor hour
SELECT 
    CAST(h.Date AS DATE) AS date,
    DATENAME(WEEKDAY, h.Date) AS day_of_week,
    DATEPART(WEEKDAY, h.Date) AS day_num,
    SUM(h.Hours) as total_labor_hours,
    COUNT(DISTINCT s.Receipt_ID) AS num_orders,
    SUM(s.Quantity * i.Profit) AS total_revenue,
    CASE 
        WHEN SUM(h.Hours) > 0 
        THEN SUM(s.Quantity * i.Profit) / SUM(h.Hours) 
        ELSE 0 
    END AS revenue_per_labor_hour
FROM hours_f h
LEFT JOIN sales_f s ON CAST(h.Date AS DATE) = CAST(s.Date AS DATE) AND h.Store_ID = s.Store_ID
LEFT JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY CAST(h.Date AS DATE), DATENAME(WEEKDAY, h.Date), DATEPART(WEEKDAY, h.Date)
HAVING SUM(h.Hours) > 0
ORDER BY date;

-- Q3. Hourly staffing levels to demand
SELECT 
    DATEPART(HOUR, s.Date) AS hour_of_day,
    COUNT(DISTINCT s.Receipt_ID) AS total_orders,
    SUM(s.Quantity) AS total_items,
    SUM(s.Quantity * i.Profit) AS total_revenue,
    AVG(s.Quantity * i.Profit) AS avg_order_value,
    -- percentage of daily orders
    COUNT(DISTINCT s.Receipt_ID) * 100.0 / 
        (SELECT COUNT(DISTINCT Receipt_ID) FROM sales_f) AS pct_of_daily_orders
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY DATEPART(HOUR, s.Date)
ORDER BY hour_of_day;

-- Q4. Day of week performance
-- Which days are busiest?
SELECT 
    DATENAME(WEEKDAY, s.Date) AS day_of_week,
    DATEPART(WEEKDAY, s.Date) AS day_num,
    COUNT(DISTINCT s.Receipt_ID) AS num_orders,
    SUM(s.Quantity * i.Profit) AS total_revenue,
    AVG(s.Quantity * i.Profit) AS avg_order_value,
    -- Add labor hours
    (SELECT SUM(h.Hours) 
     FROM hours_f h 
     WHERE DATENAME(WEEKDAY, h.Date) = DATENAME(WEEKDAY, s.Date)
    ) AS total_labor_hours,
    -- Calculating efficiency
    CASE 
        WHEN (SELECT SUM(h.Hours) FROM hours_f h WHERE DATENAME(WEEKDAY, h.Date) = DATENAME(WEEKDAY, s.Date)) > 0
        THEN SUM(s.Quantity * i.Profit) / (SELECT SUM(h.Hours) FROM hours_f h WHERE DATENAME(WEEKDAY, h.Date) = DATENAME(WEEKDAY, s.Date))
        ELSE 0
    END AS revenue_per_labor_hour
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY DATENAME(WEEKDAY, s.Date), DATEPART(WEEKDAY, s.Date)
ORDER BY day_num;



-- Hourly pattern by day of week
SELECT 
    DATENAME(WEEKDAY, s.Date) AS day_of_week,
    DATEPART(WEEKDAY, s.Date) AS day_num,
    DATEPART(HOUR, s.Date) AS hour_of_day,
    COUNT(DISTINCT s.Receipt_ID) AS num_orders,
    SUM(s.Quantity) AS total_items_sold,
    SUM(s.Quantity * i.Profit) AS total_profit
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY DATENAME(WEEKDAY, s.Date), DATEPART(WEEKDAY, s.Date), DATEPART(HOUR, s.Date)
ORDER BY day_num, hour_of_day;
