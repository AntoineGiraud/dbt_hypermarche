# Industrialisation des transformations SQL préparées dans le TD1

## Contexte & objectifs

Pouvoir industrialiser, à l'aide de DBT, les transformations SQL préparées dans le TD1 sur nos données d'hypermarché.

Les requêtes SQL du TD1 sont dans le dossier `input`

Etapes:
- installation de DBT (python 3.12 non supporté actuellement)
- transférer les req SQL du TD1 (`./input/`) dans le projet DBT
  ```sql
    select *
    from {{ ref('stg_commande') }}
    ```
- commencer à documenter les tables/colonnes & hypothèses prises
- ajouter des tests fonctionnels (règles métiers particulières) & techniques (pk, not null)
  pour confirmer nos hypothèses de modélisation
- Pensez à consulter la page html de documentation générée pour explorer le lineage & les tables crées
  #DataCatalog

## Commandes dbt importantes

- `dbt compile`  
  Voir si nos scripts sont valides
- `dbt build`  
  Pour déployer nos scripts dans la BDD  
  équivalent de dbt run + dbt test
- `dbt docs generate`  
  Pour préparer la documentation
- `dbt docs serve`  
  Pour lancer un serveur web pour explorer la doc & le lineage
- `dbt build -s +stg_commande+`  
  Pour déployer tout avant & après la table stg_commande

## Installation & config manuelle de DBT

- `pip install dbt-duckdb` [doc](https://github.com/duckdb/dbt-duckdb)
- `dbt init`  
  *pour initialiser le fichier `~/.dbt/.profiles` [doc](https://docs.getdbt.com/docs/configure-your-profile)*
    - exemple config duckdb
        ``` yml
        exo_hypermarche_dbt:
          target: dev
          outputs:
            dev:
              type: duckdb
              path: hypermarche.db
              extensions: # si besoin
                # - httpfs
                # - spatial
              threads: 2
        ```
    - exemple config postgresql
        ``` yml
        dbt_test_ag:
          target: dev
          outputs:
            dev:
              type: postgres
              host: localhost
              user: postgres
              password: ""
              port: 5432
              database: postgres
              schema: dbt_test
        ```        
- préparer les dossier/étapes dans `models`
  - `src` : 1 fichier `.yml` par source (ex: `src_hypermarche.yml`)
  - `raw` : normalement, on ne gère pas trop l'ingestion avec DBT O:) car la BDD ne le permet pas souvent
  - `stg` : schéma transitoire (parfois appelé ODS) 1 pour 1 avec les tables brutes, on y fait qq normalisations, renommages ...
  - `dtm` : schéma final prêt pour analyse
- préparer le fichier `dbt_project.yml`
  - on y défini quel profil utiliser
  - on y défini telle étape va dans tel schéma
    par exemple:
    ``` yml
    models:
      exo_hypermarche_dbt:
        dtm:
          +materialized: table
          +schema: dtm
          +tags: [dtm]
          # dbt va pousser les docs vers la BDD
          +persist_docs:
              relation: true
              columns: true
    ```
- revoir le nommage par défaut des tables : `macros/generate_schema_name.sql`
- lister les tables sources ex: `src/src_hypermarche.yml`
  - dans Duck DB, on peut utiliser un attribut meta pour charger les données directement
    ```yml
    sources:
      - name: hypermarche
        tables:
          - name: achats
              meta:
              external_location: "read_csv('input/achats.csv', AUTO_DETECT=TRUE, header=true, all_varchar=true)"
    ```
  - on pourra les appeler comme suit :
    ```sql
    select *
    from {{ source('hypermarche', 'achats') }}
    ```
- commencer à transvaser nos req SQL préparées au TD1
  - 1 fichier par table !
  - une fois une table staging prête, on peut l'appeler comme suit :
    ```sql
    select *
    from {{ ref('stg_commande') }}
    ```

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
