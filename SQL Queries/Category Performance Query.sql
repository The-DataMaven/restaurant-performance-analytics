-- =====================================================
-- CATEGORY PERFORMANCE ANALYSIS
-- Category Profitability Matrix
-- Author: Jennifer Joseph
-- =====================================================
-- Which menu categories drive the most profit and should we expand or reduce category offerings?

-- Category Profitability Analysis
SELECT 
    i.Category,
    COUNT(DISTINCT s.Receipt_ID) as num_orders,
    SUM(s.Quantity) as items_sold,
    SUM(s.Quantity * i.Cost) as total_cost,
    SUM(s.Quantity * i.Profit) as total_profit,
    AVG(i.Profit) as avg_profit_per_item,
    -- Profit margin percentage
    CASE 
        WHEN SUM(s.Quantity * i.Cost) > 0 
        THEN (SUM(s.Quantity * i.Profit) / (SUM(s.Quantity * i.Cost) + SUM(s.Quantity * i.Profit))) * 100 
        ELSE 0 
    END as profit_margin_pct,
    -- Average order value for this category
    SUM(s.Quantity * i.Profit) / COUNT(DISTINCT s.Receipt_ID) as avg_profit_per_order
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Category
ORDER BY total_profit DESC;


-- Category trends over time (by week)
SELECT 
    i.Category,
    DATENAME(MONTH, s.Date) as month_name,
    MONTH(s.Date) as month_num,
    SUM(s.Quantity) as items_sold,
    SUM(s.Quantity * i.Profit) as total_profit,
    COUNT(DISTINCT s.Receipt_ID) as orders
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Category, DATENAME(MONTH, s.Date), MONTH(s.Date)
ORDER BY i.Category, month_num;

-- Best performing items in each category
SELECT 
    i.Category,
    i.Item_Name,
    SUM(s.Quantity) as items_sold,
    SUM(s.Quantity * i.Profit) as total_profit,
    AVG(i.Profit) as profit_per_item
FROM sales_f s
JOIN item_d i ON s.Item_ID = i.Item_ID
GROUP BY i.Category, i.Item_Name
ORDER BY i.Category, total_profit DESC;