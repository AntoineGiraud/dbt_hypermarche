SELECT distinct
	id_client,
	client_nom nom,
	client_segment segment
FROM {{ ref('stg_commande') }}