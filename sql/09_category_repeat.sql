-- 哪些品类的首单用户更容易回来（首单 ≥ 500 人的品类）
WITH f AS (
  SELECT uo.user_id, uo.ts AS first_ts, ANY_VALUE(COALESCE(t.product_category_name_english, p.product_category_name)) AS category
  FROM user_orders uo
  JOIN order_items oi USING (order_id)
  JOIN products p USING (product_id)
  LEFT JOIN cat_tr t ON t.product_category_name = p.product_category_name
  WHERE uo.nth = 1 AND uo.ts < '2018-03-01'
  GROUP BY 1, 2
), nxt AS (SELECT user_id, ts AS second_ts FROM user_orders WHERE nth = 2)
SELECT category, COUNT(*) AS first_buyers,
       ROUND(100.0 * AVG(CASE WHEN second_ts > first_ts + INTERVAL 1 DAY AND second_ts <= first_ts + INTERVAL 180 DAY THEN 1 ELSE 0 END), 2) AS repeat_180_pct
FROM f LEFT JOIN nxt USING (user_id)
GROUP BY 1 HAVING COUNT(*) >= 500
ORDER BY repeat_180_pct DESC;
