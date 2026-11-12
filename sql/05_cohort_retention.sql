-- 月度新客 cohort：首单后 30/90/180 天内再次下单的比例
-- 只看有完整 180 天观察期的 cohort（2017-01 至 2018-02）
WITH f AS (SELECT user_id, ts AS first_ts FROM user_orders WHERE nth = 1),
     nxt AS (SELECT user_id, MIN(ts) AS second_ts FROM user_orders WHERE nth = 2 GROUP BY user_id)
SELECT strftime(date_trunc('month', first_ts), '%Y-%m') AS cohort,
       COUNT(*) AS new_users,
       ROUND(100.0 * AVG(CASE WHEN second_ts <= first_ts + INTERVAL 30 DAY  AND second_ts > first_ts + INTERVAL 1 DAY THEN 1 ELSE 0 END), 2) AS r30,
       ROUND(100.0 * AVG(CASE WHEN second_ts <= first_ts + INTERVAL 90 DAY  AND second_ts > first_ts + INTERVAL 1 DAY THEN 1 ELSE 0 END), 2) AS r90,
       ROUND(100.0 * AVG(CASE WHEN second_ts <= first_ts + INTERVAL 180 DAY AND second_ts > first_ts + INTERVAL 1 DAY THEN 1 ELSE 0 END), 2) AS r180
FROM f LEFT JOIN nxt USING (user_id)
WHERE first_ts >= '2017-01-01' AND first_ts < '2018-03-01'
GROUP BY 1 ORDER BY 1;
