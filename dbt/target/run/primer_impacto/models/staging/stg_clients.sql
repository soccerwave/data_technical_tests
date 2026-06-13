

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_clients`
  OPTIONS()
  as select
    cast(client_id as string) as client_id,
    client_name,

    cast(company_id as string) as company_id,
    country,
    sector,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from `primer-impacto-test`.`primer_raw`.`raw_clients`;

