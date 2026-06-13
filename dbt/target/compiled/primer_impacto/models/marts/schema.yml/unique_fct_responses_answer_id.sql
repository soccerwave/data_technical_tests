
    
    

with dbt_test__target as (

  select answer_id as unique_field
  from `primer-impacto-test`.`primer_analytics_marts`.`fct_responses`
  where answer_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


