-- 基础视图：每笔订单一行，带客户唯一ID、州、金额、履约时间和评分
CREATE OR REPLACE VIEW order_fact AS
WITH item AS (
  SELECT order_id, SUM(price) AS gmv, SUM(freight_value) AS freight, COUNT(*) AS n_items
  FROM order_items GROUP BY order_id
), rev AS (
  SELECT order_id, AVG(review_score) AS review_score
  FROM order_reviews GROUP BY order_id
)
SELECT o.order_id, c.customer_unique_id AS user_id, c.customer_state AS state,
       o.order_status, o.order_purchase_timestamp AS ts,
       o.order_approved_at, o.order_delivered_carrier_date, o.order_delivered_customer_date,
       o.order_estimated_delivery_date,
       date_diff('day', o.order_purchase_timestamp, o.order_delivered_customer_date) AS delivery_days,
       o.order_delivered_customer_date > o.order_estimated_delivery_date + INTERVAL 1 DAY AS is_late,
       i.gmv, i.freight, r.review_score
FROM orders o
JOIN customers c USING (customer_id)
LEFT JOIN item i USING (order_id)
LEFT JOIN rev r USING (order_id);

-- 每个用户按时间给订单编号，第 1 单 = 首单
CREATE OR REPLACE VIEW user_orders AS
SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY ts, order_id) AS nth
FROM order_fact
WHERE order_status NOT IN ('canceled','unavailable');
