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
FROM {{ ref('stg_commande') }}