with produit_brut as (
	SELECT
        id_produit,
        max(produit_categorie) categorie,
        max(produit_souscategorie) souscategorie,
        max(produit_nom) nom
		-- avg(montant_vente / quantite) prix_unitaire,
		-- sum(montant_vente*(1+remise)) / sum(quantite) prix_unitaire_v2
	FROM {{ ref('stg_commande') }}
	group by 1
), marque_double as (
	select 'Office Star' marque union all
	select 'Binney & Smith' marque union all
	select 'Wilson Jones' marque
), produit as (
	select p.* exclude nom,
		coalesce(md.marque, split_part(nom, ' ', 1)) marque,
		split_part(nom, ',', 2) detail,
		split_part(nom, ',', 1) nom,
		nom nom_raw,
		-- position(',' in nom) pos_virgule,
		-- len(nom) - LEN(REPLACE(nom, ',', '')) nb_virgule
	from produit_brut p
	  left join marque_double md on 1=position(md.marque in p.nom)
)
select p.*
from produit p
order by 2,3,4,5,6