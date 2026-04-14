-- 1. Dimension: Clients
CREATE TABLE clients (
    client_id VARCHAR(50) PRIMARY KEY,
    score_credit_client INT, -- Credit scores are integers
    categorie_risque VARCHAR(50) NOT NULL,
    segment_client VARCHAR(50) NOT NULL
);

-- 2. Dimension: Agencies
CREATE TABLE agencies (
    agence_id SERIAL PRIMARY KEY,
    agence VARCHAR(100) UNIQUE NOT NULL
);

-- 3. Dimension: Products
CREATE TABLE products (
    produit_id SERIAL PRIMARY KEY,
    produit VARCHAR(100) UNIQUE NOT NULL
);

-- 4. Dimension: Categories
CREATE TABLE categories (
    categorie_id SERIAL PRIMARY KEY,
    categorie VARCHAR(100) UNIQUE NOT NULL
);

-- 5. Dimension: Date
CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    date_transaction TIMESTAMP UNIQUE NOT NULL,
    annee INT NOT NULL,
    mois INT NOT NULL,
    trimestre INT NOT NULL,
    jour_semaine VARCHAR(20) NOT NULL
);

-- 6. Fact Table: Transactions
CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    client_id VARCHAR(50) NOT NULL REFERENCES clients(client_id),
    agence_id INT NOT NULL REFERENCES agencies(agence_id),
    produit_id INT NOT NULL REFERENCES products(produit_id),
    categorie_id INT NOT NULL REFERENCES categories(categorie_id),
    date_id INT NOT NULL REFERENCES dim_date(date_id),
    
    -- Using DECIMAL for exact financial amounts
    montant DECIMAL(15, 2) NOT NULL,
    type_operation VARCHAR(50),
    devise VARCHAR(10) DEFAULT 'EUR',
    taux_change_eur DECIMAL(10, 6) DEFAULT 1.0,
    montant_eur_verifie DECIMAL(15, 2),
    statut VARCHAR(20),
    is_anomaly BOOLEAN DEFAULT FALSE,
    solde_avant DECIMAL(15, 2)
);