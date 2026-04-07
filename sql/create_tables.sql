CREATE TABLE clients (
	client_id INT PRIMARY KEY,
	score_credit_client FLOAT,
	categorie_risque TEXT,
	segment_client TEXT

);
create table agencies (
	agence_id int primary key,
	agence text
);

create table products (
	produit_id int primary key,
	produit text
);
create table categories (
	categorie_id int primary key,
	categorie text
);

create table date (
	date_id int primary key,
	date_transaction date,
	annee int,
	mois int,
	trimestre int,
	jour_semaine text
);

create table transactions (
	transaction_id int primary key,

	client_id int not null,
	agence_id int not null,
	produit_id int not null,
	categorie_id int not null,
	date_id int not null,
	montant float not null,
	type_operation text,
	devise text,
	taux_change_eur float,
	montant_eur_verifie float,
	statut text,
	is_anomaly boolean,

	FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (agence_id) REFERENCES agencies(agence_id),
    FOREIGN KEY (produit_id) REFERENCES products(produit_id),
    FOREIGN KEY (categorie_id) REFERENCES categories(categorie_id),
    FOREIGN KEY (date_id) REFERENCES date(date_id)
);



