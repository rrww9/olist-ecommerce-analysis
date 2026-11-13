/*F（频率）几乎全是 1.0，Olist 是一个“一次性购买”平台*/
/*用户 RFM 分层*/
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
      AND o.order_purchase_timestamp IS NOT NULL
      AND o.order_purchase_timestamp != ''
      AND o.order_purchase_timestamp NOT LIKE '0000%'
    GROUP BY c.customer_unique_id, o.order_id, o.order_purchase_timestamp
),
rfm_base AS (
    SELECT
        customer_unique_id,
        DATEDIFF(
            (SELECT MAX(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) FROM customer_orders),
            MAX(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'))
        ) AS recency_days,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(order_value), 2) AS monetary
    FROM customer_orders
    GROUP BY customer_unique_id
),
rfm_scored AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN '重要价值客户'
        WHEN r_score >= 4 AND f_score <= 2 AND m_score >= 4 THEN '重要发展客户'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN '重要保持客户'
        WHEN r_score <= 2 AND f_score <= 2 AND m_score >= 4 THEN '重要挽留客户'
        WHEN r_score >= 4 AND f_score >= 4 AND m_score <= 2 THEN '一般价值客户'
        WHEN r_score >= 4 AND f_score <= 2 AND m_score <= 2 THEN '新客户'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score <= 2 THEN '一般保持客户'
        ELSE '流失客户'
    END AS customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(recency_days), 0) AS avg_recency_days,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(monetary), 2) AS avg_monetary,
    ROUND(SUM(monetary), 2) AS total_monetary
FROM rfm_scored
GROUP BY customer_segment
ORDER BY total_monetary DESC;