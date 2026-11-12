-- 复购用户从首单到第二单隔了多少天
WITH f AS (SELECT user_id, ts FROM user_orders WHERE nth = 1),
     s AS (SELECT user_id, ts FROM user_orders WHERE nth = 2)
SELECT CASE WHEN d = 0 THEN '当天'
            WHEN d <= 30 THEN '1-30天'
            WHEN d <= 90 THEN '31-90天'
            WHEN d <= 180 THEN '91-180天'
            ELSE '180天以上' END AS gap,
       COUNT(*) AS users
FROM (SELECT date_diff('day', f.ts, s.ts) AS d FROM f JOIN s USING (user_id))
GROUP BY 1 ORDER BY MIN(d);
