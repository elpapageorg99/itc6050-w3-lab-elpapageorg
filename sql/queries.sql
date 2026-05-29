SET search_path TO shop;

-- Q1 — Monthly revenue trend (GROUP BY + date_trunc)

select date_trunc('month', order_date) as month,
count(order_id) as orders,
sum(total) as revenue
from orders
group by date_trunc('month', order_date);

-- Q2 — Top 10 products by revenue (JOIN + aggregation)
select p.name as product_name,
SUM(oi.quantity) as total_qty,
SUM(oi.quantity * unit_price_at_sale) as revenue
from order_item oi
join product p on oi.product_id = p.product_id
group by p."name"
order by REVENUE desc
limit 10;

-- Q3 — Average order value by status (simple aggregation, but watch the gotcha)

select count(o.order_id), avg(o.total), PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total) as median
from orders o 
group by o.status;

-- Q4 — Dormant customers (LEFT JOIN + filter on aggregate)
SELECT 
    c.customer_id, 
    c.email, 
    MAX(o.order_date) as last_order_date, 
    (CURRENT_DATE - MAX(o.order_date)::DATE)::INTEGER as days_dormant
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.email
HAVING MAX(o.order_date) < CURRENT_DATE - INTERVAL '90 days'
    OR MAX(o.order_date) IS NULL
ORDER BY days_dormant DESC;

-- Q5 — Top customers by lifetime spend, ranked (WINDOW FUNCTION)
SELECT
    RANK() OVER (ORDER BY SUM(o.total) DESC) as rank,
    c.email,
    SUM(o.total) as lifetime_spend,
    SUM(o.total) - LAG(SUM(o.total)) OVER (ORDER BY SUM(o.total) DESC) as gap_to_previous
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.email
ORDER BY rank
LIMIT 20;