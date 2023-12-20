SELECT
	"Zone géographique" "zone",
	"Responsable régional" responsable
from {{ ref('raw_personnes') }}