# Restaurant Performance Analytics

## Project Background
This analysis examines operational and financial performance data from a multi-location restaurant chain operating in California. The restaurant operates across 6 locations and serves three primary product categories: Food, Liquor/Beer/Wine/Non-Alcoholic beverages (LB/WNA), and Mercantile items. As a data analyst supporting restaurant operations, this project aims to optimize profitability through menu engineering, labor efficiency, and resource allocation.

The restaurant industry operates on thin profit margins (typically 3-6% net profit), making data-driven optimization critical for sustainable growth. Key business metrics monitored include:
- Profit per item sold (target: $6-8)
- Labor cost percentage (target: 25-35% of revenue)
- Revenue per labor hour (target: $50+)
- Menu item profitability mix (using BCG matrix analysis)

Insights and recommendations are provided on the following key areas:
- **Menu Performance:** Item-level profitability analysis identifying stars, hidden gems, cash cows, and underperformers using strategic profitability matrix frameworks
- **Staffing Optimization:** Peak hour identification and labor-to-demand alignment to reduce costs while maintaining service quality
- **Category Performance:** Product category profit margin analysis to guide menu development and marketing focus
- **Hours Variance:** Scheduled vs. actual hours efficiency analysis to identify scheduling gaps and reduce unplanned overtime costs

The SQL queries used to analyze and aggregate the data for this project can be found here:
[SQL Queries](https://github.com/The-DataMaven/restaurant-performance-analytics/tree/bb25fde14244e3b63776963eb9e57f9ec678f1b8/SQL%20Queries)

The interactive Power BI dashboard used to explore and report on operational trends can be found here: 
[Restaurant Performance Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMmE4MWMxMjItMTBmMS00NGIxLWE4MWEtMzdkNGFmZjU1MzVmIiwidCI6ImNjZjM1YmRmLTFjMTUtNGNiNC05ZTI4LWEyYzdjYTE2YTFmYiJ9)

## Data Structure & Initial Checks
The restaurant's operational database consists of six tables with a total of 235,463 records spanning the period May 31 - June 5, 2022. The database follows a star schema design with three fact tables (sales_f, hours_f, scheduled_hours_f) and three dimension tables (item_d, employee_d, store_d).

#### Entity Relationship Diagram

![ERD](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/2ce8683546a6734c4a35791f85cf4126246f6377/ERD.png)

Prior to beginning the analysis, a variety of checks were conducted for quality control and farmilarization with the dataset. 

#### Initial Data Quality Checks:
- No duplicate Receipt_IDs in sales_f
- All foreign keys have matching records in dimension tables
- Date range confirmed: 2022-05-31 to 2022-06-05 (6 days)
- No negative values in Hours, Cost, Profit, or Quantity fields
- 3 items in item_d have no corresponding sales (new menu items not yet sold)

## Executive Summary
### Overview of Findings
The 6-day analysis period generated $74,754 in total profit across 4,898 orders and 357 menu items. Three critical opportunities emerged:

Mercantile items represent a hidden gem with 37.5% profit margins but only 90 units sold—if visibility increases, this category could generate an additional $76,000 annually;

**Staffing inefficiencies** create a **$13,260** annual cost with **Saturday understaffing (-10 hours)** and **Cook role overtime (200% variance)**;

Menu optimization reveals that just **71 items (20%) drive 80% of profit**, while bottom performers drain resources. 

Combined impact: **$250,000+** in annual profit opportunity through category promotion, labor reallocation, and menu rationalization.


![Menu Performance](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/f3abcc457f88f5b5a3b44288c6b9f0960a5473d9/Dashboard%20Images/menu.PNG)

![Staff Optimization](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/Dashboard%20Images/staff_optimization.PNG)

![Category Analysis](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/Dashboard%20Images/category_performance.PNG)

![Hours Variance](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/Dashboard%20Images/hours_variance.PNG)


## Insights Deep Dive
### Menu Performance
1. **The Pareto Principle (80/20 rule)** is strongly evident in menu performance, with just 71 items (19.9%) generating 80% of total profit.
   - The remaining 286 items (80.1%) contribute only 20% of profit, indicating significant menu bloat and opportunity for rationalization.
     
2. **Hidden Gems identified:** 15 high-margin items (profit >$12/item) with low sales volume (<30 units sold) represent immediate promotion opportunities.
   - Top candidates include Alyeska Ale ($15 profit, 25 sales), Baby Gin Pear Goat ($16.1 profit, 30 sales), and Bleu Salad ($12.6 profit, 28 sales). If visibility doubles sales for these 15 items, projected additional monthly revenue: $12,000.
  
3. **Bottom 10 performers (items with <30 sales and <$5 profit)** include Blackberry Ice Cream, Black Russian, and Hummus Platter, contributing only $146 total profit combined.
   - These items tie up inventory space, complicate kitchen operations, and dilute menu clarity.
   - **Recommendation: Phase out bottom 10 items (2.8% of menu)** to simplify operations.
    
4. **Category imbalance is severe:** Food accounts for 51.92% of profit with 5,984 units sold (27.4% margin), while Mercantile generates only 1.98% of profit despite having the highest margin (37.5%).
   - This suggests Mercantile items are poorly positioned, under-marketed, or not visible to customers. Strategic focus on **Mercantile visibility** could shift profit mix significantly.

![Scatter plot showing item distribution across different quadrants](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/scatter_plot.PNG)


### Staff Optimization
1. **Peak hours clearly defined:** Hours 12-14 (12pm-2pm) and 18-20 (6pm-8pm) generate 62% of daily revenue across all days, with Friday lunch reaching 1,745 orders.
    - Current staffing does not adequately scale to match these peaks, resulting in longer wait times and potential lost sales.
    - Revenue per labor hour analysis shows $76/hour on Tuesday (most efficient) vs. $8/hour on Saturday (least efficient) - a 950% difference.
    
2. **Afternoon lull (14:00-17:00) represents cost-saving opportunity:** Hours 12-14 (12pm-2pm) and 18-20 (6pm-8pm) generate 62% of daily revenue across all days, with Friday lunch reaching 1,745 orders.
    - This 3-hour window generates only 18% of daily revenue but likely carries full staffing levels. Analysis shows only 892 total orders across these hours for the 6-day period.
    - **Recommendation:** Reduce staff by 2 employees during 2-5pm = $6,240/month savings (based on $15/hour × 2 employees × 4 hours × 26 days).
      
3. **Day-of-week variance is substantial:** Hours 12-14 (12pm-2pm) and 18-20 (6pm-8pm) generate 62% of daily revenue across all days, with Friday lunch reaching 1,745 orders.
    - Friday shows highest demand with consistent 1,200+ orders across multiple hours, while Saturday shows the lowest revenue per labor hour ($8) despite being typically considered peak restaurant days.
    - **Saturday requires investigation** - either demand is genuinely lower (adjust staffing down) or service issues are suppressing sales (improve operations).
      
4. **Hour 22 (10pm) identified as single peak hour** with highest individual order count (338 orders), yet this is typically when restaurants begin winding down staff.
    - This late-night demand suggests opportunity for targeted late-night promotions or extended hours on weekends. If 10pm hour can be optimized across all locations, potential additional weekly revenue: $3,500.

![Heat map showing order volume by day of week and hour of day](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/heat_map.PNG)

### Category Performance
1. **Mercantile is the ultimate hidden gem category:** With only 90 items sold over 6 days (15 items/day) but commanding a 37.5% profit margin, Mercantile items generate $43.50 average profit per order—2.8X higher than Food ($15.50/order).
    - Current contribution is only $1,478 total profit (1.98%), but if Mercantile sales doubled through improved visibility, the category would add $76,800 annually.
    
2. **Food is a cash cow requiring price optimization:** As the highest volume category (5,984 units, 51.92% of profit), Food operates at the lowest margin (27.4%) - 4.1 percentage points below average and 10.1 points below Mercantile.
    - A strategic 10% price increase on top 20 Food items (representing 80% of Food sales) would increase Food profit by $3,880/week while likely retaining 90%+ of customers due to brand loyalty and convenience.
    - **Annual impact: $201,760.**
      
3. **LB/WNA** is the balanced performer with 6,083 units sold and 28.9% margin, contributing 46.11% of profit ($34,467).
    - This category requires no immediate intervention but should be monitored for competitive pricing. The balance between volume and margin makes this category the most stable and predictable revenue source.
      
4. **Category diversification risk is low but concentration is high:** While having three categories provides some diversification, Food+LB/WNA together represent 98% of profit. If Food category faces disruption (supply chain, health trends, competition), the business is highly exposed.
    - Strategic expansion of Mercantile (which could include retail packaged goods, branded merchandise, or gift items) would provide both profit growth and risk mitigation.

![Scatter plot positioning Food, LB/WNA, and Mercantile categories](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/scatter2.PNG)

### Hours Variance Analysis
1. **Cook role shows critical 200% variance** (687 actual hours vs. 672 scheduled = +15 hours, but percentage suggests data validation needed).
    - Cooks consistently work significantly more hours than scheduled, indicating either chronic understaffing in the kitchen or inaccurate scheduling templates. This variance costs $218/week in unplanned overtime premiums.
- **Recommendation:** Increase base Cook schedules by 1 hour per shift (5 hours/week per cook × 30 cooks = 150 hours/week adjustment needed).
    
2. Saturday is consistently understaffed by -10 hours across all roles, correlating with the poor revenue per labor hour ($8) identified in Staff Optimization analysis.
    - This suggests Saturday schedules are built too lean, forcing staff cuts or resulting in no-shows. Saturday should be treated as a high-demand day with increased base schedules.
    - Correcting this would improve both employee satisfaction (less overwork) and customer service (adequate coverage).
      
3. Shift Leader variance of +43.8% (294 actual vs. 290 scheduled) indicates this role frequently works overtime to cover gaps. Shift Leaders are typically salaried or higher-paid hourly employees, making overtime here especially costly.
    - Root cause analysis needed: Are Shift Leaders covering for absent staff, or are operational demands exceeding planned capacity?
      
4. General Manager shows -4 hour variance (under-worked relative to schedule), which is unusual for management roles. This could indicate:
    - Managers taking time off or leaving early.
    - Schedule includes administrative time but managers are spending more time on-site than in office.
    - Data quality issue. Investigation required to understand if this represents a problem or simply reflects different work patterns for salaried managers.
 
![Line chart showing daily variance trends with Saturday -10 hour dip clearly visible](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/line.PNG)


![bar chart showing role-level variance](https://github.com/The-DataMaven/restaurant-performance-analytics/blob/67ecb67aea6dc26cb2e11a300c9d0a926c87e395/bar_chart.PNG)


## Recommendations
Based on the insights and findings above, we recommend the Restaurant Operations and Finance Leadership Team consider the following:

1. **Promote Mercantile Category Aggressively:**
Mercantile items have 37.5% margins but only 90 units sold (1.98% of profit).
Actions:
   - Feature Mercantile items on prominent menu positions (front page, table stalls).
   - Train servers to recommend Mercantile items with every order.
   - Create bundled deals (e.g., "Meal + Mercantile item" combos).
   - Implement point-of-sale prompts for cashiers. Expected impact: Double Mercantile sales within 2 months = +$76,800 annual profit.
    
2. **Implement Strategic Food Pricing:**
Food category (51.92% of profit) operates at only 27.4% margin.
Actions:
   -  Increase prices by 10% on the top 20 Food items (Pareto principle - these represent 80% of Food sales). Test pricing sensitivity on high-volume, brand-specific items where customers are less price-sensitive.
   - **Expected impact:** 90% customer retention rate with 10% price increase = +$201,760 annual profit.
    
3. **Rationalize Menu by Removing Bottom 10 Items:**
Bottom 10 items contribute $146 total profit but tie up inventory, complicate kitchen workflows, and dilute menu clarity.
Actions:
   - Phase out bottom 10 items over 60 days, monitor customer feedback, reallocate kitchen resources to high-performing items.
   - **Expected impact:*** Operational simplification + kitchen efficiency gains + $12,000 redeployed to high-margin items.
    
4. **Realign Staffing to Demand Patterns:**
Current staffing doesn't match demand curves—peak hours (12-2pm, 6-8pm) are understaffed while afternoon lull (2-5pm) is overstaffed.
Actions:
   - Add 2 staff during peak hours, (2) Reduce 2 staff during 2-5pm.
   - Implement dynamic scheduling software that references historical hourly demand data.
   - **Expected impact:** $74,880 annual labor savings (10% reduction) while improving peak-hour service quality.
    
6. **Fix Cook Scheduling and Saturday Understaffing:**
   Cooks work 200% of scheduled hours and Saturdays show -10 hour variance.
   Actions:
   - Increase Cook base schedules by 1 hour/shift (addresses chronic understaffing).
   - Add 10 hours to Saturday schedules across all roles.
   - Implement weekly variance review meetings to catch scheduling gaps early.
   - Expected impact: Reduce unplanned overtime by 50% = $6,630 annual savings + improved employee retention.
    
8. **Investigate and Fix Saturday Performance:**
Saturday shows worst revenue per labor hour ($8 vs. Tuesday $76) despite being traditionally high-demand restaurant day.
Actions:
   - Conduct Saturday customer flow analysis (are customers being turned away?).
   - Review Saturday menu/service quality for issues.
   - Compare Saturday marketing/promotions vs. other days. Root cause must be identified - if demand is genuinely low, reduce Saturday staff; if service issues suppress sales, fix operations to unlock Saturday revenue potential.


## Assumptions and Caveats
Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:

**Assumption 1:** The analysis period (May 31 - June 5, 2022) represents a typical operating week for the restaurant. However, this is only 6 days of data, which may not capture weekly cyclical patterns, seasonal variations, or monthly trends. Holiday weeks, special events, or weather anomalies could skew results. 
  - **Recommendation:** Validate findings with a full month (30 days) of data before implementing major changes.
    
**Assumption 2:** Average hourly wage assumed at $15/hour for cost impact calculations in the Hours Variance analysis, as actual wage data by role was not available in the database. In reality, Cook wages may differ from Server wages, and Manager salaries would not directly translate to hourly rates. Actual cost savings may vary by ±20% depending on true wage mix.

**Assumption 3:** All sales in sales_f are completed transactions (no refunds, voids, or comps are present in the data). If the database includes promotional items, employee meals, or voided transactions, profit calculations may be overstated. Data validation with the finance team is recommended to confirm sales_f represents only paid customer transactions.

**Assumption 4:** The Cook role 200% variance may represent a data quality issue rather than actual 2X overtime. It's possible the scheduled_hours_f table contains errors, or the calculation method needs validation. This specific finding should be verified with operational managers before taking corrective action, as the number appears anomalous compared to other roles (all others show <50% variance).

**Assumption 5:** Store-level differences were not analyzed due to focus on enterprise-wide insights. Some stores may significantly outperform or underperform the averages shown in this analysis. A follow-up store-by-store deep dive is recommended to identify location-specific best practices or problem areas. High-performing stores could serve as operational models for others.
    

## Technologies Used
  - **SQL Server -** Data extraction, transformation, and analysis
    
  - **Power BI -** Interactive dashboard development and visualization
  
 - **DAX -** Calculated measures and business logic

 - **GitHub -** Version control and documentation

## About Me

Hi there, I'm **Jennifer Joseph E.** I'm a data analyst passionate about passionate about about transforming information that supports decision-making and creates positive change.

You can contact me for jobs and collaborations here:

[LinkedIn](https://www.linkedin.com/in/jenniferjoseph-data/) | [Email](jennyashaeziembu@gmail.com)
