with villes as (
	SELECT distinct
		ville_nom nom,
        ville_region region,
        ville_pays pays,
        ville_zone "zone"
	FROM {{ ref('stg_commande') }}
)
select
	ROW_NUMBER() over(order by "zone", pays, region, nom) id_ville,
	v.*,
	z.responsable
from villes v
  left join {{ ref('stg_zone_has_responsable') }} z using("zone")
order by id_ville