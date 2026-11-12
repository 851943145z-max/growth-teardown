-- Cookie Cats A/B 实验：第一道关卡门槛放在第 30 关（对照）还是第 40 关（实验）
SELECT version,
       COUNT(*) AS players,
       ROUND(100.0 * AVG(CAST(retention_1 AS INT)), 2) AS d1_retention_pct,
       ROUND(100.0 * AVG(CAST(retention_7 AS INT)), 2) AS d7_retention_pct,
       MEDIAN(sum_gamerounds) AS median_rounds,
       ROUND(100.0 * AVG(CASE WHEN sum_gamerounds >= 30 THEN 1 ELSE 0 END), 2) AS reached_30_pct,
       ROUND(100.0 * AVG(CASE WHEN sum_gamerounds >= 40 THEN 1 ELSE 0 END), 2) AS reached_40_pct
FROM cookie_cats GROUP BY 1 ORDER BY 1;
