create schema dtm;

------------------------------------------------------

-- dim des clients
create or replace table dtm.dim_client as
SELECT distinct
	id_client,
	client_nom nom,
	client_segment segment
FROM stg.stg_commande;

------------------------------------------------------

-- dim des villes
create or replace table dtm.dim_ville as
with villes as (
	SELECT distinct
		ville_nom nom,
        ville_region region,
        ville_pays pays,
        ville_zone "zone"
	FROM stg.stg_commande
)
select
	ROW_NUMBER() over(order by "zone", pays, region, nom) as id_ville,
	md5(concat("zone", '||', pays, '||', region, '||', nom)) as cd_ville,
	v.*,
	z.responsable
from villes v
  left join stg.stg_zone_has_responsable z using("zone")
order by id_ville;


-- explo dim
select
	ROW_NUMBER() over(order by "zone", pays, region, nom) id_ville,
	md5( concat("zone", pays, region, nom ) ) cd_ville,
	nom, region, pays, zone
from dtm.dim_ville;

-- analyse villes en doublon
with double_ville as (
	SELECT nom, count(1) nb
	FROM dtm.dim_ville
	group by 1
	having count(1)>1
)
SELECT
	ROW_NUMBER() over(order by "zone", pays, region, nom) id_ville,
	md5( concat("zone", pays, region, nom ) ) cd_ville,
	nom, region, pays, zone, responsable
FROM dtm.dim_ville v
  inner join double_ville dv using(nom)
order by dv.nb desc, nom;

------------------------------------------------------

-- dim des produits
create or replace table dtm.dim_produit as
SELECT id_produit,
	max(produit_categorie) categorie,
	max(produit_souscategorie) souscategorie,
	max(produit_nom) nom,
	-- avg(montant_vente / quantite) prix_unitaire,
	-- sum(montant_vente*(1+remise)) / sum(quantite) prix_unitaire_v2
FROM stg.stg_commande
group by 1
order by 1;


-- analyse produit
with stg_produit as (
	SELECT distinct
        id_produit,
        produit_categorie categorie,
        produit_souscategorie souscategorie,
        produit_nom nom
	FROM stg.stg_commande
), t as (
	select * exclude nom,
		nom nom_raw,
		trim(replace(split_part(nom, ',', 1), split_part(nom, ' ', 1), '')) nom,
		split_part(nom, ' ', 1) marque,
		split_part(nom, ',', 2) detail,
		position(',' in nom) pos_virgule,
		len(nom) - LEN(REPLACE(nom, ',', '')) nb_virgule
	from stg_produit
)
select nom, count(1) nb, max(marque) marque, max(nom_raw) nom_raw
from t
group by 1
order by nom_raw;

-- table dim_produit bonifiée
create or replace table dtm.dim_produit as
with produit_brut as (
	SELECT distinct
        id_produit,
        produit_categorie categorie,
        produit_souscategorie souscategorie,
        produit_nom nom
		-- avg(montant_vente / quantite) prix_unitaire,
		-- sum(montant_vente*(1+remise)) / sum(quantite) prix_unitaire_v2
	FROM stg.stg_commande
), marque_double as (
	select 'Office Star' marque union all
	select 'Binney & Smith' marque union all
	select 'Wilson Jones' marque
), produit as (
	select p.* exclude nom,
		coalesce(md.marque, split_part(nom, ' ', 1)) marque,
		split_part(nom, ',', 2) detail,
		split_part(nom, ',', 1) nom,
		nom nom_raw,
		-- position(',' in nom) pos_virgule,
		-- len(nom) - LEN(REPLACE(nom, ',', '')) nb_virgule
	from produit_brut p
	  left join marque_double md on 1=position(md.marque in p.nom)
)
select p.*
from produit p
order by 2,3,4,5,6
