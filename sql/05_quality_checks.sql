-- =====================================================
-- DATA QUALITY CHECKS
-- OBJETIVO:
-- Validar integridade, duplicidade e relacionamentos
-- entre as camadas raw e dw.
--
-- USO:
-- Executar após a carga das tabelas raw, dimensões e fatos.
-- =====================================================


-- =====================================================
-- CHECK 01: pedidos duplicados na camada raw
--
-- OBJETIVO:
-- Identificar pedidos repetidos antes da carga
-- para a tabela fato dw.fact_orders.
--
-- RESULTADO ESPERADO:
-- Nenhuma linha retornada.
-- =====================================================

SELECT
  order_id,
  COUNT(*) AS total_ocorrencias
FROM raw.orders
GROUP BY 1
HAVING COUNT(*) > 1;


-- =====================================================
-- CHECK 02: lojas sem hub associado
--
-- OBJETIVO:
-- Identificar lojas carregadas na dimensão store
-- sem correspondência válida na dimensão hub.
--
-- RESULTADO ESPERADO:
-- 0
-- =====================================================

SELECT
  COUNT(*) AS stores_without_hub
FROM dw.dim_store s
LEFT JOIN dw.dim_hub h
  ON h.hub_id = s.hub_id
WHERE h.hub_id IS NULL;


-- =====================================================
-- CHECK 03: entregas sem pedido associado
--
-- OBJETIVO:
-- Identificar entregas que não possuem pedido
-- correspondente na tabela fato de pedidos.
--
-- RESULTADO ESPERADO:
-- 0
-- =====================================================

SELECT
  COUNT(*) AS deliveries_without_order
FROM dw.fact_deliveries d
LEFT JOIN dw.fact_orders o
  ON o.delivery_order_id = d.delivery_order_id
WHERE o.order_id IS NULL;


-- =====================================================
-- CHECK 04: pagamentos sem pedido associado
--
-- OBJETIVO:
-- Identificar pagamentos que não possuem pedido
-- correspondente na tabela fato de pedidos.
--
-- RESULTADO ESPERADO:
-- 0
-- =====================================================

SELECT
  COUNT(*) AS payments_without_order
FROM dw.fact_payments p
LEFT JOIN dw.fact_orders o
  ON o.payment_order_id = p.payment_order_id
WHERE o.order_id IS NULL;