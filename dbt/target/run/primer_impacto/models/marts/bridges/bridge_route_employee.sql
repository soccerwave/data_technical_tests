
  
    

    create or replace table `primer-impacto-test`.`primer_analytics_marts`.`bridge_route_employee`
      
    
    

    
    OPTIONS()
    as (
      select
    route_employee_id,
    route_id,
    employee_id,
    main_employee,
    ip_percentage,
    created_at,
    updated_at,
    deleted_at

from `primer-impacto-test`.`primer_analytics_staging`.`stg_route_employee`
    );
  