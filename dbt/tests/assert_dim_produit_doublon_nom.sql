{{ config(severity="warn") }}


select id_produit, count(1) nb
from {{ ref("stg_commande") }}
group by 1
having count(1) > 1
