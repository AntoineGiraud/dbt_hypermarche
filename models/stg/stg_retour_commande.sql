SELECT
	"ID commande" id_commande,
	replace("Retourné", 'Oui', 1)::int est_retourne
from {{ source('hypermarche', 'raw_hypermarche_retours') }}
