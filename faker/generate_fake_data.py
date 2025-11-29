from faker import Faker
import random
import polars as pl
from datetime import datetime, timedelta

fake = Faker("fr_FR")  # localisation française

rows = []
for i in range(1000):
    id_ligne = i + 1

    date_commande = fake.date_between(start_date="-2y", end_date="today")
    date_expedition = date_commande + timedelta(days=random.randint(2, 7))

    id_commande = f"FR-{date_commande.strftime('%Y%m%d')}-{random.randint(1000, 9999)}"

    statut = random.choice(["Normal", "Silver", "Premium"])
    id_client = f"{fake.lexify(text='??')}-{random.randint(10000, 20000)}"
    nom_client = fake.name()
    segment = random.choice(
        ["Grand public", "Entreprise", "Petite et moyenne entreprise"]
    )

    ville = fake.city()
    region = fake.region()
    pays = "France"
    zone = random.choice(["Nord", "Centre"])

    categorie = random.choice(["Fournitures de bureau", "Mobilier"])
    sous_cat = random.choice(["Papier", "Art", "Stockage", "Bibliothèques", "Meubles"])
    produit = fake.word().capitalize() + " " + fake.word()
    id_produit = f"{categorie[:3].upper()}-{sous_cat[:2].upper()}-{random.randint(10000000, 99999999)}"

    quantite = random.randint(1, 10)
    remise = round(random.choice([0, 0.1, 0.4]), 2)
    montant = round(random.uniform(10, 1000), 2)
    profit = round(montant * (1 - remise) * random.uniform(-0.5, 0.5), 2)

    rows.append(
        {
            "ID ligne": id_ligne,
            "ID commande": id_commande,
            "Date de commande": date_commande,
            "Date d'expédition": date_expedition,
            "Statut commande": statut,
            "ID client": id_client,
            "Nom du client": nom_client,
            "Segment": segment,
            "Ville": ville,
            "Région": region,
            "Pays": pays,
            "Zone géographique": zone,
            "ID produit": id_produit,
            "Catégorie": categorie,
            "Sous-catégorie": sous_cat,
            "Nom du produit": produit,
            "Montant des ventes": montant,
            "Quantité": quantite,
            "Remise": remise,
            "Profit": profit,
        }
    )

df = pl.DataFrame(rows)
df.write_csv("achats.csv")

print(df.head())
