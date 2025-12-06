select
    * replace (
        strptime("Date de commande", '%m/%d/%Y')::date as "Date de commande",
        replace(profit, ',', '.')::numeric as profit
    )
from {{ source("hypermarche", "achats") }}
