-- Q01 Painel Executivo
SELECT
  MIN(order_date) AS start_date,
  MAX(order_date) AS end_date,
  COUNT(*) AS orders_total,
  COUNT(*) FILTER (WHERE order_status NOT ILIKE '%cancel%') AS orders_valid,
  SUM(order_amount) AS gmv_gross,
  SUM(order_amount) FILTER (WHERE order_status NOT ILIKE '%cancel%') AS gmv_net,
  AVG(order_amount) FILTER (WHERE order_status NOT ILIKE '%cancel%') AS avg_ticket_net,
  COUNT(*) FILTER (WHERE order_status ILIKE '%cancel%') AS canceled_orders,
  ROUND(100.0 * COUNT(*) FILTER (WHERE order_status ILIKE '%cancel%') / NULLIF(COUNT(*),0), 2) AS cancel_rate_pct
FROM analytics.vw_order_360
WHERE order_date IS NOT NULL;


--Q02 Série diária + variação
WITH d AS (
  SELECT order_date, COUNT(*) AS orders, SUM(order_amount) AS gmv
  FROM analytics.vw_order_360
  WHERE order_date IS NOT NULL
  GROUP BY 1
),
w AS (
  SELECT
    *,
    LAG(orders) OVER (ORDER BY order_date) AS prev_orders,
    LAG(gmv) OVER (ORDER BY order_date) AS prev_gmv
  FROM d
)
SELECT
  order_date,
  orders,
  gmv,
  prev_orders,
  ROUND(100.0 * (orders - prev_orders) / NULLIF(prev_orders,0), 2) AS orders_dod_pct,
  prev_gmv,
  ROUND(100.0 * (gmv - prev_gmv) / NULLIF(prev_gmv,0), 2) AS gmv_dod_pct
FROM w
ORDER BY order_date;


--Q03 Top 20 + Pareto
WITH s AS (
  SELECT store_id, store_name, SUM(order_amount) AS gmv
  FROM analytics.vw_order_360
  WHERE order_status NOT ILIKE '%cancel%'
  GROUP BY 1,2
),
w AS (
  SELECT
    *,
    SUM(gmv) OVER () AS total_gmv,
    SUM(gmv) OVER (ORDER BY gmv DESC) AS cum_gmv
  FROM s
)
SELECT
  store_id,
  store_name,
  gmv,
  ROUND(100.0 * gmv / NULLIF(total_gmv,0), 2) AS gmv_share_pct,
  ROUND(100.0 * cum_gmv / NULLIF(total_gmv,0), 2) AS gmv_cum_share_pct
FROM w
ORDER BY gmv DESC
LIMIT 20;


--Q04 Estados
SELECT
  hub_state,
  COUNT(*) FILTER (WHERE order_status NOT ILIKE '%cancel%') AS orders_valid,
  SUM(order_amount) FILTER (WHERE order_status NOT ILIKE '%cancel%') AS gmv_net,
  AVG(cycle_time) AS avg_cycle_time,
  PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cycle_time) AS p90_cycle_time
FROM analytics.vw_order_360
WHERE hub_state IS NOT NULL
  AND cycle_time IS NOT NULL
GROUP BY 1
ORDER BY gmv_net DESC;

-- Q05 Segmentos
SELECT
  store_segment,
  COUNT(*) AS orders,
  SUM(order_amount) AS gmv,
  AVG(order_amount) AS avg_ticket,
  AVG(cycle_time) AS avg_cycle_time,
  PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cycle_time) AS p90_cycle_time
FROM analytics.vw_order_360
WHERE store_segment IS NOT NULL
GROUP BY 1
ORDER BY gmv DESC;


-- Q06 Ranking hubs pior P90
WITH h AS (
  SELECT
    hub_name, hub_city, hub_state,
    COUNT(*) AS orders,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cycle_time) AS p90_cycle_time
  FROM analytics.vw_order_360
  WHERE hub_name IS NOT NULL AND cycle_time IS NOT NULL
  GROUP BY 1,2,3
),
f AS (
  SELECT * FROM h WHERE orders >= 500
)
SELECT
  *,
  RANK() OVER (ORDER BY p90_cycle_time DESC) AS rank_worst_p90
FROM f
ORDER BY p90_cycle_time DESC
LIMIT 20;


--Q07 Cancelamento por canal
SELECT
  channel_name,
  channel_type,
  COUNT(*) AS orders,
  SUM(order_amount) AS gmv_gross,
  SUM(order_amount) FILTER (WHERE order_status ILIKE '%cancel%') AS canceled_gmv,
  ROUND(100.0 * COUNT(*) FILTER (WHERE order_status ILIKE '%cancel%') / NULLIF(COUNT(*),0), 2) AS cancel_rate_pct
FROM analytics.vw_order_360
GROUP BY 1,2
ORDER BY cancel_rate_pct DESC;


--Q08 PAGAMENTOS
WITH p AS (
  SELECT
    payment_order_id,
    MAX(payment_method) AS payment_method,
    BOOL_OR(payment_status = 'PAID') AS is_paid,
    SUM(payment_amount) AS total_paid
  FROM dw.fact_payments
  GROUP BY 1
)
SELECT
  payment_method,
  COUNT(*) AS payment_orders,
  SUM(total_paid) AS total_paid,
  SUM(CASE WHEN is_paid THEN 1 ELSE 0 END) AS paid_orders,
  ROUND(
    100.0 * SUM(CASE WHEN is_paid THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),
    2
  ) AS approval_rate_pct
FROM p
GROUP BY 1
ORDER BY payment_orders DESC;


WITH p AS (
  SELECT
    payment_order_id,
    MAX(payment_method) AS payment_method,
    BOOL_OR(payment_status = 'PAID') AS is_paid,
    BOOL_OR(payment_status = 'ACHARGEBACK') AS is_chargeback
  FROM dw.fact_payments
  GROUP BY 1
)
SELECT
  payment_method,
  COUNT(*) AS payment_orders,
  SUM(CASE WHEN is_chargeback THEN 1 ELSE 0 END) AS chargebacks,
  ROUND(
    100.0 * SUM(CASE WHEN is_chargeback THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),
    2
  ) AS chargeback_rate_pct
FROM p
GROUP BY 1
ORDER BY chargeback_rate_pct DESC;


--Q09 Distancia vs tempo
WITH x AS (
  SELECT
    cycle_time,
    delivery_distance_meters,
    CASE
      WHEN delivery_distance_meters < 1000 THEN '<1km'
      WHEN delivery_distance_meters < 3000 THEN '1-3km'
      WHEN delivery_distance_meters < 5000 THEN '3-5km'
      WHEN delivery_distance_meters < 10000 THEN '5-10km'
      ELSE '10km+'
    END AS distance_bucket
  FROM analytics.vw_order_360
  WHERE delivery_distance_meters IS NOT NULL
    AND cycle_time IS NOT NULL
)
SELECT
  distance_bucket,
  COUNT(*) AS orders,
  AVG(delivery_distance_meters) AS avg_dist_m,
  AVG(cycle_time) AS avg_cycle_time,
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cycle_time) AS p50_cycle_time,
  PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cycle_time) AS p90_cycle_time
FROM x
GROUP BY 1
HAVING COUNT(*) >= 500
ORDER BY
  CASE distance_bucket
    WHEN '<1km' THEN 1
    WHEN '1-3km' THEN 2
    WHEN '3-5km' THEN 3
    WHEN '5-10km' THEN 4
    ELSE 5
  END;


--Q10 DRIVERS
WITH d AS (
  SELECT
    driver_type,
    driver_modal,
    COUNT(*) AS deliveries,
    AVG(delivery_distance_meters) AS avg_distance_m
  FROM analytics.vw_order_360
  WHERE delivery_id IS NOT NULL
    AND driver_type IS NOT NULL
    AND driver_modal IS NOT NULL
    AND delivery_distance_meters BETWEEN 50 AND 30000
  GROUP BY 1,2
)
SELECT
  *,
  RANK() OVER (ORDER BY deliveries DESC) AS rank_by_volume
FROM d
ORDER BY deliveries DESC;



WITH d AS (
  SELECT
    driver_modal,
    COUNT(*) AS deliveries
  FROM analytics.vw_order_360
  WHERE delivery_id IS NOT NULL
    AND driver_modal IS NOT NULL
  GROUP BY 1
),
t AS (
  SELECT SUM(deliveries) AS total FROM d
)
SELECT
  d.driver_modal,
  d.deliveries,
  ROUND(100.0 * d.deliveries / t.total, 2) AS share_pct
FROM d
CROSS JOIN t
ORDER BY d.deliveries DESC;


--Q12 CUSTO VS TAXA
SELECT
  hub_state,
  COUNT(*) AS orders,
  AVG(order_delivery_fee) AS avg_fee,
  AVG(order_delivery_cost) AS avg_cost,
  (AVG(order_delivery_fee) - AVG(order_delivery_cost)) AS avg_margin_abs,
  ROUND(
    100.0 * (AVG(order_delivery_fee) - AVG(order_delivery_cost)) / NULLIF(AVG(order_delivery_fee),0),
    2
  ) AS avg_margin_pct
FROM analytics.vw_order_360
WHERE hub_state IS NOT NULL
  AND order_delivery_fee IS NOT NULL
  AND order_delivery_cost IS NOT NULL
GROUP BY 1
ORDER BY avg_margin_abs DESC;

