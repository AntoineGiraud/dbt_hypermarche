with villes as (
    select distinct
        ville_nom as nom,
        ville_region as region,
        ville_pays as pays,
        ville_zone as "zone"
    from {{ ref('stg_commande') }}
)

select
    row_number() over (order by "zone", pays, region, nom) as id_ville,
    v.*,
    z.responsable
from villes as v
    left join {{ ref('stg_zone_has_responsable') }} as z using ("zone")
order by id_ville
