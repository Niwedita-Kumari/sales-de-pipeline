-- 1. TOP 10 HIGH VALUE ORDERS (Business Priority)
SELECT date, region, item_total, customer_id
FROM sales_train 
ORDER BY item_total DESC 
LIMIT 10;

-- 2. DAILY REVENUE BY REGION (Core KPI)
SELECT date, region, SUM(item_total) as daily_revenue
FROM sales_train 
GROUP BY date, region
ORDER BY date DESC, daily_revenue DESC;

-- 3. MONTHLY TREND ANALYSIS (Executive Reporting)
SELECT 
    strftime('%Y-%m', date) as month,
    region,
    SUM(item_total) as monthly_revenue,
    COUNT(*) as order_count
FROM sales_train 
GROUP BY strftime('%Y-%m', date), region
ORDER BY month, region;

-- 4. AVERAGE ORDER VALUE BY REGION (Performance Metric)
SELECT 
    region,
    AVG(item_total) as avg_order_value,
    COUNT(*) as total_orders
FROM sales_train 
GROUP BY region
ORDER BY avg_order_value DESC;

-- 5. HIGH VALUE CUSTOMERS (> $5000 total spend)
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(item_total) as total_spent
FROM sales_train 
GROUP BY customer_id
HAVING total_spent > 5000
ORDER BY total_spent DESC;

-- 6. WEEKLY REVENUE TREND (Data Engineer Pattern)
SELECT 
    strftime('%Y-%W', date) as week_number,
    SUM(item_total) as weekly_revenue
FROM sales_train 
GROUP BY strftime('%Y-%W', date)
ORDER BY week_number;

-- 7. PRODUCT PERFORMANCE RANKING (Business Intelligence)
SELECT 
    product_id,
    COUNT(*) as order_count,
    SUM(item_total) as total_revenue,
    AVG(item_total) as avg_price
FROM sales_train 
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 20;

-- 8. REGIONS WITH ABOVE AVERAGE PERFORMANCE
SELECT region, AVG(item_total) as avg_order
FROM sales_train 
GROUP BY region
HAVING avg_order > (SELECT AVG(item_total) FROM sales_train);

-- 9. DAY-OF-WEEK ANALYSIS (Seasonality Detection)
SELECT 
    strftime('%w', date) as day_of_week,
    AVG(item_total) as avg_daily_sales
FROM sales_train 
GROUP BY strftime('%w', date)
ORDER BY avg_daily_sales DESC;

-- 10. RECENT 7 DAYS VS PREVIOUS 7 DAYS (MoM Comparison)
WITH recent_7days AS (
    SELECT SUM(item_total) as recent_sales
    FROM sales_train 
    WHERE date >= date('now', '-7 days')
),
prev_7days AS (
    SELECT SUM(item_total) as prev_sales
    FROM sales_train 
    WHERE date >= date('now', '-14 days') AND date < date('now', '-7 days')
)
SELECT 
    recent_sales,
    prev_7days.prev_sales,
    (recent_sales * 1.0 / prev_sales - 1) * 100 as growth_pct
FROM recent_7days, prev_7days;

-- 11. TOP PERFORMING DAY (Single Metric Dashboard)
SELECT 
    date,
    SUM(item_total) as daily_total
FROM sales_train 
GROUP BY date
ORDER BY daily_total DESC
LIMIT 1;

-- 12. SLOW MOVING PRODUCTS (< 5 orders)
SELECT 
    product_id,
    COUNT(*) as order_count,
    SUM(item_total) as total_revenue
FROM sales_train 
GROUP BY product_id
HAVING COUNT(*) < 5
ORDER BY total_revenue;

-- 13. CUMULATIVE REVENUE TREND (Financial Reporting)
SELECT 
    date,
    SUM(item_total) OVER (ORDER BY date) as cumulative_revenue,
    SUM(item_total) as daily_revenue
FROM sales_train 
GROUP BY date
ORDER BY date;

-- 14. REGION MARKET SHARE (Competitive Analysis)
SELECT 
    region,
    SUM(item_total) as region_revenue,
    ROUND(SUM(item_total) * 100.0 / (SELECT SUM(item_total) FROM sales_train), 2) as market_share_pct
FROM sales_train 
GROUP BY region
ORDER BY region_revenue DESC;

-- 15. ANOMALY DETECTION (Data Quality Alert)
SELECT 
    date,
    region,
    SUM(item_total) as daily_revenue,
    AVG(SUM(item_total)) OVER (PARTITION BY region) as region_avg,
    CASE 
        WHEN ABS(SUM(item_total) - AVG(SUM(item_total)) OVER (PARTITION BY region)) > 3 * STDDEV(item_total) OVER (PARTITION BY region)
        THEN 'ANOMALY'
        ELSE 'NORMAL'
    END as anomaly_flag
FROM sales_train 
GROUP BY date, region
ORDER BY date DESC;

