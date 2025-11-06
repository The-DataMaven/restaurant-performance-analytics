-- =====================================================
-- HOURS VARIANCE ANALYSIS
-- Scheduled vs. Actual Hours Efficiency
-- Author: Jennifer Joseph
-- =====================================================

-- Query 1: Variance by Employee Title/Role
-- Scheduled vs Actual Hours by Job Title
SELECT 
    e.Title as employee_title,
    COUNT(DISTINCT e.Employee_ID) as num_employees,
    SUM(sh.Hours) as scheduled_hours,
    SUM(ah.Hours) as actual_hours,
    SUM(ah.Hours) - SUM(sh.Hours) as variance_hours,
    CASE 
        WHEN SUM(sh.Hours) > 0 
        THEN (SUM(ah.Hours) - SUM(sh.Hours)) * 100.0 / SUM(sh.Hours)
        ELSE 0 
    END as variance_pct,
    -- Cost impact
    (SUM(ah.Hours) - SUM(sh.Hours)) * 15 as variance_cost
FROM scheduled_hours_f sh
JOIN hours_f ah ON sh.Employee_ID = ah.Employee_ID 
    AND sh.Date = ah.Date 
    AND sh.Store_ID = ah.Store_ID
JOIN employee_d e ON sh.Employee_ID = e.Employee_ID
GROUP BY e.Title
ORDER BY variance_hours DESC;

-- Query 2: Daily Variance Trends
-- Variance over time
SELECT 
    CAST(sh.Date AS DATE) as date,
    DATENAME(WEEKDAY, sh.Date) as day_of_week,
    DATEPART(WEEKDAY, sh.Date) as day_num,
    SUM(sh.Hours) as scheduled_hours,
    SUM(ah.Hours) as actual_hours,
    SUM(ah.Hours) - SUM(sh.Hours) as variance_hours,
   ROUND( CASE 
        WHEN SUM(sh.Hours) > 0 
        THEN (SUM(ah.Hours) - SUM(sh.Hours)) * 100.0 / SUM(sh.Hours)
        ELSE 0 
    END,2) as variance_pct
FROM scheduled_hours_f sh
LEFT JOIN hours_f ah ON sh.Employee_ID = ah.Employee_ID 
    AND sh.Date = ah.Date 
    AND sh.Store_ID = ah.Store_ID
GROUP BY CAST(sh.Date AS DATE), DATENAME(WEEKDAY, sh.Date), DATEPART(WEEKDAY, sh.Date)
ORDER BY date;

-- Query 3: Variance by Day of Week
-- Which days have the worst scheduling accuracy?
SELECT 
    DATENAME(WEEKDAY, sh.Date) as day_of_week,
    DATEPART(WEEKDAY, sh.Date) as day_num,
    SUM(sh.Hours) as scheduled_hours,
    SUM(ah.Hours) as actual_hours,
    SUM(ah.Hours) - SUM(sh.Hours) as variance_hours,
    CASE 
        WHEN SUM(sh.Hours) > 0 
        THEN (SUM(ah.Hours) - SUM(sh.Hours)) * 100.0 / SUM(sh.Hours)
        ELSE 0 
    END as variance_pct,
    ABS(SUM(ah.Hours) - SUM(sh.Hours)) as abs_variance_hours
FROM scheduled_hours_f sh
LEFT JOIN hours_f ah ON sh.Employee_ID = ah.Employee_ID 
    AND sh.Date = ah.Date 
    AND sh.Store_ID = ah.Store_ID
GROUP BY DATENAME(WEEKDAY, sh.Date), DATEPART(WEEKDAY, sh.Date)
ORDER BY day_num;

-- Query 4: Individual Employee Variance 
-- Top overworked/underworked employees
SELECT TOP 20
    e.Employee_ID,
    e.Title,
    SUM(sh.Hours) as scheduled_hours,
    SUM(ah.Hours) as actual_hours,
    SUM(ah.Hours) - SUM(sh.Hours) as variance_hours,
    CASE 
        WHEN SUM(sh.Hours) > 0 
        THEN (SUM(ah.Hours) - SUM(sh.Hours)) * 100.0 / SUM(sh.Hours)
        ELSE 0 
    END as variance_pct
FROM scheduled_hours_f sh
LEFT JOIN hours_f ah ON sh.Employee_ID = ah.Employee_ID 
    AND sh.Date = ah.Date 
    AND sh.Store_ID = ah.Store_ID
JOIN employee_d e ON sh.Employee_ID = e.Employee_ID
GROUP BY e.Employee_ID, e.Employee_ID, e.Title
ORDER BY ABS(SUM(ah.Hours) - SUM(sh.Hours)) DESC;


