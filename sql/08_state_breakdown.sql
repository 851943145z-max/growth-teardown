-- 分州：用户量、配送天数、延迟率、评分、运费占比、人均 GMV
SELECT state,
       COUNT(DISTINCT user_id) AS users,
       COUNT(*) AS orders,
       ROUND(MEDIAN(delivery_days), 1) AS median_delivery_days,
       ROUND(100.0 * AVG(CASE WHEN is_late THEN 1 ELSE 0 END), 1) AS late_pct,
       ROUND(AVG(review_score), 2) AS avg_score,
       ROUND(100.0 * SUM(freight) / SUM(gmv), 1) AS freight_to_price_pct,
       ROUND(SUM(gmv) / COUNT(DISTINCT user_id), 1) AS gmv_per_user
FROM order_fact
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
GROUP BY 1 ORDER BY users DESC;
