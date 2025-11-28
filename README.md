# Industrialisation de l'enrichissement de données hypermarché 🛒

## Objectif & mission

🎯 **Objectif** : Industrialiser, à l'aide de dbt, les transformations SQL préparées dans le TD1 sur nos données d'hypermarché (dossier `input`).

**TODO**
- Cloner & préparer votre poste (cf. [Installation](#installation))
- Lancer un 1er `dbt build` & corriger ces 1ères erreurs (cf. [commandes dbt](#commandes-dbt-importantes))
- Transférer les req SQL du TD1 (`./input/`) dans le projet dbt <em style="color:lightgrey">- 1 model = 1 .sql, sans ;  à la fin</em>
- Commencer à documenter les tables/colonnes & hypothèses prises `{_sources|_models}.yml`
- Ajouter des tests techniques (pk, not null) & fonctionnels (règles métiers particulières) pour confirmer nos hypothèses de modélisation
- Explorer le catalogue & lineage de dbt-core `dbt docs generate`

## Resources

### Docs & eLearning

- Follow [dbt-fundamentals](https://learn.getdbt.com/courses/dbt-fundamentals-vs-code) tutorial
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)

### Outils

- [**dbt-core**](https://github.com/dbt-labs/dbt-core) enables data analysts and engineers to transform their data using the same practices that software engineers use to build applications.\
  ![dbt-core](https://github.com/dbt-labs/dbt-core/raw/202cb7e51e218c7b29eb3b11ad058bd56b7739de/etc/dbt-transform.png)
- [**git**](https://git-scm.com/install/windows) *version control system*
- [**VS Code**](https://code.visualstudio.com/) éditeur de code
  - [Power User for dbt](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user)
  - [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph)
- [**uv**](https://github.com/astral-sh/uv) extremely fast Python package & project manager, written in Rust.
- [**DuckDB**](https://duckdb.org/) analytical in-process SQL database
- [**DBeaver**](https://dbeaver.io/) Database Management Tool

### Installation

#### Récupérer les outils

- [git](https://git-scm.com/install/windows) ou
  `winget install --id Git.Git -e --source winget`
  - Dire à **git** qui nous sommes
    ```shell
    git config --global user.name "AntoineGiraud"
    git config --global user.email antoine.giraud@domaine.fr
    ```
- [uv](https://docs.astral.sh/uv/getting-started/installation/) ou
  `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"`
- [DuckDB](https://duckdb.org/install/?platform=windows&environment=cli) ou `winget install DuckDB.cli`
- [DBeaver](https://dbeaver.io/download/) ou [windows store](https://apps.microsoft.com/detail/9pnkdr50694p?hl=fr-FR&gl=FR)
- [VS Code](https://code.visualstudio.com/Download) ou [windows store](https://apps.microsoft.com/detail/xp9khm4bk9fz7q?hl=fr-FR&gl=FR)

#### Clone & setup local du projet

- `git clone https://github.com/AntoineGiraud/dbt_hypermarche.git`
- `cd dbt_hypermarche`
- `uv sync`
  - télécharge **python**
  - initialise un environnement virtuel python (venv)
  - télécharge les dépendances / extensions python
- `.venv/Scripts/activate.ps1` (unix `source .venv/bin/activate`)\
  rendre **dbt** disponible dans le terminal
- `code .` ouvrir dans VS Code le répertoire courrant

### Commandes dbt importantes

- `dbt ls` liste les modèles disponibles
- `dbt parse` vérifie la syntaxe et la validité des modèles
- `dbt compile` génère les requêtes SQL à partir des modèles
- `dbt build` exécute modèles + tests (équivalent `run` + `test`)
  - `dbt build -s +stg_commande+` construit tout ce qui précède / suit `stg_commande`
  - `dbt run` exécute les modèles sans tests
  - `dbt test` lance uniquement les tests sur les modèles déployés
- `dbt docs generate` génère la documentation du projet
  - `dbt docs serve` démarre un serveur web pour explorer la doc & le lineage
