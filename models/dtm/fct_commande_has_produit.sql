select
    id_commande,
    dt_commande,
    id_ligne,
    id_produit,
    montant_vente,
    quantite,
    remise,
    profit,
    (montant_vente / quantite) as prix_unitaire,
    (montant_vente / quantite) * (1 + remise) as prix_unitaire_avant_remise
from {{ ref('stg_commande') }}
