DROP TABLE IF EXISTS dw.fact_orders CASCADE;

CREATE TABLE dw.fact_orders (
  order_id TEXT PRIMARY KEY,
  store_id TEXT REFERENCES dw.dim_store(store_id),
  channel_id TEXT REFERENCES dw.dim_channel(channel_id),

  payment_order_id TEXT,
  delivery_order_id TEXT,

  order_status TEXT,
  order_amount NUMERIC(14,2),
  order_delivery_fee NUMERIC(14,2),
  order_delivery_cost NUMERIC(14,2),

  order_created_at TIMESTAMP,
  order_date DATE REFERENCES dw.dim_date(date_key),

  accepted_at TIMESTAMP,
  ready_at TIMESTAMP,
  collected_at TIMESTAMP,
  delivering_at TIMESTAMP,
  delivered_at TIMESTAMP,
  finished_at TIMESTAMP,

  cycle_time NUMERIC,
  transit_time NUMERIC,
  production_time NUMERIC,
  paused_time NUMERIC
);

INSERT INTO dw.fact_orders (
  order_id, store_id, channel_id, payment_order_id, delivery_order_id,
  order_status, order_amount, order_delivery_fee, order_delivery_cost,
  order_created_at, order_date,
  accepted_at, ready_at, collected_at, delivering_at, delivered_at, finished_at,
  cycle_time, transit_time, production_time, paused_time
)
SELECT
  order_id, store_id, channel_id, payment_order_id, delivery_order_id,
  order_status, order_amount, order_delivery_fee, order_delivery_cost,
  order_moment_created, order_moment_created::date,
  order_moment_accepted, order_moment_ready, order_moment_collected,
  order_moment_delivering, order_moment_delivered, order_moment_finished,
  order_metric_cycle_time, order_metric_transit_time, order_metric_production_time, order_metric_paused_time
FROM raw.orders
ON CONFLICT (order_id) DO NOTHING;


DROP TABLE IF EXISTS dw.fact_deliveries CASCADE;

CREATE TABLE dw.fact_deliveries (
  delivery_id TEXT PRIMARY KEY,
  delivery_order_id TEXT,
  driver_id TEXT REFERENCES dw.dim_driver(driver_id),
  delivery_distance_meters NUMERIC,
  delivery_status TEXT
);

INSERT INTO dw.fact_deliveries
SELECT DISTINCT
  delivery_id, delivery_order_id, driver_id, delivery_distance_meters, delivery_status
FROM raw.deliveries
ON CONFLICT (delivery_id) DO NOTHING;


CREATE TABLE dw.fact_payments (
  payment_id TEXT PRIMARY KEY,
  payment_order_id TEXT,
  payment_amount NUMERIC(14,2),
  payment_fee NUMERIC(14,2),
  payment_method TEXT,
  payment_status TEXT
);

INSERT INTO dw.fact_payments
SELECT DISTINCT
  payment_id, payment_order_id, payment_amount, payment_fee, payment_method, payment_status
FROM raw.payments
ON CONFLICT (payment_id) DO NOTHING;

