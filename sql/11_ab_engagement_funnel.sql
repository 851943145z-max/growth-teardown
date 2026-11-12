-- 玩家参与度漏斗：安装 → 玩过 1 局 → 10 局 → 30 局 → 40 局 → 100 局
SELECT version,
       COUNT(*) AS installed,
       COUNT(*) FILTER (WHERE sum_gamerounds >= 1)   AS r1,
       COUNT(*) FILTER (WHERE sum_gamerounds >= 10)  AS r10,
       COUNT(*) FILTER (WHERE sum_gamerounds >= 30)  AS r30,
       COUNT(*) FILTER (WHERE sum_gamerounds >= 40)  AS r40,
       COUNT(*) FILTER (WHERE sum_gamerounds >= 100) AS r100
FROM cookie_cats GROUP BY 1 ORDER BY 1;
