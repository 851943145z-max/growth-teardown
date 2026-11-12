"""运行全部 SQL 并输出结果与统计检验。先按 README 把数据克隆到 data/ 目录。"""
import glob, math, os
import duckdb

con = duckdb.connect()
d = "data/olist/datasets/"
for t in ["customers", "orders", "order_items", "order_payments", "order_reviews", "products", "sellers"]:
    con.execute(f"CREATE TABLE {t} AS SELECT * FROM read_csv_auto('{d}olist_{t}_dataset.csv')")
con.execute(f"CREATE TABLE cat_tr AS SELECT * FROM read_csv_auto('{d}product_category_name_translation.csv')")
con.execute("CREATE TABLE cookie_cats AS SELECT * FROM read_csv_auto('data/cookie/cookie_cats.csv')")
con.execute(open("sql/00_base.sql").read())

for f in sorted(glob.glob("sql/[0-9]*.sql"))[1:]:
    print("\n==", os.path.basename(f))
    print(con.execute(open(f).read()).df().to_string(index=False))

def ztest(x1, n1, x2, n2):
    p1, p2, p = x1 / n1, x2 / n2, (x1 + x2) / (n1 + n2)
    z = (p1 - p2) / math.sqrt(p * (1 - p) * (1 / n1 + 1 / n2))
    return round((p1 - p2) * 100, 3), round(z, 2), round(math.erfc(abs(z) / math.sqrt(2)), 4)

print("\n== A/B 双比例 z 检验（第 30 关 - 第 40 关）：差异百分点, z, p")
for m in ["retention_1", "retention_7"]:
    (_, x1, n1), (_, x2, n2) = con.execute(
        f"SELECT version, SUM(CAST({m} AS INT)), COUNT(*) FROM cookie_cats GROUP BY 1 ORDER BY 1").fetchall()
    print(m, ztest(x1, n1, x2, n2))
