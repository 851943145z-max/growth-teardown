-- 按巴西五大区汇总：东北部配送最慢、延迟最多
SELECT CASE WHEN state IN ('SP','RJ','MG','ES') THEN '东南' WHEN state IN ('PR','SC','RS') THEN '南部' WHEN state IN ('MA','PI','CE','RN','PB','PE','AL','SE','BA') THEN '东北' WHEN state IN ('AM','RR','AP','PA','TO','RO','AC') THEN '北部' ELSE '中西部' END AS region,
       COUNT(DISTINCT user_id) AS users,
       ROUND(MEDIAN(delivery_days), 1) AS median_delivery_days,
       ROUND(100.0 * AVG(CASE WHEN is_late THEN 1 ELSE 0 END), 1) AS late_pct,
       ROUND(AVG(review_score), 2) AS avg_score,
       ROUND(100.0 * SUM(freight) / SUM(gmv), 1) AS freight_to_price_pct
FROM order_fact
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
GROUP BY 1 ORDER BY users DESC;
