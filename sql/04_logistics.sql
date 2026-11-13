/*整体交付时长与延迟率*/
SELECT
    COUNT(*) AS delivered_orders,
    ROUND(AVG(DATEDIFF(
        STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'),
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    )), 1) AS avg_delivery_days,
    SUM(CASE
        WHEN STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
           > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
        THEN 1 ELSE 0
    END) AS late_orders,
    ROUND(SUM(CASE
        WHEN STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
           > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
        THEN 1 ELSE 0
    END) * 100.0 / COUNT(*), 2) AS late_rate_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date != ''
  AND order_delivered_customer_date NOT LIKE '0000%'
  AND order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date != ''
  AND order_estimated_delivery_date NOT LIKE '0000%'
  AND order_purchase_timestamp IS NOT NULL
  AND order_purchase_timestamp != ''
  AND order_purchase_timestamp NOT LIKE '0000%';
  
  /*延迟交付与评价分数的关联*/
  WITH delivery_reviews AS (
    SELECT
        o.order_id,
        r.review_score,
        CASE
            WHEN STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
               > STR_TO_DATE(o.order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
            THEN 'late' ELSE 'on_time'
        END AS delivery_status
    FROM orders o
    JOIN order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_delivered_customer_date != ''
      AND o.order_delivered_customer_date NOT LIKE '0000%'
      AND o.order_estimated_delivery_date IS NOT NULL
      AND o.order_estimated_delivery_date != ''
      AND o.order_estimated_delivery_date NOT LIKE '0000%'
)
SELECT
    delivery_status,
    COUNT(*) AS orders,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS low_score_pct
FROM delivery_reviews
GROUP BY delivery_status;