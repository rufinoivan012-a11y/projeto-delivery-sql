DROP TABLE IF EXISTS dw.dim_date CASCADE;

CREATE TABLE dw.dim_date (
  date_key DATE PRIMARY KEY,
  year INT NOT NULL,
  month INT NOT NULL,
  day INT NOT NULL,
  dow INT NOT NULL
);

INSERT INTO dw.dim_date (date_key, year, month, day, dow)
SELECT DISTINCT
  order_moment_created::date AS date_key,
  EXTRACT(YEAR FROM order_moment_created)::int,
  EXTRACT(MONTH FROM order_moment_created)::int,
  EXTRACT(DAY FROM order_moment_created)::int,
  EXTRACT(DOW FROM order_moment_created)::int
FROM raw.orders
WHERE order_moment_created IS NOT NULL
ON CONFLICT (date_key) DO NOTHING;

DROP TABLE IF EXISTS dw.dim_hub CASCADE;

CREATE TABLE dw.dim_hub (
  hub_id TEXT PRIMARY KEY,
  hub_name TEXT,
  hub_city TEXT,
  hub_state TEXT,
  hub_latitude NUMERIC,
  hub_longitude NUMERIC
);

INSERT INTO dw.dim_hub
SELECT DISTINCT * FROM raw.hubs
WHERE hub_id IS NOT NULL
ON CONFLICT (hub_id) DO NOTHING;


DROP TABLE IF EXISTS dw.dim_store CASCADE;

CREATE TABLE dw.dim_store (
  store_id TEXT PRIMARY KEY,
  hub_id TEXT REFERENCES dw.dim_hub(hub_id),
  store_name TEXT,
  store_segment TEXT,
  store_plan_price NUMERIC(14,2),
  store_latitude NUMERIC,
  store_longitude NUMERIC
);

INSERT INTO dw.dim_store
SELECT DISTINCT * FROM raw.stores
WHERE store_id IS NOT NULL
ON CONFLICT (store_id) DO NOTHING;


DROP TABLE IF EXISTS dw.dim_channel CASCADE;

CREATE TABLE dw.dim_channel (
  channel_id TEXT PRIMARY KEY,
  channel_name TEXT,
  channel_type TEXT
);

INSERT INTO dw.dim_channel
SELECT DISTINCT * FROM raw.channels
WHERE channel_id IS NOT NULL
ON CONFLICT (channel_id) DO NOTHING;


DROP TABLE IF EXISTS dw.dim_driver CASCADE;

CREATE TABLE dw.dim_driver (
  driver_id TEXT PRIMARY KEY,
  driver_modal TEXT,
  driver_type TEXT
);

INSERT INTO dw.dim_driver
SELECT DISTINCT * FROM raw.drivers
WHERE driver_id IS NOT NULL
ON CONFLICT (driver_id) DO NOTHING;


