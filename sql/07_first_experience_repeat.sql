-- 首单体验决定会不会回来：首单评分 / 是否延迟 与 180 天内复购率
-- 只看 2018-03 前的首单，保证每个人都有 180 天观察期；排除同日拆单
WITH f AS (SELECT user_id, ts AS first_ts, review_score, is_late
           FROM user_orders WHERE nth = 1 AND order_status = 'delivered'
             AND ts < '2018-03-01' AND review_score IS NOT NULL AND is_late IS NOT NULL),
     nxt AS (SELECT user_id, ts AS second_ts FROM user_orders WHERE nth = 2)
SELECT 'score_' || CAST(ROUND(review_score) AS INT) AS segment,
       COUNT(*) AS users,
       ROUND(100.0 * AVG(CASE WHEN second_ts > first_ts + INTERVAL 1 DAY AND second_ts <= first_ts + INTERVAL 180 DAY THEN 1 ELSE 0 END), 2) AS repeat_180_pct
FROM f LEFT JOIN nxt USING (user_id) GROUP BY 1
UNION ALL
SELECT CASE WHEN is_late THEN 'late' ELSE 'on_time' END,
       COUNT(*),
       ROUND(100.0 * AVG(CASE WHEN second_ts > first_ts + INTERVAL 1 DAY AND second_ts <= first_ts + INTERVAL 180 DAY THEN 1 ELSE 0 END), 2)
FROM f LEFT JOIN nxt USING (user_id) GROUP BY 1
ORDER BY 1;
