CREATE OR REPLACE TABLE `gen-lang-client-0637995970.olist_ecommerce.vue_dashboard_produits` AS
SELECT 
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS nb_commandes,
    COUNT(oi.product_id) AS total_produits_vendus,
    ROUND(SUM(oi.price), 2) AS chiffre_affaires_total,
    ROUND(AVG(oi.price), 2) AS prix_moyen
FROM 
    `gen-lang-client-0637995970.olist_ecommerce.orders` AS o
JOIN 
    `gen-lang-client-0637995970.olist_ecommerce.order_items` AS oi ON o.order_id = oi.order_id
JOIN 
    `gen-lang-client-0637995970.olist_ecommerce.products` AS p ON oi.product_id = p.product_id
WHERE 
    o.order_status = 'delivered'
GROUP BY 
    p.product_category_name;