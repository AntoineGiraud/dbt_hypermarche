
CREATE SCHEMA IF NOT EXISTS raw;

-- drop table achats;
-- drop table retours;
-- drop table personnes;
create or replace table raw.raw_achats as
    SELECT * FROM read_csv('input/achats.csv', AUTO_DETECT=TRUE, header=true, all_varchar=true)
create or replace table raw.raw_retours as
    SELECT * FROM read_csv('input/retours.csv', AUTO_DETECT=TRUE, header=true, all_varchar=true)
create or replace table raw.raw_personnes as
    SELECT * FROM read_csv('input/personnes.csv', AUTO_DETECT=TRUE, header=true, all_varchar=true)

SHOW all TABLES;
-- describe raw.achats;
-- SUMMARIZE raw.achats;

-- EXPORT DATABASE '\output' (FORMAT PARQUET);