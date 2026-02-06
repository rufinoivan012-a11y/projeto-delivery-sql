CREATE OR REPLACE VIEW analytics.vw_order_360 AS
SELECT
  fo.order_id,
  fo.order_status,
  fo.order_amount,
  fo.order_delivery_fee,
  fo.order_delivery_cost,
  fo.order_created_at,
  fo.order_date,
  fo.cycle_time,
  fo.transit_time,

  fo.store_id,
  s.store_name,
  s.store_segment,
  s.store_plan_price,
  s.hub_id,

  h.hub_name,
  h.hub_city,
  h.hub_state,

  fo.channel_id,
  c.channel_name,
  c.channel_type,

  d.delivery_id,
  d.driver_id,
  dr.driver_modal,
  dr.driver_type,
  d.delivery_distance_meters,
  d.delivery_status,

  p.payment_id,
  p.payment_amount,
  p.payment_fee,
  p.payment_method,
  p.payment_status

FROM dw.fact_orders fo
LEFT JOIN dw.dim_store s ON s.store_id = fo.store_id
LEFT JOIN dw.dim_hub h ON h.hub_id = s.hub_id
LEFT JOIN dw.dim_channel c ON c.channel_id = fo.channel_id
LEFT JOIN dw.fact_deliveries d ON d.delivery_order_id = fo.delivery_order_id
LEFT JOIN dw.dim_driver dr ON dr.driver_id = d.driver_id
LEFT JOIN dw.fact_payments p ON p.payment_order_id = fo.payment_order_id;


CREATE OR REPLACE VIEW analytics.vw_kpi_daily AS
SELECT
  order_date,
  COUNT(*) AS orders,
  SUM(order_amount) AS gmv,
  AVG(order_amount) AS ticket_medio,
  AVG(cycle_time) AS avg_cycle_time,
  PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cycle_time) AS p90_cycle_time,
  SUM(CASE WHEN order_status ILIKE '%cancel%' THEN 1 ELSE 0 END) AS canceled_orders
FROM analytics.vw_order_360
GROUP BY 1
ORDER BY 1;


CREATE OR REPLACE VIEW analytics.vw_kpi_by_state AS
SELECT
  hub_state,
  COUNT(*) AS orders,
  SUM(order_amount) AS gmv,
  AVG(order_amount) AS avg_ticket,
  AVG(cycle_time) AS avg_cycle_time,
  AVG(delivery_distance_meters) AS avg_distance_m
FROM analytics.vw_order_360
WHERE hub_state IS NOT NULL
GROUP BY 1
ORDER BY gmv DESC;


CREATE OR REPLACE VIEW analytics.vw_kpi_by_channel AS
SELECT
  channel_name,
  channel_type,
  COUNT(*) AS orders,
  SUM(order_amount) AS gmv,
  AVG(order_amount) AS avg_ticket
FROM analytics.vw_order_360
GROUP BY 1,2
ORDER BY gmv DESC;
