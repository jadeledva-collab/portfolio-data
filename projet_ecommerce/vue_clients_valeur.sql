CREATE OR REPLACE TABLE `gen-lang-client-0637995970.olist_ecommerce.vue_clients_valeur` AS
SELECT 
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS nombre_achats,
    ROUND(SUM(oi.price), 2) AS montant_total_depense,
    ROUND(AVG(oi.price), 2) AS panier_moyen
FROM 
    `gen-lang-client-0637995970.olist_ecommerce.customers` AS c
JOIN 
    `gen-lang-client-0637995970.olist_ecommerce.orders` AS o ON c.customer_id = o.customer_id
JOIN 
    `gen-lang-client-0637995970.olist_ecommerce.order_items` AS oi ON o.order_id = oi.order_id
WHERE 
    o.order_status = 'delivered'
GROUP BY 
    c.customer_unique_id
ORDER BY 
    montant_total_depense DESC;