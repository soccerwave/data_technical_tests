
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select answer_id
from `primer-impacto-test`.`primer_analytics_marts`.`fct_responses`
where answer_id is null



  
  
      
    ) dbt_internal_test