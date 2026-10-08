CREATE OR REPLACE TABLE `gen-lang-client-0637995970.olist_ecommerce.vue_performance_logistique` AS
SELECT 
    FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp)) AS mois,
    COUNT(order_id) AS total_commandes_livrees,
    ROUND(AVG(TIMESTAMP_DIFF(order_delivered_customer_date, order_purchase_timestamp, HOUR)) / 24, 1) AS delai_moyen_jours_reel,
    ROUND(AVG(TIMESTAMP_DIFF(order_estimated_delivery_date, order_purchase_timestamp, HOUR)) / 24, 1) AS delai_moyen_jours_estime
FROM 
    `gen-lang-client-0637995970.olist_ecommerce.orders`
WHERE 
    order_status = 'delivered' 
    AND order_delivered_customer_date IS NOT NULL
GROUP BY 
    mois
ORDER BY 
    mois ASC;