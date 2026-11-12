-- 月度订单、GMV、新客与老客
SELECT strftime(date_trunc('month', ts), '%Y-%m') AS month,
       COUNT(*) AS orders,
       ROUND(SUM(gmv)) AS gmv,
       COUNT(*) FILTER (WHERE nth = 1) AS new_customer_orders,
       COUNT(*) FILTER (WHERE nth > 1) AS repeat_orders
FROM user_orders
WHERE ts >= '2017-01-01' AND ts < '2018-09-01'
GROUP BY 1 ORDER BY 1;
