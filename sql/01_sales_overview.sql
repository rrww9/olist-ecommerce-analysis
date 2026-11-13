/*查询1：整体 KPI（总订单量、总 GMV、平均客单价*/
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_gmv,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');

/*查询2：月度 GMV 与订单量趋势*/
SELECT
    SUBSTRING(o.order_purchase_timestamp, 1, 7) AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS gmv
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
  AND o.order_purchase_timestamp != ''
  AND o.order_purchase_timestamp NOT LIKE '0000%'
  AND o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY SUBSTRING(o.order_purchase_timestamp, 1, 7)
ORDER BY month;

/*查询3：订单状态分布*/
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS pct
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;