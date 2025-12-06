select version()
;

-- ctrl + enter dans dbeaver --> execute les lignes qui se touchent jq'au prochain ;
set variable path_input = '~/Documents/code/dbt_hypermarche/input/'
;
-- '~/' == 'C:\Users\AntoineGiraud/'
select getvariable('path_input')
;


create schema if not exists raw;

-- drop table achats;
-- drop table retours;
-- drop table personnes;
-- si on veut lire depuis un excel
-- > doc: https://duckdb.org/docs/stable/guides/file_formats/excel_import.html
create or replace table raw.raw_achats as
  from read_xlsx(getvariable('path_input') || 'Hypermarche.xlsx', sheet = 'Achats', all_varchar = true);
create or replace table raw.raw_retours as
  from read_xlsx(getvariable('path_input') || 'Hypermarche.xlsx', sheet = 'Retours');
create or replace table raw.raw_personnes as
  from read_xlsx('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/Hypermarche.xlsx', sheet = 'Personnes');


-- si on veut lire des .csv
-- > doc: https://duckdb.org/docs/stable/guides/file_formats/csv_import
create or replace table raw.raw_achats as
    select * from read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/achats.csv', header=true, all_varchar=true);
create or replace table raw.raw_retours as
    from read_csv(getvariable('path_input') || 'retours.csv');
create or replace table raw.raw_personnes as
    from read_csv('https://github.com/AntoineGiraud/dbt_hypermarche/raw/refs/heads/main/input/personnes.csv');


show all tables
;
-- describe raw.achats;
-- summarize raw.achats;
-- export database '\output' (format parquet);
