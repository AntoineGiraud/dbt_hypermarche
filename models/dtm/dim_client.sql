select distinct
    id_client,
    client_nom as nom,
    client_segment as segment
from {{ ref('stg_commande') }}
