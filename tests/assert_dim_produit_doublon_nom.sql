{{ config(
    severity = 'warn'
) }}


SELECT id_produit, count(1) nb
FROM {{ ref('stg_commande') }}
group by 1
having count(1)>1