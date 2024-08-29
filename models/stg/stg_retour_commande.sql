select
    "ID commande" as id_commande,
    replace("Retourné", 'Oui', '1')::int as est_retourne
from {{ ref('raw_retours') }}
