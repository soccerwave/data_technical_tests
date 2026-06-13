

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_projects`
  OPTIONS()
  as select
    cast(project_id as string) as project_id,
    project_name,
    project_code,

    cast(client_id as string) as client_id,
    client_code,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys,

    safe_cast(project_exportable as bool) as project_exportable

from `primer-impacto-test`.`primer_raw`.`raw_projects`;

