-- 有多少用户只买过一次
WITH u AS (SELECT user_id, COUNT(*) AS n FROM user_orders GROUP BY user_id)
SELECT COUNT(*) AS users,
       COUNT(*) FILTER (WHERE n >= 2) AS repeat_users,
       ROUND(100.0 * COUNT(*) FILTER (WHERE n >= 2) / COUNT(*), 2) AS repeat_pct,
       ROUND(100.0 * (SELECT COUNT(*) FROM user_orders WHERE nth > 1) / (SELECT COUNT(*) FROM user_orders), 2) AS repeat_order_share_pct
FROM u;
