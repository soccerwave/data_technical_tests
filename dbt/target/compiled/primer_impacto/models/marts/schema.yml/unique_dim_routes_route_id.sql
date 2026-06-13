
    
    

with dbt_test__target as (

  select route_id as unique_field
  from `primer-impacto-test`.`primer_analytics_marts`.`dim_routes`
  where route_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


