/*品类表现*/
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(AVG(oi.price), 2) AS avg_price,
    ROUND(SUM(oi.price) * 100.0 / (SELECT SUM(price) FROM order_items), 2) AS sales_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_sales DESC
LIMIT 15;

WITH user_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_cnt
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
      AND o.order_purchase_timestamp IS NOT NULL
      AND o.order_purchase_timestamp != ''
      AND o.order_purchase_timestamp NOT LIKE '0000%'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_cnt >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(SUM(CASE WHEN order_cnt >= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_rate_pct,
    ROUND(AVG(order_cnt), 2) AS avg_orders_per_customer
FROM user_orders;