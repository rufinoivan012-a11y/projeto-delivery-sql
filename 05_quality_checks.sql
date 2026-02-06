-- pedidos duplicados
SELECT order_id, COUNT(*)
FROM raw.orders
GROUP BY 1
HAVING COUNT(*) > 1;

-- stores sem hub
SELECT COUNT(*) AS stores_without_hub
FROM dw.dim_store s
LEFT JOIN dw.dim_hub h ON h.hub_id = s.hub_id
WHERE h.hub_id IS NULL;

-- deliveries sem pedido
SELECT COUNT(*) AS deliveries_without_order
FROM dw.fact_deliveries d
LEFT JOIN dw.fact_orders o ON o.delivery_order_id = d.delivery_order_id
WHERE o.order_id IS NULL;

-- payments sem pedido
SELECT COUNT(*) AS payments_without_order
FROM dw.fact_payments p
LEFT JOIN dw.fact_orders o ON o.payment_order_id = p.payment_order_id
WHERE o.order_id IS NULL;
