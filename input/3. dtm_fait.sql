
-- table fait commande
create or replace table dtm.fct_commande as
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
	FROM stg.stg_commande a
	  left join dtm.dim_ville v
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
  left join stg.stg_retour_commande r using(id_commande)
;

-- table fait commande_has_produits
create or replace table dtm.fct_commande_has_produit as
SELECT
	id_commande,
	dt_commande,
	id_ligne,
	id_produit,
	montant_vente,
	quantite,
	remise,
	profit,
	(montant_vente/quantite) prix_unitaire,
	(montant_vente/quantite) * (1+remise) prix_unitaire_avant_remise
FROM hypermarche.stg.stg_commande;
