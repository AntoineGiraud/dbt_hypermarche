select
    * replace (
        strptime("Date de commande", '%m/%d/%Y')::date as "Date de commande",
        replace(Profit, ',', '.')::numeric as Profit
    )
from read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/achats.csv', header=true, all_varchar=true)