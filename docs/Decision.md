# Relational Model Design

## 1. Identification of Main Entities

From the dataset, each row represents a banking transaction. The main entities identified are:

* Clients
* Transactions
* Agencies
* Products
* Categories
* Date

Note:

* The Accounts entity was not included because no account-related data is available in the dataset.
* Segment is included within the Clients entity as it describes customer characteristics.

---

## 2. Entity-Relationship Diagram (ERD)

The relationships between entities are defined as follows:

Clients (1) ────< Transactions >──── (1) Agencies
│
├── Products
├── Categories
└── Date

Each transaction is linked to one client, one agency, one product, one category, and one date, while each of these entities can be associated with multiple transactions.

---

## 3. Schema Design (Table Structure)

The data was organized into the following tables:

Clients:

* client_id
* score_credit_client
* categorie_risque
* segment_client

Transactions:

* transaction_id
* client_id
* agence_id
* produit_id
* categorie_id
* date_id
* montant
* type_operation
* devise
* taux_change_eur
* montant_eur
* montant_eur_verifie
* statut
* is_anomaly

Agencies:

* agence_id
* agence

Products:

* produit_id
* produit

Categories:

* categorie_id
* categorie

Date:

* date_id
* date_transaction
* annee
* mois
* trimestre
* jour_semaine

---

## 4. Normalization (3NF)

The schema was normalized to Third Normal Form (3NF) to eliminate redundancy and ensure data integrity. The original dataset was a single flat table, which was decomposed into multiple related tables.

Each table represents a single entity, and all attributes depend only on the primary key. Transitive dependencies were eliminated by moving attributes to their appropriate tables. For example, client-related attributes depend on client_id and are stored in the Clients table, while agency, product, and category data were separated to avoid repetition.

The Date table was also introduced to store time-related attributes and improve analytical capabilities.

---

## 5. Primary Keys

Each table has a primary key to uniquely identify records:

* Clients → client_id
* Transactions → transaction_id
* Agencies → agence_id
* Products → produit_id
* Categories → categorie_id
* Date → date_id

---

## 6. Foreign Keys

Foreign keys are defined in the Transactions table to establish relationships:

* client_id → Clients(client_id)
* agence_id → Agencies(agence_id)
* produit_id → Products(produit_id)
* categorie_id → Categories(categorie_id)
* date_id → Date(date_id)

---

## 7. Constraints

Constraints were defined at the design level to ensure data integrity and will be implemented during the database creation phase.

* NOT NULL constraints for essential fields such as client_id, agence_id, produit_id, categorie_id, date_id, and montant
* UNIQUE constraint on transaction_id
* CHECK constraints such as montant > 0 and taux_change_eur >= 0
* BOOLEAN type for is_anomaly

---

## 8. Design Justification

The Transactions table is the central table because each row represents a transaction. Other entities were separated to reduce redundancy and improve data consistency.

Using IDs instead of text values improves performance and ensures reliable relationships between tables. The Date table allows easier time-based analysis and avoids recalculating date attributes.

The schema follows 3NF principles, ensuring a clean, scalable, and efficient database structure suitable for analytical queries.
