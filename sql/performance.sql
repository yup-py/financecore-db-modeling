-- =========================================================
-- ÉTAPE 4 : REQUÊTES ANALYTIQUES ET VUES KPI (BRIEF 3)
-- =========================================================

-- 0. Optimisation des performances (Index B-Tree)
-- Accelerates joins and aggregations for the dashboard.
CREATE INDEX IF NOT EXISTS idx_transactions_client ON transactions(client_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date_id);
CREATE INDEX IF NOT EXISTS idx_transactions_agence ON transactions(agence_id);
CREATE INDEX IF NOT EXISTS idx_date_timestamp ON dim_date(date_transaction);


-- 1. Jointures multi-tables
-- Global reporting view combining all 6 tables for complete visibility.
CREATE OR REPLACE VIEW vw_transactions_full AS 
SELECT
    t.transaction_id,
    c.client_id,
    c.segment_client,
    c.categorie_risque,
    a.agence,
    p.produit,
    cat.categorie,
    d.date_transaction,
    d.annee,
    d.mois,
    t.montant,
    t.type_operation,
    t.devise,
    t.statut,
    t.is_anomaly
FROM transactions t
JOIN clients c ON t.client_id = c.client_id
JOIN agencies a ON t.agence_id = a.agence_id
JOIN products p ON t.produit_id = p.produit_id
JOIN categories cat ON t.categorie_id = cat.categorie_id
JOIN dim_date d ON t.date_id = d.date_id;


-- 2. Agrégations (GROUP BY, HAVING)
-- Performance analysis view segmented by agency, product, and month.
CREATE OR REPLACE VIEW vw_analytics_performances AS
SELECT 
    a.agence,
    p.produit,
    d.annee,
    d.mois,
    COUNT(t.transaction_id) as nb_transactions,
    SUM(t.montant_eur_verifie) as volume_total_eur,
    ROUND(AVG(t.montant_eur_verifie), 2) as moyenne_transaction_eur
FROM transactions t
JOIN agencies a ON t.agence_id = a.agence_id
JOIN products p ON t.produit_id = p.produit_id
JOIN dim_date d ON t.date_id = d.date_id
GROUP BY a.agence, p.produit, d.annee, d.mois
HAVING SUM(t.montant_eur_verifie) > 0;


-- 3. Sous-requêtes
-- Identifies clients whose balance is below the global national average.
CREATE OR REPLACE VIEW vw_clients_sous_moyenne AS
SELECT 
    client_id,  
    score_credit_client,
    segment_client
FROM clients 
WHERE client_id IN (
    SELECT client_id 
    FROM transactions 
    WHERE solde_avant < (SELECT AVG(solde_avant) FROM transactions)
);


-- 4. CASE WHEN : calcul du taux de défaut
-- Risk analysis by segment based on rejected transactions.
CREATE OR REPLACE VIEW vw_taux_defaut_segment AS
SELECT 
    c.segment_client,
    c.categorie_risque,
    COUNT(t.transaction_id) as total_transactions,
    SUM(CASE WHEN t.statut = 'Rejete' THEN 1 ELSE 0 END) as nb_rejets,
    ROUND(
        (SUM(CASE WHEN t.statut = 'Rejete' THEN 1 ELSE 0 END)::numeric / 
        NULLIF(COUNT(t.transaction_id), 0)) * 100, 2
    ) as taux_defaut_pourcentage
FROM transactions t
JOIN clients c ON t.client_id = c.client_id
GROUP BY c.segment_client, c.categorie_risque;


-- 5. Créer des vues analytiques pour les KPIs (Brief 3)
-- High-level summary indicators for your dashboard KPI tiles.
CREATE OR REPLACE VIEW vw_dashboard_kpis AS
SELECT 
    ABS(SUM(montant_eur_verifie)) as chiffre_affaires_total,
    ABS(AVG(montant_eur_verifie)) as panier_moyen,
    COUNT(CASE WHEN is_anomaly THEN 1 END) as total_anomalies_detectees,
    (SELECT COUNT(DISTINCT client_id) FROM clients) as nombre_clients_actifs
FROM transactions
WHERE statut = 'Complete';