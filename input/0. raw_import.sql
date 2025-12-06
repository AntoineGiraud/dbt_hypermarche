select version();

-- ctrl + enter dans dbeaver --> execute les lignes qui se touchent jq'au prochain ;
set VARIABLE path_input = '~\Documents\code\dbt_hypermarche\input\';
-- '~/' == 'C:\Users\AntoineGiraud/'
SELECT getvariable('path_input');


CREATE SCHEMA IF NOT EXISTS raw;

-- drop table achats;
-- drop table retours;
-- drop table personnes;

-- si on veut lire depuis un excel
--> doc: https://duckdb.org/docs/stable/guides/file_formats/excel_import.html
create or replace table raw.raw_achats as
  FROM read_xlsx(getvariable('path_input') || 'Hypermarche.xlsx', sheet = 'Achats', all_varchar = true);
create or replace table raw.raw_retours as
  FROM read_xlsx(getvariable('path_input') || 'Hypermarche.xlsx', sheet = 'Retours');
create or replace table raw.raw_personnes as
  FROM read_xlsx('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/Hypermarche.xlsx', sheet = 'Personnes');


-- si on veut lire des .csv
--> doc: https://duckdb.org/docs/stable/guides/file_formats/csv_import
create or replace table raw.raw_achats as
    SELECT * FROM read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/achats.csv', header=true, all_varchar=true);
create or replace table raw.raw_retours as
    FROM read_csv(getvariable('path_input') || 'retours.csv');
create or replace table raw.raw_personnes as
    FROM read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/personnes.csv');


SHOW all TABLES;
-- describe raw.achats;
-- SUMMARIZE raw.achats;

-- EXPORT DATABASE '\output' (FORMAT PARQUET);
