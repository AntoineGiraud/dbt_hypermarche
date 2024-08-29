select
    * replace (
        strptime("Date de commande", '%m/%d/%Y')::date as "Date de commande",
        replace(Profit, ',', '.')::numeric as Profit
    )
from {{ ref('raw_achats') }}
