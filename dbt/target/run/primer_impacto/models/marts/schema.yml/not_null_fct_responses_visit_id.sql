
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select visit_id
from `primer-impacto-test`.`primer_analytics_marts`.`fct_responses`
where visit_id is null



  
  
      
    ) dbt_internal_test