-- 延迟送达对评分的影响
SELECT CASE WHEN is_late THEN '延迟送达' ELSE '按时送达' END AS delivery,
       COUNT(*) AS orders,
       ROUND(AVG(review_score), 2) AS avg_score,
       ROUND(100.0 * AVG(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END), 1) AS low_score_pct
FROM order_fact
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL AND review_score IS NOT NULL
GROUP BY 1;
