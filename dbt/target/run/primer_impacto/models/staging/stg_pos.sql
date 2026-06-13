

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_pos`
  OPTIONS()
  as select
    cast(intervention_point_id as string) as intervention_point_id,

    intervention_point_code,
    intervention_point_name,
    intervention_point_address,
    intervention_point_province,
    intervention_point_locality,
    cast(intervention_point_postal_code as string) as intervention_point_postal_code,

    safe_cast(intervention_point_latitude as float64) as intervention_point_latitude,
    safe_cast(intervention_point_longitude as float64) as intervention_point_longitude,
    safe_cast(intervention_point_is_active as bool) as intervention_point_is_active,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at as date) as updated_at

from `primer-impacto-test`.`primer_raw`.`raw_pos`;

