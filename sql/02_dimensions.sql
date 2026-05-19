-- =====================================================
-- SCHEMA: dw
-- OBJETIVO:
-- Armazenar tabelas dimensionais e fatos
-- modeladas para análise.
-- =====================================================

CREATE SCHEMA IF NOT EXISTS dw;

-- =====================================================
-- TABLE: dw.dim_date
-- OBJETIVO:
-- Armazenar atributos temporais derivados
-- da data de criação dos pedidos.
--
-- GRANULARIDADE:
-- 1 linha por data.
--
-- TIPO:
-- Dimensão de tempo.
-- =====================================================

DROP TABLE IF EXISTS dw.dim_date CASCADE;

-- =====================================================
-- CRIAÇÃO DA DIMENSÃO DE TEMPO
-- =====================================================

CREATE TABLE dw.dim_date (
  date_key DATE PRIMARY KEY,
  year INT NOT NULL,
  month INT NOT NULL,
  day INT NOT NULL,
  dow INT NOT NULL
);

-- =====================================================
-- CARGA DA DIMENSÃO DE TEMPO
--
-- OBJETIVO:
-- Extrair datas únicas dos pedidos
-- e derivar atributos temporais.
-- =====================================================

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

-- =====================================================
-- TABLE: dw.dim_hub
-- OBJETIVO:
-- Armazenar informações dos hubs logísticos.
--
-- GRANULARIDADE:
-- 1 linha por hub.
--
-- TIPO:
-- Dimensão logística.
-- =====================================================
DROP TABLE IF EXISTS dw.dim_hub CASCADE;

CREATE TABLE dw.dim_hub (
  hub_id TEXT PRIMARY KEY,
  hub_name TEXT,
  hub_city TEXT,
  hub_state TEXT,
  hub_latitude NUMERIC,
  hub_longitude NUMERIC
);
-- =====================================================
-- CARGA DA DIMENSÃO DE HUBS
--
-- OBJETIVO:
-- Carregar hubs únicos provenientes
-- da camada raw.
-- =====================================================
INSERT INTO dw.dim_hub
SELECT DISTINCT * FROM raw.hubs
WHERE hub_id IS NOT NULL
ON CONFLICT (hub_id) DO NOTHING;

-- =====================================================
-- TABLE: dw.dim_store
-- OBJETIVO:
-- Armazenar informações dimensionais
-- das lojas.
--
-- GRANULARIDADE:
-- 1 linha por loja.
--
-- TIPO:
-- Dimensão comercial.
-- ====================================================
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

-- =====================================================
-- CARGA DA DIMENSÃO DE LOJAS
--
-- OBJETIVO:
-- Carregar lojas únicas e associá-las
-- aos hubs logísticos.
-- =====================================================
INSERT INTO dw.dim_store
SELECT DISTINCT * FROM raw.stores
WHERE store_id IS NOT NULL
ON CONFLICT (store_id) DO NOTHING;

-- =====================================================
-- TABLE: dw.dim_channel
-- OBJETIVO:
-- Armazenar informações dos canais
-- de venda.
--
-- GRANULARIDADE:
-- 1 linha por canal.
--
-- TIPO:
-- Dimensão comercial.
-- =====================================================
DROP TABLE IF EXISTS dw.dim_channel CASCADE;

CREATE TABLE dw.dim_channel (
  channel_id TEXT PRIMARY KEY,
  channel_name TEXT,
  channel_type TEXT
);

-- =====================================================
-- CARGA DA DIMENSÃO DE CANAIS
--
-- OBJETIVO:
-- Carregar canais únicos utilizados
-- nas vendas.
-- =====================================================
INSERT INTO dw.dim_channel
SELECT DISTINCT * FROM raw.channels
WHERE channel_id IS NOT NULL
ON CONFLICT (channel_id) DO NOTHING;

-- =====================================================
-- TABLE: dw.dim_driver
-- OBJETIVO:
-- Armazenar informações dos entregadores.
--
-- GRANULARIDADE:
-- 1 linha por entregador.
--
-- TIPO:
-- Dimensão operacional.
-- =====================================================
DROP TABLE IF EXISTS dw.dim_driver CASCADE;

CREATE TABLE dw.dim_driver (
  driver_id TEXT PRIMARY KEY,
  driver_modal TEXT,
  driver_type TEXT
);

-- =====================================================
-- CARGA DA DIMENSÃO DE ENTREGADORES
--
-- OBJETIVO:
-- Carregar entregadores únicos
-- provenientes da camada raw.
-- =====================================================
INSERT INTO dw.dim_driver
SELECT DISTINCT * FROM raw.drivers
WHERE driver_id IS NOT NULL
ON CONFLICT (driver_id) DO NOTHING;


