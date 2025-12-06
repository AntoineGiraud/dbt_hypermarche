select
    "ID commande" as id_commande,
    replace("Retourné", 'Oui', 1)::int as est_retourne
from read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/retours.csv', header=true, all_varchar=true)