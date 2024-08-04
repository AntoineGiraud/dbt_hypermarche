with cmd as (
    select
        id_commande,
        max(id_client) as id_client,
        max(v.id_ville) as id_ville,
        max(dt_commande) as dt_commande,
        max(dt_expedition) as dt_expedition,
        max(priorite) as priorite,
        count(id_produit) as nb_produits,
        sum(quantite) as nb_articles,
        sum(montant_vente) as montant_vente,
        sum(profit) as profit
    from {{ ref('stg_commande') }} as a
      left join {{ ref('dim_ville') }} as v
        on
            a.ville_nom = v.nom
            and a.ville_region = v.region
            and a.ville_pays = v.pays
            and a.ville_zone = v."zone"
    group by 1
)

select
    cmd.id_commande,
    cmd.id_client,
    cmd.id_ville,
    cmd.priorite,
    coalesce(r.est_retourne, 0) as est_retourne,
    cmd.dt_commande,
    cmd.dt_expedition,
    date_diff('day', dt_expedition, dt_commande) as delai_expedition,
    cmd.nb_produits,
    cmd.nb_articles,
    cmd.montant_vente,
    cmd.profit
from cmd
    left join {{ ref('stg_retour_commande') }} as r using(id_commande)