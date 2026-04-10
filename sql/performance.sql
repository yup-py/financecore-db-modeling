-- Performance: B-Tree Indexes for fast Joins
CREATE INDEX idx_transactions_client ON transactions(client_id);
CREATE INDEX idx_transactions_date ON transactions(date_id);
CREATE INDEX idx_transactions_agence ON transactions(agence_id);
CREATE INDEX idx_date_timestamp ON dim_date(date_transaction);

-- Reporting View: This combines everything into one readable table
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