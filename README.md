# ITC 6050 — Week 3 Lab

## SQL vs. NoSQL — The Same Questions, Two Languages

## What we built
Five analytical SQL queries against the e-commerce schema from Week 2
(10K customers / 1K products / 100K orders / 500K items).

## Step 1 — Five analytical queries in SQL

### Q1 — Monthly revenue trend
Groups orders by month using `date_trunc` and sums revenue.
Shows how business revenue evolves over time.

### Q2 — Top 10 products by revenue
Joins `order_item` with `product` and aggregates quantity × price.
Identifies best-selling products across all time.

### Q3 — Average order value by status
Groups orders by status and computes count, average, and median total.
The median uses `PERCENTILE_CONT(0.5)` to handle skewed data honestly.

### Q4 — Dormant customers
Left joins customers with orders and uses HAVING to find customers
whose last order was more than 90 days ago (or never ordered at all).

### Q5 — Top customers by lifetime spend (Window Functions)
Uses `RANK()` to rank customers by total spend and `LAG()` to compute
the gap to the customer ranked one above. Window functions operate
across the full result set before limiting to top 20.

## Concept Checks

### Q3: AVG vs PERCENTILE_CONT(0.5)
AVG() returns the arithmetic mean and is sensitive to outliers — one very 
large order can pull it up significantly. PERCENTILE_CONT(0.5) returns the 
median, which is more honest for skewed data because it represents the 
"middle" value regardless of extremes.

### Q5: Why window functions instead of ORDER BY ... LIMIT 20?
ORDER BY ... LIMIT 20 only returns the top 20 rows but cannot compute values 
that depend on the relative position of rows (like rank or gap to previous). 
Window functions like RANK() and LAG() operate across the full result set 
before limiting, allowing us to compare each row against others.

