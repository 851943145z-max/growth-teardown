-- 订单履约漏斗：下单 → 支付审核 → 交给物流 → 送达 → 留下评价
SELECT COUNT(*) AS placed,
       COUNT(order_approved_at) AS approved,
       COUNT(order_delivered_carrier_date) AS shipped,
       COUNT(order_delivered_customer_date) AS delivered,
       COUNT(review_score) FILTER (WHERE order_delivered_customer_date IS NOT NULL) AS reviewed_after_delivery
FROM order_fact;
