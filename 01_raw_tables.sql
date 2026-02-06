DROP TABLE IF EXISTS raw.orders;

CREATE TABLE raw.orders (
  order_id TEXT,
  store_id TEXT,
  channel_id TEXT,
  payment_order_id TEXT,
  delivery_order_id TEXT,
  order_status TEXT,

  order_amount NUMERIC(14,2),
  order_delivery_fee NUMERIC(14,2),
  order_delivery_cost NUMERIC(14,2),

  order_created_hour INT,
  order_created_minute INT,
  order_created_day INT,
  order_created_month INT,
  order_created_year INT,

  order_moment_created TIMESTAMP,
  order_moment_accepted TIMESTAMP,
  order_moment_ready TIMESTAMP,
  order_moment_collected TIMESTAMP,
  order_moment_in_expedition TIMESTAMP,
  order_moment_delivering TIMESTAMP,
  order_moment_delivered TIMESTAMP,
  order_moment_finished TIMESTAMP,

  order_metric_collected_time NUMERIC,
  order_metric_paused_time NUMERIC,
  order_metric_production_time NUMERIC,
  order_metric_walking_time NUMERIC,
  order_metric_expediton_speed_time NUMERIC,
  order_metric_transit_time NUMERIC,
  order_metric_cycle_time NUMERIC
);

SELECT COUNT(*) FROM raw.orders;
SELECT * FROM raw.orders LIMIT 5;

DROP TABLE IF EXISTS raw.orders_txt;

CREATE TABLE raw.orders_txt (
  order_id TEXT,
  store_id TEXT,
  channel_id TEXT,
  payment_order_id TEXT,
  delivery_order_id TEXT,
  order_status TEXT,
  order_amount TEXT,
  order_delivery_fee TEXT,
  order_delivery_cost TEXT,
  order_created_hour TEXT,
  order_created_minute TEXT,
  order_created_day TEXT,
  order_created_month TEXT,
  order_created_year TEXT,
  order_moment_created TEXT,
  order_moment_accepted TEXT,
  order_moment_ready TEXT,
  order_moment_collected TEXT,
  order_moment_in_expedition TEXT,
  order_moment_delivering TEXT,
  order_moment_delivered TEXT,
  order_moment_finished TEXT,
  order_metric_collected_time TEXT,
  order_metric_paused_time TEXT,
  order_metric_production_time TEXT,
  order_metric_walking_time TEXT,
  order_metric_expediton_speed_time TEXT,
  order_metric_transit_time TEXT,
  order_metric_cycle_time TEXT
);


SELECT COUNT(*) FROM raw.orders_txt;

TRUNCATE raw.orders_txt;

COPY raw.orders_txt
FROM PROGRAM 'cmd /c type "C:\Users\rufin\Documents\PROJETO DELIVERY\orders.csv"'
WITH (
  FORMAT csv,
  HEADER true,
  DELIMITER ',',
  QUOTE '"',
  ESCAPE '"'
);

SELECT COUNT(*) FROM raw.orders;

DROP TABLE IF EXISTS raw.orders_txt;

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS dw;
CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS raw.deliveries;

CREATE TABLE raw.deliveries (
  delivery_id TEXT,
  delivery_order_id TEXT,
  driver_id TEXT,
  delivery_distance_meters NUMERIC,
  delivery_status TEXT
);


DROP TABLE IF EXISTS raw.payments;

CREATE TABLE raw.payments (
  payment_id TEXT,
  payment_order_id TEXT,
  payment_amount NUMERIC(14,2),
  payment_fee NUMERIC(14,2),
  payment_method TEXT,
  payment_status TEXT
);


DROP TABLE IF EXISTS raw.stores;

CREATE TABLE raw.stores (
  store_id TEXT,
  hub_id TEXT,
  store_name TEXT,
  store_segment TEXT,
  store_plan_price NUMERIC(14,2),
  store_latitude NUMERIC,
  store_longitude NUMERIC
);


DROP TABLE IF EXISTS raw.hubs;

CREATE TABLE raw.hubs (
  hub_id TEXT,
  hub_name TEXT,
  hub_city TEXT,
  hub_state TEXT,
  hub_latitude NUMERIC,
  hub_longitude NUMERIC
);


DROP TABLE IF EXISTS raw.channels;

CREATE TABLE raw.channels (
  channel_id TEXT,
  channel_name TEXT,
  channel_type TEXT
);

DROP TABLE IF EXISTS raw.drivers;

CREATE TABLE raw.drivers (
  driver_id TEXT,
  driver_modal TEXT,
  driver_type TEXT
);

SELECT 'orders' tabela, COUNT(*) FROM raw.orders
UNION ALL SELECT 'deliveries', COUNT(*) FROM raw.deliveries
UNION ALL SELECT 'payments', COUNT(*) FROM raw.payments
UNION ALL SELECT 'stores', COUNT(*) FROM raw.stores
UNION ALL SELECT 'hubs', COUNT(*) FROM raw.hubs
UNION ALL SELECT 'channels', COUNT(*) FROM raw.channels
UNION ALL SELECT 'drivers', COUNT(*) FROM raw.drivers;

