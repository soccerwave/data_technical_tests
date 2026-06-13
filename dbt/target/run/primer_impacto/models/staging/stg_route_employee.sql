

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_route_employee`
  OPTIONS()
  as select
    cast(route_employee_id as string) as route_employee_id,
    cast(route_id as string) as route_id,
    cast(employee_id as string) as employee_id,

    safe_cast(main_employee as bool) as main_employee,
    safe_cast(ip_percentage as float64) as ip_percentage,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at as date) as updated_at,
    safe_cast(deleted_at as date) as deleted_at

from `primer-impacto-test`.`primer_raw`.`raw_route_employee`;

