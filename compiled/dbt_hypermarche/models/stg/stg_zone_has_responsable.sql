select
    "Zone géographique" as "zone",
    "Responsable régional" as responsable
from read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/personnes.csv', header=true, all_varchar=true)