-- Remove the 'positive only' constraint on montant if your CSV contains negative debits
-- Instead, let's ensure montant is not NULL and check the credit score range
ALTER TABLE clients 
ADD CONSTRAINT check_credit_score 
CHECK (score_credit_client BETWEEN 300 AND 850);

-- Ensure exchange rate isn't negative
ALTER TABLE transactions
ADD CONSTRAINT check_exchange_rate 
CHECK (taux_change_eur >= 0);

-- Business Logic: Ensure specific columns are never empty
ALTER TABLE transactions ALTER COLUMN type_operation SET NOT NULL;
ALTER TABLE transactions ALTER COLUMN devise SET NOT NULL;
ALTER TABLE transactions ALTER COLUMN statut SET NOT NULL;