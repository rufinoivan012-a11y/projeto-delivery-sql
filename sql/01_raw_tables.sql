CREATE SCHEMA IF NOT EXISTS raw;

-- =====================================================
-- TABLE: raw.orders
-- OBJETIVO:
-- Armazenar dados brutos de pedidos importados do CSV.
--
-- GRANULARIDADE:
-- 1 linha por pedido.
--
-- OBSERVAÇÃO:
-- Mantém os nomes e tipos próximos ao arquivo original.
-- =====================================================

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


-- =====================================================
-- TABLE: raw.deliveries
-- OBJETIVO:
-- Armazenar dados brutos de entregas.
--
-- GRANULARIDADE:
-- 1 linha por entrega.
-- =====================================================

DROP TABLE IF EXISTS raw.deliveries;

CREATE TABLE raw.deliveries (
  delivery_id TEXT,
  delivery_order_id TEXT,
  driver_id TEXT,
  delivery_distance_meters NUMERIC,
  delivery_status TEXT
);


-- =====================================================
-- TABLE: raw.payments
-- OBJETIVO:
-- Armazenar dados brutos de pagamentos.
--
-- GRANULARIDADE:
-- 1 linha por pagamento.
-- =====================================================

DROP TABLE IF EXISTS raw.payments;

CREATE TABLE raw.payments (
  payment_id TEXT,
  payment_order_id TEXT,
  payment_amount NUMERIC(14,2),
  payment_fee NUMERIC(14,2),
  payment_method TEXT,
  payment_status TEXT
);


-- =====================================================
-- TABLE: raw.stores
-- OBJETIVO:
-- Armazenar dados brutos das lojas.
--
-- GRANULARIDADE:
-- 1 linha por loja.
-- =====================================================

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


-- =====================================================
-- TABLE: raw.hubs
-- OBJETIVO:
-- Armazenar dados brutos dos hubs logísticos.
--
-- GRANULARIDADE:
-- 1 linha por hub.
-- =====================================================

DROP TABLE IF EXISTS raw.hubs;

CREATE TABLE raw.hubs (
  hub_id TEXT,
  hub_name TEXT,
  hub_city TEXT,
  hub_state TEXT,
  hub_latitude NUMERIC,
  hub_longitude NUMERIC
);


-- =====================================================
-- TABLE: raw.channels
-- OBJETIVO:
-- Armazenar dados brutos dos canais de venda.
--
-- GRANULARIDADE:
-- 1 linha por canal.
-- =====================================================

DROP TABLE IF EXISTS raw.channels;

CREATE TABLE raw.channels (
  channel_id TEXT,
  channel_name TEXT,
  channel_type TEXT
);


-- =====================================================
-- TABLE: raw.drivers
-- OBJETIVO:
-- Armazenar dados brutos dos entregadores.
--
-- GRANULARIDADE:
-- 1 linha por entregador.
-- =====================================================

DROP TABLE IF EXISTS raw.drivers;

CREATE TABLE raw.drivers (
  driver_id TEXT,
  driver_modal TEXT,
  driver_type TEXT
);


-- =====================================================
-- VALIDAÇÃO:
-- Conferir quantidade de registros por tabela
-- após a criação/importação dos dados.
-- =====================================================

SELECT 'orders' AS tabela, COUNT(*) AS total_registros FROM raw.orders
UNION ALL SELECT 'deliveries', COUNT(*) FROM raw.deliveries
UNION ALL SELECT 'payments', COUNT(*) FROM raw.payments
UNION ALL SELECT 'stores', COUNT(*) FROM raw.stores
UNION ALL SELECT 'hubs', COUNT(*) FROM raw.hubs
UNION ALL SELECT 'channels', COUNT(*) FROM raw.channels
UNION ALL SELECT 'drivers', COUNT(*) FROM raw.drivers;