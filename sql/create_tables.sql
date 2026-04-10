-- 1. Dimension Tables First (No Foreign Keys)
CREATE TABLE clients (
    client_id VARCHAR(50) PRIMARY KEY,
    score_credit_client FLOAT,
    categorie_risque VARCHAR(50),
    segment_client VARCHAR(50)
);

CREATE TABLE agencies (
    agence_id SERIAL PRIMARY KEY,
    agence VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    produit_id SERIAL PRIMARY KEY,
    produit VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE categories (
    categorie_id SERIAL PRIMARY KEY,
    categorie VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    date_transaction TIMESTAMP,
    annee INT,
    mois INT,
    trimestre INT,
    jour_semaine VARCHAR(20)
);

-- 2. Fact Table (Contains all Foreign Keys)
CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    client_id VARCHAR(50) NOT NULL,
    agence_id INT NOT NULL,
    produit_id INT NOT NULL,
    categorie_id INT NOT NULL,
    date_id INT NOT NULL,
    montant FLOAT NOT NULL,
    type_operation VARCHAR(20),
    devise VARCHAR(10),
    taux_change_eur FLOAT,
    montant_eur_verifie FLOAT,
    statut VARCHAR(20),
    is_anomaly BOOLEAN DEFAULT FALSE,
    solde_avant FLOAT,

    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES clients(client_id),
    CONSTRAINT fk_agence FOREIGN KEY (agence_id) REFERENCES agencies(agence_id),
    CONSTRAINT fk_product FOREIGN KEY (produit_id) REFERENCES products(produit_id),
    CONSTRAINT fk_category FOREIGN KEY (categorie_id) REFERENCES categories(categorie_id),
    CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);