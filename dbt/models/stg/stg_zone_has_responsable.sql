select "Zone géographique" as "zone", "Responsable régional" as responsable
from {{ source("hypermarche", "personnes") }}
