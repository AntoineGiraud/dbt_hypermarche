import random
import polars as pl
from faker import Faker
from datetime import timedelta

fake = Faker("fr_FR")


def generate_product_catalog():
    # Catégories et produits avec prix repère
    prix_unitaires = {
        "Pommes": 2.50,
        "Bananes": 2.20,
        "Carottes": 1.80,
        "Tomates": 2.90,
        "Salade": 1.50,
        "Pommes de terre": 2.00,
        "Poulet": 8.50,
        "Bœuf": 12.00,
        "Saumon": 15.00,
        "Thon": 14.00,
        "Jambon": 9.00,
        "Coca-Cola": 1.50,
        "Eau minérale": 0.80,
        "Vin rouge": 6.50,
        "Bière blonde": 1.20,
        "Jus d'orange": 2.00,
        "Pâtes": 1.20,
        "Riz": 1.50,
        "Huile d'olive": 5.00,
        "Farine": 1.00,
        "Sucre": 1.10,
        "Café": 3.50,
        "Lait demi-écrémé": 0.90,
        "Yaourt nature": 0.50,
        "Fromage Emmental": 4.00,
        "Beurre doux": 2.20,
        "Shampoing": 3.50,
        "Gel douche": 2.80,
        "Dentifrice": 2.50,
        "Savon": 1.20,
        "Lessive liquide": 7.00,
        "Liquide vaisselle": 2.00,
        "Sac poubelle": 3.00,
        "Papier toilette": 4.50,
    }

    categories = {
        "Fruits & Légumes": [
            "Pommes",
            "Bananes",
            "Carottes",
            "Tomates",
            "Salade",
            "Pommes de terre",
        ],
        "Viandes & Poissons": ["Poulet", "Bœuf", "Saumon", "Thon", "Jambon"],
        "Boissons": [
            "Coca-Cola",
            "Eau minérale",
            "Vin rouge",
            "Bière blonde",
            "Jus d'orange",
        ],
        "Épicerie": ["Pâtes", "Riz", "Huile d'olive", "Farine", "Sucre", "Café"],
        "Produits laitiers": [
            "Lait demi-écrémé",
            "Yaourt nature",
            "Fromage Emmental",
            "Beurre doux",
        ],
        "Hygiène & Beauté": ["Shampoing", "Gel douche", "Dentifrice", "Savon"],
        "Maison": [
            "Lessive liquide",
            "Liquide vaisselle",
            "Sac poubelle",
            "Papier toilette",
        ],
    }

    products = []
    id_counter = 100000
    for cat, items in categories.items():
        for subcat in items:
            prod_id = f"PROD-{id_counter}"
            id_counter += 1
            price = prix_unitaires[subcat]
            products.append(
                {
                    "ID produit": prod_id,
                    "Catégorie": cat,
                    "Nom du produit": subcat,
                    "Prix unitaire": price,
                }
            )

    return pl.DataFrame(products)


def generate_client_catalog(n=300):
    clients = []
    for i in range(n):
        clients.append(
            {
                "ID client": f"CLI-{10000 + i}",
                "Nom du client": fake.name(),
                "Adresse": fake.street_address(),
                "Ville": fake.city(),
                "Région": fake.region(),
                "Pays": "France",
                "Segment": random.choice(
                    ["Grand public", "Entreprise", "Petite et moyenne entreprise"]
                ),
            }
        )
    return pl.DataFrame(clients)


def generate_orders(products_df, clients_df, n=1000):
    orders = []
    for i in range(n):
        order_id = f"ORD-{20000 + i}"
        client = clients_df.sample(1).to_dicts()[0]
        date_commande = fake.date_between(start_date="-1y", end_date="today")
        date_expedition = date_commande + timedelta(days=random.randint(1, 7))
        statut = random.choice(["Normal", "Silver", "Premium"])

        for _ in range(random.randint(1, 5)):
            product = products_df.sample(1).to_dicts()[0]
            quantite = random.randint(1, 10)
            remise = round(random.choice([0, 0.1, 0.2, 0.5]), 2)
            montant = round(product["Prix unitaire"] * quantite * (1 - remise), 2)
            profit = round(montant * random.uniform(0.05, 0.3), 2)

            orders.append(
                {
                    "ID commande": order_id,
                    "Date de commande": date_commande,
                    "Date d'expédition": date_expedition,
                    "Statut commande": statut,
                    "ID client": client["ID client"],
                    "Nom du client": client["Nom du client"],
                    "Ville": client["Ville"],
                    "Région": client["Région"],
                    "Pays": client["Pays"],
                    "Segment": client["Segment"],
                    "ID produit": product["ID produit"],
                    "Catégorie": product["Catégorie"],
                    "Nom du produit": product["Nom du produit"],
                    "Prix unitaire": product["Prix unitaire"],
                    "Quantité": quantite,
                    "Remise": remise,
                    "Montant des ventes": montant,
                    "Profit": profit,
                }
            )
    return pl.DataFrame(orders)


def main():
    products_df = generate_product_catalog()
    clients_df = generate_client_catalog(300)
    orders_df = generate_orders(products_df, clients_df, 1000)

    print("Catalogue produits :")
    products_df.write_parquet("produits.parquet")
    print(products_df.head())
    print("\nCatalogue clients :")
    clients_df.write_parquet("clients.parquet")
    print(clients_df.head())
    print("\nCommandes :")
    orders_df.write_parquet("achats.parquet")
    print(orders_df.head())

    # Exemple d'agrégation
    agg = orders_df.group_by("Segment").agg(
        [
            pl.sum("Montant des ventes").alias("Total ventes"),
            pl.sum("Profit").alias("Total profit"),
        ]
    )
    print("\nAgrégation par segment :")
    print(agg)


if __name__ == "__main__":
    main()
