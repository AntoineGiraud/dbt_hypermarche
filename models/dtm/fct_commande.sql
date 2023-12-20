with cmd as (
	SELECT
		id_commande,
		max(id_client) id_client,
		max(v.id_ville) id_ville,
		max(dt_commande) dt_commande,
		max(dt_expedition) dt_expedition,
		max(priorite) priorite,
		count(id_produit) nb_produits,
		sum(quantite) nb_articles,
		sum(montant_vente) montant_vente,
		sum(profit) profit
	FROM {{ ref('stg_commande') }} a
	  left join {{ ref('dim_ville') }} v
	  	on a.ville_nom=v.nom
	  		and a.ville_region=v.region
	  		and a.ville_pays=v.pays
	  		and a.ville_zone=v."zone"
	group by 1
)
select
    cmd.id_commande,
    cmd.id_client,
    cmd.id_ville,
    cmd.priorite,
	coalesce(r.est_retourne, 0) est_retourne,
    cmd.dt_commande,
    cmd.dt_expedition,
	date_diff('day', dt_expedition, dt_commande) delai_expedition,
    cmd.nb_produits,
    cmd.nb_articles,
    cmd.montant_vente,
    cmd.profit
from cmd
  left join {{ ref('stg_retour_commande') }} r using(id_commande)