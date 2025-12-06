-- CREATE schema IF NOT EXISTS stg;
create or replace table stg.stg_commande as
select
    "ID ligne" id_ligne,
    "ID commande" id_commande,
    strptime("Date de commande", '%m/%d/%Y')::date dt_commande,
    strptime("Date d'expédition", '%m/%d/%Y')::date dt_expedition,
    "Statut commande" priorite,
    "ID client" id_client,
    "Nom du client" client_nom,
    segment client_segment,
    ville ville_nom,
    région ville_region,
    pays ville_pays,
    "Zone géographique" ville_zone,
    "ID produit" id_produit,
    catégorie produit_categorie,
    "Sous-catégorie" produit_souscategorie,
    "Nom du produit" produit_nom,
    replace("Montant des ventes", ',', '.')::numeric montant_vente,
    quantité::int quantite,
    replace(remise, ',', '.')::numeric remise,
    replace(profit, ',', '.')::numeric profit
from raw.raw_achats
;


-- table des retours
create or replace table stg.stg_retour_commande as
select
	"ID commande" id_commande,
	replace("Retourné", 'Oui', 1)::int est_retourne
from raw.raw_retours
;


-- responsables des zones géographiques
create or replace table stg.stg_zone_has_responsable as
select
	"Zone géographique" "zone",
	"Responsable régional" responsable
from raw.raw_personnes
;
