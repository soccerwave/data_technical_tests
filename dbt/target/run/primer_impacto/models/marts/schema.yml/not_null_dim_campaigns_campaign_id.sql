
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_id
from `primer-impacto-test`.`primer_analytics_marts`.`dim_campaigns`
where campaign_id is null



  
  
      
    ) dbt_internal_test