# 海外产品增长诊断（Growth Teardown）

用 AI 写 SQL，拆解两个海外产品的增长问题：

1. **巴西电商 Olist**（约 10 万笔真实订单）：增长靠什么、卡在哪里。结论：97% 的用户只买过一次，增长几乎全部来自拉新；首单延迟送达与差评和流失相关。基于这些发现设计了 3 个增长实验，并估算了样本量。
2. **手游 Cookie Cats A/B 实验**（9 万名新玩家）：关卡门槛从第 30 关后移到第 40 关，该不该全量上线。结论：7 日留存显著下降（19.02% 对 18.20%，p = 0.0016），建议不上线。

完整的图表和分析见 `index.html`（用浏览器直接打开即可）或 `张文韬_海外产品增长诊断.pdf`。

## 目录

| 文件 | 内容 |
|---|---|
| `index.html` | 交互式作品页：图表、结论、实验设计，以及全部 SQL 与运行结果 |
| `张文韬_海外产品增长诊断.pdf` | 作品页的 PDF 版 |
| `sql/00_base.sql` | 基础视图：订单宽表、每个用户的订单编号 |
| `sql/01` 至 `sql/09`、`sql/12` | Olist：月度增长、履约漏斗、复购率、cohort 留存、延迟与评分、首单体验与复购、分州与分区、品类复购 |
| `sql/10`、`sql/11` | Cookie Cats：两组留存对比、参与度漏斗 |
| `run_analysis.py` | 下载数据后一键运行全部 SQL，并输出统计检验结果 |

## 如何复现

```bash
pip install duckdb pandas
git clone --depth 1 https://github.com/olist/work-at-olist-data data/olist
git clone --depth 1 https://github.com/ryanschaub/Mobile-Games-A-B-Testing-with-Cookie-Cats data/cookie
python run_analysis.py
```

## 校验 AI 输出时修正的问题

1. **同日拆单被算成复购**：30% 的"复购"与首单在同一天，剔除后真实复购用户占比从 3.0% 降到 2.1%。
2. **排序不稳定**：同一用户同一秒的多张订单排序不确定，导致每次结果略有不同；给窗口函数加上订单号作为第二排序键。
3. **空值被归为"按时送达"**：2 笔订单没有预计送达日期，改为显式排除。
4. **观察期不足**：只纳入有完整 180 天观察期的 cohort。

## 数据来源

- Olist, Brazilian E-Commerce Public Dataset：https://github.com/olist/work-at-olist-data
- Cookie Cats A/B test dataset：https://github.com/ryanschaub/Mobile-Games-A-B-Testing-with-Cookie-Cats

工具：Claude（SQL 生成与校验）、DuckDB、Python。作者：张文韬，2026 年 11 月。
