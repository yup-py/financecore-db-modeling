alter table transactions
add constraint check_montant_positive check (montant > 0);

alter table transactions
add constraint check_taux_change_positive check (taux_change_eur >= 0);

alter table agencies
add constraint unique_agence unique (agence);

alter table products
add constraint unique_produit unique (produit);

alter table categories 
add constraint unique_categorie unique (categorie);

alter table transactions
alter column type_operation set not null;

alter table transactions
alter column devise set not null;