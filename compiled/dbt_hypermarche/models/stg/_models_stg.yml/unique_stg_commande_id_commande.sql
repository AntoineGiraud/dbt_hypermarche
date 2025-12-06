
    
    

select
    id_commande as unique_field,
    count(*) as n_records

from "dbt_hypermarche"."stg"."stg_commande"
where id_commande is not null
group by id_commande
having count(*) > 1


