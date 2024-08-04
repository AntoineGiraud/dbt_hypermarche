with produit_brut as (
	select
        id_produit,
        max(produit_categorie) as categorie,
        max(produit_souscategorie) as souscategorie,
        max(produit_nom) as nom
		-- avg(montant_vente / quantite) as prix_unitaire,
		-- sum(montant_vente*(1+remise)) / sum(quantite) as prix_unitaire_v2
	from {{ ref('stg_commande') }}
	group by 1
), marque_double as (
	select 'Office Star' as marque union all
	select 'Binney & Smith' as marque union all
	select 'Wilson Jones' as marque
), produit as (
	select p.* exclude nom,
		coalesce(md.marque, split_part(nom, ' ', 1)) as marque,
		split_part(nom, ',', 2) as detail,
		split_part(nom, ',', 1) as nom,
		nom as nom_raw,
		-- position(',' in nom) as pos_virgule,
		-- len(nom) - LEN(REPLACE(nom, ',', '')) as nb_virgule
	from produit_brut p
	  left join marque_double md on 1=position(md.marque in p.nom)
)
select p.*
from produit p
order by 2,3,4,5,6