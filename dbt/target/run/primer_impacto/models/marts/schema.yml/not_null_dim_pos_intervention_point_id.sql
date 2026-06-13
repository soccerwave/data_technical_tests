
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select intervention_point_id
from `primer-impacto-test`.`primer_analytics_marts`.`dim_pos`
where intervention_point_id is null



  
  
      
    ) dbt_internal_test