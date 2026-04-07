-- indexes (performance)

create index idx_transactions_client
on transactions(client_id);

create index idx_transactions_date 
on transactions(date_id);

create index idx_transactions_agence
on transactions(agence_id);

create index idx_date_transaction
on date(date_transaction);

-- view (simplify joins)

create view vw_transactions_full as 
select
t.transaction_id,
c.client_id,
c.segment_client,
a.agence,
p.produit,
cat.categorie,
d.date_transaction,
d.annee,
d.mois,
t.montant,
t.type_operation,
t.devise,
t.statut
FROM transactions t
join clients c on t.client_id = c.client_id
join agencies a on t.agence_id = a.agence_id
join products p on t.produit_id = p.produit_id
join categories cat on t.categorie_id = cat.categorie_id
join date d on t.date_id = d.date_id;