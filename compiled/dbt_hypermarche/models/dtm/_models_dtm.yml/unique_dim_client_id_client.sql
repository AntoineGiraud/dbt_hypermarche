
    
    

select
    id_client as unique_field,
    count(*) as n_records

from "dbt_hypermarche"."dtm"."dim_client"
where id_client is not null
group by id_client
having count(*) > 1


