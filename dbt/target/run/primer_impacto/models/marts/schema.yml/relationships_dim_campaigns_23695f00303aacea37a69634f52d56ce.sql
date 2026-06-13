
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select project_id as from_field
    from `primer-impacto-test`.`primer_analytics_marts`.`dim_campaigns`
    where project_id is not null
),

parent as (
    select project_id as to_field
    from `primer-impacto-test`.`primer_analytics_marts`.`dim_projects`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test