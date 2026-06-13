
    
    

with dbt_test__target as (

  select question_id as unique_field
  from `primer-impacto-test`.`primer_analytics_marts`.`dim_questions`
  where question_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


