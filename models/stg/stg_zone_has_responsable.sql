select
    "Zone géographique" as "zone",
    "Responsable régional" as responsable
from {{ ref('raw_personnes') }}
